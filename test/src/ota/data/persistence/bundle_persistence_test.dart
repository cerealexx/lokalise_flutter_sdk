import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/persistence/bundle_document_store.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/persistence/bundle_persistence.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/persistence/entities/bundle_entity.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/translation/simple_translation.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bundle_persistence_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  final bundle = BundleEntity(
    projectId: '1abc23',
    appVersion: '10',
    translationVersion: 125,
    translations: {
      'en': {
        'key': SimpleTranslation(elements: []),
      }
    },
  );
  final encodedBundle = jsonEncode(bundle.toJson());

  late MockSharedPreferences sharedPreferences;
  late MemoryBundleDocumentStore documentStore;
  late BundlePersistence persistence;

  setUp(() {
    sharedPreferences = MockSharedPreferences();
    documentStore = MemoryBundleDocumentStore();
    persistence = BundlePersistence(
      sharedPreferences: sharedPreferences,
      documentStore: documentStore,
    );
  });

  group('save', () {
    test('round trips the unchanged BundleEntity JSON in the document store',
        () async {
      final result = await persistence.save(bundleEntity: bundle);

      expect(result, isTrue);
      expect(documentStore.value, encodedBundle);
      expect(documentStore.replaceCalls, 1);
      verifyNever(sharedPreferences.setString(any, any));

      final storedBundle = await persistence.get();
      expect(storedBundle?.projectId, bundle.projectId);
      expect(storedBundle?.appVersion, bundle.appVersion);
      expect(storedBundle?.translationVersion, bundle.translationVersion);
      expect(storedBundle?.translations.keys, bundle.translations.keys);
    });

    test('returns false when replacement fails', () async {
      documentStore.replaceError = Exception('disk full');

      expect(await persistence.save(bundleEntity: bundle), isFalse);
    });

    test('cleans up legacy data after a verified save', () async {
      when(sharedPreferences.getString(BundlePersistence.legacyBundleKey))
          .thenReturn(encodedBundle);
      when(sharedPreferences.remove(BundlePersistence.legacyBundleKey))
          .thenAnswer((_) async => true);

      expect(await persistence.save(bundleEntity: bundle), isTrue);
      verify(sharedPreferences.remove(BundlePersistence.legacyBundleKey))
          .called(1);
    });

    test('returns false when read-back does not match the committed value',
        () async {
      documentStore.valueAfterReplace = '{"corrupt":true}';

      expect(await persistence.save(bundleEntity: bundle), isFalse);
    });
  });

  group('get and legacy migration', () {
    test('prefers a valid document and cleans up a legacy value', () async {
      documentStore.value = encodedBundle;
      when(sharedPreferences.getString(BundlePersistence.legacyBundleKey))
          .thenReturn('{"different":"legacy"}');
      when(sharedPreferences.remove(BundlePersistence.legacyBundleKey))
          .thenAnswer((_) async => true);

      final result = await persistence.get();

      expect(result?.translationVersion, bundle.translationVersion);
      expect(documentStore.replaceCalls, 0);
      verify(sharedPreferences.remove(BundlePersistence.legacyBundleKey))
          .called(1);
    });

    test('migrates, reads back, then removes a valid legacy value', () async {
      when(sharedPreferences.getString(BundlePersistence.legacyBundleKey))
          .thenReturn(encodedBundle);
      when(sharedPreferences.remove(BundlePersistence.legacyBundleKey))
          .thenAnswer((_) async => true);

      final result = await persistence.get();

      expect(result?.translationVersion, bundle.translationVersion);
      expect(documentStore.value, encodedBundle);
      expect(documentStore.readCalls, 2);
      verify(sharedPreferences.remove(BundlePersistence.legacyBundleKey))
          .called(1);
    });

    test('migration is idempotent after legacy cleanup fails', () async {
      when(sharedPreferences.getString(BundlePersistence.legacyBundleKey))
          .thenReturn(encodedBundle);
      when(sharedPreferences.remove(BundlePersistence.legacyBundleKey))
          .thenAnswer((_) async => false);

      expect((await persistence.get())?.translationVersion, 125);
      expect((await persistence.get())?.translationVersion, 125);

      expect(documentStore.replaceCalls, 1);
      verify(sharedPreferences.remove(BundlePersistence.legacyBundleKey))
          .called(2);
    });

    test('uses and retains legacy data when migration write fails', () async {
      documentStore.replaceError = Exception('unavailable');
      when(sharedPreferences.getString(BundlePersistence.legacyBundleKey))
          .thenReturn(encodedBundle);

      final result = await persistence.get();

      expect(result?.translationVersion, bundle.translationVersion);
      verifyNever(sharedPreferences.remove(any));
    });

    test('uses and retains legacy data when migration read-back is corrupt',
        () async {
      documentStore.valueAfterReplace = '{"corrupt":true}';
      when(sharedPreferences.getString(BundlePersistence.legacyBundleKey))
          .thenReturn(encodedBundle);

      final result = await persistence.get();

      expect(result?.translationVersion, bundle.translationVersion);
      verifyNever(sharedPreferences.remove(any));
    });

    test('replaces a corrupt document from a valid legacy value', () async {
      documentStore.value = 'not json';
      when(sharedPreferences.getString(BundlePersistence.legacyBundleKey))
          .thenReturn(encodedBundle);
      when(sharedPreferences.remove(BundlePersistence.legacyBundleKey))
          .thenAnswer((_) async => true);

      final result = await persistence.get();

      expect(result?.translationVersion, bundle.translationVersion);
      expect(documentStore.value, encodedBundle);
    });

    test('returns null for corrupt document and corrupt legacy data', () async {
      documentStore.value = 'not json';
      when(sharedPreferences.getString(BundlePersistence.legacyBundleKey))
          .thenReturn('{"missing":"bundle fields"}');

      expect(await persistence.get(), isNull);
      verifyNever(sharedPreferences.remove(any));
    });

    test('returns null when neither store has a value', () async {
      when(sharedPreferences.getString(BundlePersistence.legacyBundleKey))
          .thenReturn(null);

      expect(await persistence.get(), isNull);
    });
  });

  group('remove', () {
    test('removes both document and legacy values', () async {
      documentStore.value = encodedBundle;
      when(sharedPreferences.remove(BundlePersistence.legacyBundleKey))
          .thenAnswer((_) async => true);

      expect(await persistence.remove(), isTrue);
      expect(documentStore.value, isNull);
      verify(sharedPreferences.remove(BundlePersistence.legacyBundleKey))
          .called(1);
    });

    test('continues legacy cleanup when document removal fails', () async {
      documentStore.removeError = Exception('locked');
      when(sharedPreferences.remove(BundlePersistence.legacyBundleKey))
          .thenAnswer((_) async => true);

      expect(await persistence.remove(), isTrue);
      verify(sharedPreferences.remove(BundlePersistence.legacyBundleKey))
          .called(1);
    });

    test('reports false when neither store removes a value', () async {
      when(sharedPreferences.remove(BundlePersistence.legacyBundleKey))
          .thenAnswer((_) async => false);

      expect(await persistence.remove(), isFalse);
    });
  });
}

class MemoryBundleDocumentStore implements BundleDocumentStore {
  String? value;
  String? valueAfterReplace;
  Object? replaceError;
  Object? removeError;
  int readCalls = 0;
  int replaceCalls = 0;

  @override
  Future<String?> read() async {
    readCalls++;
    return value;
  }

  @override
  Future<void> replace(
    String value, {
    required BundleDocumentValidator validator,
  }) async {
    replaceCalls++;
    final error = replaceError;
    if (error != null) {
      throw error;
    }
    if (!validator(value)) {
      throw const FormatException('invalid');
    }
    this.value = valueAfterReplace ?? value;
  }

  @override
  Future<bool> remove() async {
    final error = removeError;
    if (error != null) {
      throw error;
    }
    final existed = value != null;
    value = null;
    return existed;
  }
}
