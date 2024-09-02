import 'package:flutter_test/flutter_test.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/data_source/local_bundle_data_source.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/bundle.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/services/logger.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/use_cases/get_local_bundle_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_local_bundle_use_case_test.mocks.dart';

@GenerateMocks([LocalBundleDataSource, Logger])
void main() {
  late MockLocalBundleDataSource localDataSource;
  late MockLogger logger;
  late GetLocalBundleUseCase useCase;

  setUp(() {
    localDataSource = MockLocalBundleDataSource();
    logger = MockLogger();
    useCase = GetLocalBundleUseCase(
      localBundleDataSource: localDataSource,
      logger: logger,
    );
  });

  group('GetLocalBundleUseCase - getBundle', () {
    test('localDataSource.getBundle throw exception', () async {
      // Given
      final exception = Exception();
      when(localDataSource.getBundle()).thenThrow(exception);

      // When
      const projectId = 'test-project';
      const appVersion = 'test-appVersion';
      final res = await useCase.getBundle(
        projectId: projectId,
        appVersion: appVersion,
      );

      // Then
      expect(res.projectId, equals(projectId));
      expect(res.appVersion, equals(appVersion));
      expect(res.translationVersion, equals(0));
      expect(res.languageBundles, isEmpty);
      verify(logger.exception(exception)).called(1);
    });

    test('localDataSource.getBundle returns null', () async {
      // Given
      when(localDataSource.getBundle()).thenReturn(null);

      // When
      const projectId = 'test-project';
      const appVersion = 'test-appVersion';
      final res = await useCase.getBundle(
        projectId: projectId,
        appVersion: appVersion,
      );

      // Then
      expect(res.projectId, equals(projectId));
      expect(res.appVersion, equals(appVersion));
      expect(res.translationVersion, equals(0));
      expect(res.languageBundles, isEmpty);
      verifyNever(logger.exception(any));
    });

    test('remove bundle throw exception', () async {
      // Given
      const appVersion = 'test-appVersion';
      final bundle = Bundle(
        projectId: 'another',
        translationVersion: 1,
        appVersion: appVersion,
        languageBundles: [],
      );
      when(localDataSource.getBundle()).thenReturn(bundle);
      final exception = Exception();
      when(localDataSource.removeBundle()).thenThrow(exception);

      // When
      const projectId = 'test-projectId';
      final res = await useCase.getBundle(
        projectId: projectId,
        appVersion: appVersion,
      );

      // Then
      expect(res.projectId, equals(projectId));
      expect(res.appVersion, equals(appVersion));
      expect(res.translationVersion, equals(0));
      expect(res.languageBundles, isEmpty);
      verify(logger.exception(exception)).called(1);
    });

    test('bundle with a different project id', () async {
      // Given
      const appVersion = 'test-appVersion';
      final bundle = Bundle(
        projectId: 'another',
        translationVersion: 1,
        appVersion: appVersion,
        languageBundles: [],
      );
      when(localDataSource.getBundle()).thenReturn(bundle);
      when(localDataSource.removeBundle())
          .thenAnswer((_) => Future.value(true));

      // When
      const projectId = 'test-projectId';
      final res = await useCase.getBundle(
        projectId: projectId,
        appVersion: appVersion,
      );

      // Then
      expect(res.projectId, equals(projectId));
      expect(res.appVersion, equals(appVersion));
      expect(res.translationVersion, equals(0));
      expect(res.languageBundles, isEmpty);
      verifyNever(logger.exception(any));
    });

    test('bundle with a different app version', () async {
      // Given
      const projectId = 'test-projectId';
      final bundle = Bundle(
        projectId: projectId,
        translationVersion: 1,
        appVersion: 'another',
        languageBundles: [],
      );
      when(localDataSource.getBundle()).thenReturn(bundle);
      when(localDataSource.removeBundle())
          .thenAnswer((_) => Future.value(true));

      // When
      const appVersion = 'test-appVersion';
      final res = await useCase.getBundle(
        projectId: projectId,
        appVersion: appVersion,
      );

      // Then
      expect(res.projectId, equals(projectId));
      expect(res.appVersion, equals(appVersion));
      expect(res.translationVersion, equals(0));
      expect(res.languageBundles, isEmpty);
      verifyNever(logger.exception(any));
    });

    test('success', () async {
      // Given
      const projectId = 'test-projectId';
      const appVersion = 'test-appVersion';
      final bundle = Bundle(
        projectId: projectId,
        translationVersion: 1,
        appVersion: appVersion,
        languageBundles: [],
      );
      when(localDataSource.getBundle()).thenReturn(bundle);
      when(localDataSource.removeBundle())
          .thenAnswer((_) => Future.value(true));

      // When
      final res = await useCase.getBundle(
        projectId: projectId,
        appVersion: appVersion,
      );

      // Then
      expect(res, equals(bundle));
      verifyNever(logger.exception(any));
    });
  });
}
