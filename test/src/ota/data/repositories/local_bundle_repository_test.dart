import 'package:flutter_test/flutter_test.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/persistence/bundle_persistence.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/persistence/entities/bundle_entity.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/repositories/local_bundle_repository.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/bundle.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'local_bundle_repository_test.mocks.dart';

@GenerateMocks([BundlePersistence])
void main() {
  late LocalBundleRepository localRepo;
  late MockBundlePersistence persistenceMock;

  setUp(() {
    persistenceMock = MockBundlePersistence();
    localRepo = LocalBundleRepository(persistence: persistenceMock);
  });

  group('LocalBundleRepository - removeBundle', () {
    test('persistence returns true', () async {
      // Given
      when(persistenceMock.remove()).thenAnswer((_) => Future.value(true));

      // When
      final res = await localRepo.removeBundle();

      // Then
      expect(res, true);
    });

    test('persistence returns false', () async {
      // Given
      when(persistenceMock.remove()).thenAnswer((_) => Future.value(false));

      // When
      final res = await localRepo.removeBundle();

      // Then
      expect(res, false);
    });
  });

  group('LocalBundleRepository - saveBundle', () {
    test('persistence returns true', () async {
      // Given
      final bundle = Bundle(
        projectId: 'test',
        translationVersion: 1,
        appVersion: '1',
        languageBundles: [],
      );
      when(persistenceMock.save(bundleEntity: anyNamed('bundleEntity')))
          .thenAnswer((_) => Future.value(true));

      // When
      final res = await localRepo.saveBundle(bundle: bundle);

      // Then
      expect(res, true);
    });

    test('persistence returns false', () async {
      // Given
      final bundle = Bundle(
        projectId: 'test',
        translationVersion: 1,
        appVersion: '1',
        languageBundles: [],
      );
      when(persistenceMock.save(bundleEntity: anyNamed('bundleEntity')))
          .thenAnswer((_) => Future.value(false));

      // When
      final res = await localRepo.saveBundle(bundle: bundle);

      // Then
      expect(res, false);
    });
  });

  group('LocalBundleRepository - getBundle', () {
    test('exists', () {
      // Given
      final entity = BundleEntity(
        projectId: 'test',
        translationVersion: 1,
        appVersion: '2',
        translations: {},
      );
      when(persistenceMock.get()).thenReturn(entity);

      // When
      final result = localRepo.getBundle();

      // Then
      expect(result, isNotNull);
      expect(result!.projectId, equals(entity.projectId));
      expect(result.appVersion, equals(entity.appVersion));
      expect(result.translationVersion, equals(entity.translationVersion));
      expect(result.languageBundles, isEmpty);
    });

    test('not exists', () {
      // Given
      when(persistenceMock.get()).thenReturn(null);

      // When
      final result = localRepo.getBundle();

      // Then
      expect(result, isNull);
    });
  });
}
