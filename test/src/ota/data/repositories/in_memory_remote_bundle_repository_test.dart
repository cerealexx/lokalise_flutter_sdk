import 'package:flutter_test/flutter_test.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/repositories/in_memory_remote_bundle_repository.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/dto/get_up_to_date_bundle_dto.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/bundle.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/credentials.dart';

void main() {
  final credentials = Credentials(projectId: '', token: '');

  group('RemoteTranslationRepository - getBundle', () {
    test('bundle not exists', () async {
      // Given
      final remoteRepo = InMemoryRemoteBundleRepository(bundle: null);

      // When
      final dto = GetUpToDateBundleDto(
        credentials: credentials,
        appVersion: '1',
        translationVersion: 1,
        preRelease: true,
      );
      final result = await remoteRepo.getBundle(
        getUpToDateBundleDto: dto,
      );

      // Then
      expect(result, isNull);
    });

    test('bundle exists - same version', () async {
      // Given
      final bundle = Bundle(
        projectId: 'test',
        translationVersion: 1,
        appVersion: '1',
        languageBundles: [],
      );
      final remoteRepo = InMemoryRemoteBundleRepository(bundle: bundle);

      // When
      final dto = GetUpToDateBundleDto(
        credentials: credentials,
        appVersion: '1',
        translationVersion: 1,
        preRelease: true,
      );
      final result = await remoteRepo.getBundle(
        getUpToDateBundleDto: dto,
      );

      // Then
      expect(result, isNull);
    });

    test('bundle exists - another version', () async {
      // Given
      final bundle = Bundle(
        projectId: 'test',
        translationVersion: 2,
        appVersion: '1',
        languageBundles: [],
      );
      final remoteRepo = InMemoryRemoteBundleRepository(bundle: bundle);

      // When
      final dto = GetUpToDateBundleDto(
        credentials: credentials,
        appVersion: '1',
        translationVersion: 1,
        preRelease: true,
      );
      final result = await remoteRepo.getBundle(
        getUpToDateBundleDto: dto,
      );

      // Then
      expect(result, bundle);
    });
  });
}
