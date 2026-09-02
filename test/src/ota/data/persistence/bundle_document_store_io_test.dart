import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/persistence/bundle_document_store_io.dart';
import 'package:path/path.dart' as path;

void main() {
  late Directory applicationSupport;
  late NativeBundleDocumentStore store;

  setUp(() async {
    applicationSupport = await Directory.systemTemp.createTemp(
      'lokalise_bundle_store_test_',
    );
    store = NativeBundleDocumentStore(
      applicationSupportDirectory: () async => applicationSupport,
    );
  });

  tearDown(() async {
    if (await applicationSupport.exists()) {
      await applicationSupport.delete(recursive: true);
    }
  });

  bool isJson(String value) {
    try {
      jsonDecode(value);
      return true;
    } catch (_) {
      return false;
    }
  }

  test('round trips and removes a document in Application Support', () async {
    const value = '{"version":1}';

    await store.replace(value, validator: isJson);

    expect(await store.read(), value);
    final bundleFile = File(
      path.join(
        applicationSupport.path,
        NativeBundleDocumentStore.storageDirectoryName,
        NativeBundleDocumentStore.bundleFileName,
      ),
    );
    expect(await bundleFile.exists(), isTrue);
    expect(await store.remove(), isTrue);
    expect(await store.read(), isNull);
    expect(await store.remove(), isFalse);
  });

  test('an interrupted temporary write never shadows the committed document',
      () async {
    const committed = '{"version":1}';
    await store.replace(committed, validator: isJson);
    final temporaryFile = File(
      path.join(
        applicationSupport.path,
        NativeBundleDocumentStore.storageDirectoryName,
        '${NativeBundleDocumentStore.bundleFileName}'
        '${NativeBundleDocumentStore.temporaryFileSuffix}',
      ),
    );
    await temporaryFile.writeAsString('{"partial":', flush: true);

    expect(await store.read(), committed);

    const replacement = '{"version":2}';
    await store.replace(replacement, validator: isJson);
    expect(await store.read(), replacement);
    expect(await temporaryFile.exists(), isFalse);
  });

  test('removal also cleans an abandoned temporary document', () async {
    final storageDirectory = Directory(
      path.join(
        applicationSupport.path,
        NativeBundleDocumentStore.storageDirectoryName,
      ),
    );
    await storageDirectory.create(recursive: true);
    final temporaryFile = File(
      path.join(
        storageDirectory.path,
        '${NativeBundleDocumentStore.bundleFileName}'
        '${NativeBundleDocumentStore.temporaryFileSuffix}',
      ),
    );
    await temporaryFile.writeAsString('{"partial":', flush: true);

    expect(await store.remove(), isTrue);
    expect(await temporaryFile.exists(), isFalse);
  });

  test('validation failure preserves the previously committed document',
      () async {
    const committed = '{"version":1}';
    await store.replace(committed, validator: isJson);

    await expectLater(
      store.replace('{"partial":', validator: isJson),
      throwsFormatException,
    );

    expect(await store.read(), committed);
  });

  test('replacement failure preserves the committed document and cleans temp',
      () async {
    const committed = '{"version":1}';
    await store.replace(committed, validator: isJson);
    final failingStore = NativeBundleDocumentStore(
      applicationSupportDirectory: () async => applicationSupport,
      atomicFileReplacement: (_, __) async {
        throw const FileSystemException('replacement failed');
      },
    );

    await expectLater(
      failingStore.replace('{"version":2}', validator: isJson),
      throwsA(isA<FileSystemException>()),
    );

    expect(await store.read(), committed);
    final temporaryFile = File(
      path.join(
        applicationSupport.path,
        NativeBundleDocumentStore.storageDirectoryName,
        '${NativeBundleDocumentStore.bundleFileName}'
        '${NativeBundleDocumentStore.temporaryFileSuffix}',
      ),
    );
    expect(await temporaryFile.exists(), isFalse);
  });
}
