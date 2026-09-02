import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/persistence/bundle_document_store_factory.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/persistence/bundle_document_store_web.dart'
    hide createBundleDocumentStore;
import 'package:lokalise_flutter_sdk/src/ota/data/persistence/bundle_persistence.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/persistence/entities/bundle_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

void runTests() {
  late WebBundleDocumentStore store;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    store = WebBundleDocumentStore(
      databaseName:
          'lokalise_flutter_sdk_test_${DateTime.now().microsecondsSinceEpoch}',
    );
  });

  test('the web factory selects IndexedDB storage', () {
    expect(createBundleDocumentStore(), isA<WebBundleDocumentStore>());
  });

  bool isJson(String value) {
    try {
      jsonDecode(value);
      return true;
    } catch (_) {
      return false;
    }
  }

  test('round trips transactionally and removes a document', () async {
    const first = '{"version":1}';
    const second = '{"version":2}';

    await store.replace(first, validator: isJson);
    expect(await store.read(), first);

    await store.replace(second, validator: isJson);
    expect(await store.read(), second);

    expect(await store.remove(), isTrue);
    expect(await store.read(), isNull);
    expect(await store.remove(), isFalse);
  });

  test('failed validation cannot replace the committed record', () async {
    const committed = '{"version":1}';
    await store.replace(committed, validator: isJson);

    await expectLater(
      store.replace('{"partial":', validator: isJson),
      throwsFormatException,
    );

    expect(await store.read(), committed);
  });

  test('corrupt IndexedDB data is ignored by bundle persistence', () async {
    await store.replace('not json', validator: (_) => true);
    final persistence = BundlePersistence(
      sharedPreferences: await SharedPreferences.getInstance(),
      documentStore: store,
    );

    expect(await persistence.get(), isNull);
  });

  test('migrates legacy preferences into IndexedDB before cleanup', () async {
    final bundle = BundleEntity(
      projectId: 'project',
      translationVersion: 7,
      appVersion: '1.0.0',
      translations: {},
    );
    final legacyValue = jsonEncode(bundle.toJson());
    SharedPreferences.setMockInitialValues({
      BundlePersistence.legacyBundleKey: legacyValue,
    });
    final preferences = await SharedPreferences.getInstance();
    final persistence = BundlePersistence(
      sharedPreferences: preferences,
      documentStore: store,
    );

    final migrated = await persistence.get();

    expect(migrated?.translationVersion, 7);
    expect(await store.read(), legacyValue);
    expect(
      preferences.getString(BundlePersistence.legacyBundleKey),
      isNull,
    );
  });
}
