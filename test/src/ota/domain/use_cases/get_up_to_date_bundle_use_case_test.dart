import 'package:flutter_test/flutter_test.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/data_source/local_bundle_data_source.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/data_source/remote_bundle_data_source.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/dto/get_up_to_date_bundle_dto.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/exceptions/auth_exception.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/exceptions/bundle_not_found_exception.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/exceptions/internal_exception.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/exceptions/lokalise_exception.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/bundle.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/credentials.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/services/logger.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/use_cases/get_up_to_date_bundle_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_up_to_date_bundle_use_case_test.mocks.dart';

@GenerateMocks([RemoteBundleDataSource, LocalBundleDataSource, Logger])
void main() {
  late MockRemoteBundleDataSource remoteDataSource;
  late MockLocalBundleDataSource localDataSource;
  late MockLogger logger;
  late GetUpToDateBundleUseCase useCase;

  setUp(() {
    remoteDataSource = MockRemoteBundleDataSource();
    localDataSource = MockLocalBundleDataSource();
    logger = MockLogger();
    useCase = GetUpToDateBundleUseCase(
      localBundleDataSource: localDataSource,
      remoteBundleDataSource: remoteDataSource,
      logger: logger,
    );
  });

  group('GetUpToDateBundleUseCase - getBundle', () {
    test('throw unexpected error', () async {
      // Given
      final dto = GetUpToDateBundleDto(
        credentials: Credentials(projectId: 'test', token: 'test'),
        appVersion: 'test',
        translationVersion: 1,
        preRelease: true,
      );
      final error = Error();
      when(remoteDataSource.getBundle(getUpToDateBundleDto: dto))
          .thenThrow(error);

      // When-Then
      expect(useCase.getBundle(dto: dto), throwsA(isA<LokaliseException>()));

      verifyNever(localDataSource.saveBundle(bundle: anyNamed('bundle')));
      verify(logger.exception(argThat(isA<LokaliseException>()))).called(1);
    });

    test('throw unexpected exception', () async {
      // Given
      final dto = GetUpToDateBundleDto(
        credentials: Credentials(projectId: 'test', token: 'test'),
        appVersion: 'test',
        translationVersion: 1,
        preRelease: true,
      );
      final exception = Exception();
      when(remoteDataSource.getBundle(getUpToDateBundleDto: dto))
          .thenThrow(exception);

      // When-Then
      expect(useCase.getBundle(dto: dto), throwsA(isA<LokaliseException>()));

      verifyNever(localDataSource.saveBundle(bundle: anyNamed('bundle')));
      verify(logger.exception(exception)).called(1);
    });

    test('throw InternalException', () async {
      // Given
      final dto = GetUpToDateBundleDto(
        credentials: Credentials(projectId: 'test', token: 'test'),
        appVersion: 'test',
        translationVersion: 1,
        preRelease: true,
      );
      final exception = InternalException.unexpected(param: 'error');
      when(remoteDataSource.getBundle(getUpToDateBundleDto: dto))
          .thenThrow(exception);

      // When-Then
      expect(useCase.getBundle(dto: dto), throwsA(isA<LokaliseException>()));

      verifyNever(localDataSource.saveBundle(bundle: anyNamed('bundle')));
      verify(logger.exception(exception)).called(1);
    });

    test('throw BundleNotFoundException', () async {
      // Given
      final dto = GetUpToDateBundleDto(
        credentials: Credentials(projectId: 'test', token: 'test'),
        appVersion: 'test',
        translationVersion: 1,
        preRelease: true,
      );

      when(remoteDataSource.getBundle(getUpToDateBundleDto: dto))
          .thenThrow(BundleNotFoundException());
      when(localDataSource.removeBundle())
          .thenAnswer((_) => Future.value(true));

      // When
      final res = await useCase.getBundle(dto: dto);

      // Then
      expect(res.languageBundles, isEmpty);
      expect(res.projectId, equals(dto.credentials.projectId));
      expect(res.appVersion, dto.appVersion);
      expect(res.translationVersion, equals(0));

      verifyNever(localDataSource.saveBundle(bundle: anyNamed('bundle')));
      verify(localDataSource.removeBundle()).called(1);
      verifyNever(logger.exception(any));
    });

    test('throw AuthException', () async {
      // Given
      final dto = GetUpToDateBundleDto(
        credentials: Credentials(projectId: 'test', token: 'test'),
        appVersion: 'test',
        translationVersion: 1,
        preRelease: true,
      );

      final exception = AuthException();
      when(remoteDataSource.getBundle(getUpToDateBundleDto: dto))
          .thenThrow(exception);
      when(localDataSource.removeBundle())
          .thenAnswer((_) => Future.value(true));

      // When
      final res = await useCase.getBundle(dto: dto);

      // Then
      expect(res.languageBundles, isEmpty);
      expect(res.projectId, equals(dto.credentials.projectId));
      expect(res.appVersion, dto.appVersion);
      expect(res.translationVersion, equals(0));

      verifyNever(localDataSource.saveBundle(bundle: anyNamed('bundle')));
      verify(localDataSource.removeBundle()).called(1);
      verify(logger.exception(exception)).called(1);
    });
    test('remote repo returns null', () async {
      // Given
      const translationVersion = 123;
      final dto = GetUpToDateBundleDto(
        credentials: Credentials(projectId: 'test', token: 'test'),
        appVersion: 'test',
        translationVersion: translationVersion,
        preRelease: true,
      );
      final localBundle = Bundle(
        projectId: 'local_test',
        translationVersion: translationVersion,
        appVersion: 'local_test',
        languageBundles: [],
      );

      when(remoteDataSource.getBundle(getUpToDateBundleDto: dto))
          .thenAnswer((realInvocation) => Future.value(null));
      when(localDataSource.getBundle()).thenReturn(localBundle);

      // When
      final res = await useCase.getBundle(dto: dto);

      // Then
      expect(res, equals(localBundle));

      verifyNever(localDataSource.saveBundle(bundle: anyNamed('bundle')));
      verify(localDataSource.getBundle()).called(1);
      verifyNever(logger.exception(any));
    });

    test('local bundle is the latest', () async {
      // Given
      const translationVersion = 123;
      final dto = GetUpToDateBundleDto(
        credentials: Credentials(projectId: 'test', token: 'test'),
        appVersion: 'test',
        translationVersion: translationVersion,
        preRelease: true,
      );
      final bundle = Bundle(
        projectId: 'test',
        translationVersion: translationVersion,
        appVersion: 'test',
        languageBundles: [],
      );
      final localBundle = Bundle(
        projectId: 'local_test',
        translationVersion: translationVersion,
        appVersion: 'local_test',
        languageBundles: [],
      );

      when(remoteDataSource.getBundle(getUpToDateBundleDto: dto))
          .thenAnswer((realInvocation) => Future.value(bundle));
      when(localDataSource.getBundle()).thenReturn(localBundle);

      // When
      final res = await useCase.getBundle(dto: dto);

      // Then
      expect(res, equals(localBundle));

      verifyNever(localDataSource.saveBundle(bundle: anyNamed('bundle')));
      verify(localDataSource.getBundle()).called(1);
      verifyNever(logger.exception(any));
    });

    test('newer bundle received', () async {
      // Given
      const translationVersion = 123;
      final dto = GetUpToDateBundleDto(
        credentials: Credentials(projectId: 'test', token: 'test'),
        appVersion: 'test',
        translationVersion: translationVersion,
        preRelease: true,
      );
      final bundle = Bundle(
        projectId: 'test',
        translationVersion: translationVersion + 1,
        appVersion: 'test',
        languageBundles: [],
      );

      when(remoteDataSource.getBundle(getUpToDateBundleDto: dto))
          .thenAnswer((_) => Future.value(bundle));

      when(localDataSource.saveBundle(bundle: bundle))
          .thenAnswer((_) => Future.value(true));

      // When
      final res = await useCase.getBundle(dto: dto);

      // Then
      expect(res, equals(bundle));

      verify(localDataSource.saveBundle(bundle: bundle)).called(1);
      verifyNever(logger.exception(any));
    });

    test('older bundle received', () async {
      // Given
      const translationVersion = 123;
      final dto = GetUpToDateBundleDto(
        credentials: Credentials(projectId: 'test', token: 'test'),
        appVersion: 'test',
        translationVersion: translationVersion,
        preRelease: true,
      );
      final bundle = Bundle(
        projectId: 'test',
        translationVersion: translationVersion - 1,
        appVersion: 'test',
        languageBundles: [],
      );

      when(remoteDataSource.getBundle(getUpToDateBundleDto: dto))
          .thenAnswer((_) => Future.value(bundle));

      when(localDataSource.saveBundle(bundle: bundle))
          .thenAnswer((_) => Future.value(true));

      // When
      final res = await useCase.getBundle(dto: dto);

      // Then
      expect(res, equals(bundle));

      verify(localDataSource.saveBundle(bundle: bundle)).called(1);
      verifyNever(logger.exception(any));
    });
  });
}
