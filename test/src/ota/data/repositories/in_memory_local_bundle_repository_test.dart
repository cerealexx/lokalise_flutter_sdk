import 'package:flutter_test/flutter_test.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/repositories/in_memory_local_bundle_repository.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/bundle.dart';

void main() {
  group('InMemoryLocalBundleRepository - removeBundle', () {
    test('bundle exists', () async {
      // Given
      final bundle = Bundle.empty(projectId: '', appVersion: '');
      final localRepo = InMemoryLocalBundleRepository(bundle: bundle);

      // When
      final res = await localRepo.removeBundle();

      // Then
      expect(res, true);
      expect(localRepo.getBundle(), isNull);
    });

    test('bundle not exists ', () async {
      // Given
      final localRepo = InMemoryLocalBundleRepository(bundle: null);

      // When
      final res = await localRepo.removeBundle();

      // Then
      expect(res, false);
      expect(localRepo.getBundle(), isNull);
    });
  });

  group('InMemoryLocalBundleRepository - saveBundle', () {
    test('on empty', () async {
      // Given
      final localRepo = InMemoryLocalBundleRepository(bundle: null);

      // When
      final bundle = Bundle(
        projectId: 'test',
        translationVersion: 1,
        appVersion: '1',
        languageBundles: [],
      );
      final res = await localRepo.saveBundle(bundle: bundle);

      // Then
      expect(res, true);
      expect(localRepo.getBundle(), bundle);
    });

    test('on not empty', () async {
      // Given
      final bundle1 = Bundle(
        projectId: 'test',
        translationVersion: 1,
        appVersion: '1',
        languageBundles: [],
      );
      final localRepo = InMemoryLocalBundleRepository(bundle: bundle1);

      // When
      final bundle2 = Bundle(
        projectId: 'test',
        translationVersion: 2,
        appVersion: '1',
        languageBundles: [],
      );
      final res = await localRepo.saveBundle(bundle: bundle2);

      // Then
      expect(res, true);
      expect(localRepo.getBundle(), bundle2);
    });
  });

  group('InMemoryLocalBundleRepository - getBundle', () {
    test('exists', () {
      // Given
      final bundle = Bundle(
        projectId: 'test',
        translationVersion: 1,
        appVersion: '1',
        languageBundles: [],
      );
      final localRepo = InMemoryLocalBundleRepository(bundle: bundle);

      // When
      final result = localRepo.getBundle();

      // Then
      expect(result, bundle);
    });

    test('not exists', () {
      // Given
      final localRepo = InMemoryLocalBundleRepository(bundle: null);

      // When
      final result = localRepo.getBundle();

      // Then
      expect(result, isNull);
    });
  });
}
