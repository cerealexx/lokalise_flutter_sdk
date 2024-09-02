import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
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

  late MockSharedPreferences mockSharedPreferences;
  late BundlePersistence bundlePersistence;

  setUp(() async {
    mockSharedPreferences = MockSharedPreferences();
    bundlePersistence =
        BundlePersistence(sharedPreferences: mockSharedPreferences);
  });

  group('BundlePersistence - save', () {
    test('Success', () async {
      // Given
      when(mockSharedPreferences.setString(
              'lokalise_stored_bundle', jsonEncode(bundle.toJson())))
          .thenAnswer((_) => Future.value(true));

      // When
      final result = await bundlePersistence.save(bundleEntity: bundle);

      // Then
      expect(result, true);
    });

    test('Fail', () async {
      // Given
      when(mockSharedPreferences.setString(
              'lokalise_stored_bundle', jsonEncode(bundle.toJson())))
          .thenAnswer((_) => Future.value(false));

      // When
      final result = await bundlePersistence.save(bundleEntity: bundle);

      // Then
      expect(result, false);
    });
  });

  group('BundlePersistence - get', () {
    test('Exists', () async {
      // Given
      when(mockSharedPreferences.getString('lokalise_stored_bundle'))
          .thenReturn(jsonEncode(bundle.toJson()));

      // When
      final result = bundlePersistence.get();

      // Then
      expect(result, isNotNull);
      expect(result!.projectId, bundle.projectId);
      expect(result.appVersion, bundle.appVersion);
      expect(result.translationVersion, bundle.translationVersion);
      bundle.translations.forEach((key, value) {
        expect(result.translations.containsKey(key), true);
        expect(value.length, equals(result.translations[key]!.length));
      });
    });

    test('Not exists - null found', () async {
      // Given
      when(mockSharedPreferences.getString('lokalise_stored_bundle'))
          .thenReturn(null);

      // When
      final result = bundlePersistence.get();

      // Then
      expect(result, isNull);
    });

    test('Not exists - empty string found', () async {
      // Given
      when(mockSharedPreferences.getString('lokalise_stored_bundle'))
          .thenReturn('');

      // When
      final result = bundlePersistence.get();

      // Then
      expect(result, isNull);
    });
  });

  group('BundlePersistence - remove', () {
    test('Success', () async {
      // Given
      when(mockSharedPreferences.remove('lokalise_stored_bundle'))
          .thenAnswer((_) => Future.value(true));

      // When
      final result = await bundlePersistence.remove();

      // Then
      expect(result, true);
    });

    test('Fail', () async {
      // Given
      when(mockSharedPreferences.remove('lokalise_stored_bundle'))
          .thenAnswer((_) => Future.value(false));

      // When
      final result = await bundlePersistence.remove();

      // Then
      expect(result, false);
    });
  });
}
