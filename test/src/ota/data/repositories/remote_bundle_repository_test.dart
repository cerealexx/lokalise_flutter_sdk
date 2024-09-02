import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/api/ota_api.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/api/responses/bundle_response.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/repositories/remote_bundle_repository.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/dto/get_up_to_date_bundle_dto.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/exceptions/internal_exception.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/credentials.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../assets/assets_routes.dart';
import 'remote_bundle_repository_test.mocks.dart';

@GenerateMocks([OtaApi])
void main() {
  final credentials = Credentials(projectId: 'test-id', token: 'test-token');

  late RemoteBundleRepository remoteRepo;
  late MockOtaApi otaApiMock;

  setUp(() {
    otaApiMock = MockOtaApi();
    remoteRepo = RemoteBundleRepository(otaApi: otaApiMock);
  });

  group('RemoteTranslationRepository - getBundle', () {
    test('rethrow internal exception', () {
      // Given
      when(
        otaApiMock.getBundle(
          credentials: credentials,
          request: anyNamed('request'),
        ),
      ).thenThrow(InternalException.unexpected(param: 'test'));

      // When - Then
      final dto = GetUpToDateBundleDto(
        credentials: credentials,
        appVersion: '1',
        translationVersion: 1,
        preRelease: true,
      );
      expect(
        remoteRepo.getBundle(
          getUpToDateBundleDto: dto,
        ),
        throwsA(isA<InternalException>()),
      );
    });

    test('returns null', () async {
      // Given
      when(
        otaApiMock.getBundle(
          credentials: credentials,
          request: anyNamed('request'),
        ),
      ).thenAnswer((_) => Future.value(null));

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

    test('empty bundle', () async {
      // Given
      final mockResponse = BundleResponse(bundle: Archive(), version: 15);
      when(
        otaApiMock.getBundle(
          credentials: credentials,
          request: anyNamed('request'),
        ),
      ).thenAnswer((_) => Future.value(mockResponse));

      // When
      InternalException? exception;
      try {
        final dto = GetUpToDateBundleDto(
          credentials: credentials,
          appVersion: '1',
          translationVersion: 1,
          preRelease: true,
        );
        await remoteRepo.getBundle(
          getUpToDateBundleDto: dto,
        );
      } on InternalException catch (e) {
        exception = e;
      }

      // Then
      expect(exception, isNotNull);
      expect(exception!.code, equals(InternalException.bundleEmptyError));
    });

    test('wrong bundle format', () async {
      // Given
      final zipFile = File('$kBundlesRute/bundle-wrong_format.zip');
      final mockResponse = BundleResponse(
        bundle: ZipDecoder().decodeBytes(zipFile.readAsBytesSync()),
        version: 15,
      );
      when(
        otaApiMock.getBundle(
          credentials: credentials,
          request: anyNamed('request'),
        ),
      ).thenAnswer((_) => Future.value(mockResponse));

      // When
      InternalException? exception;
      try {
        final dto = GetUpToDateBundleDto(
          credentials: credentials,
          appVersion: '1',
          translationVersion: 1,
          preRelease: true,
        );
        await remoteRepo.getBundle(
          getUpToDateBundleDto: dto,
        );
      } on InternalException catch (e) {
        exception = e;
      }

      // Then
      expect(exception, isNotNull);
      expect(exception!.code, equals(InternalException.bundleFormatError));
    });

    test('success', () async {
      // Given
      final zipFile = File('$kBundlesRute/bundle-correct.zip');
      final mockResponse = BundleResponse(
        bundle: ZipDecoder().decodeBytes(zipFile.readAsBytesSync()),
        version: 15,
      );
      when(
        otaApiMock.getBundle(
          credentials: credentials,
          request: anyNamed('request'),
        ),
      ).thenAnswer((_) => Future.value(mockResponse));

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
      expect(result!.projectId, equals(credentials.projectId));
      expect(result.appVersion, equals(dto.appVersion));
      expect(result.translationVersion, equals(mockResponse.version));
      expect(result.languageBundles.length, equals(3));

      for (final element in result.languageBundles) {
        expect(element.translations.length, equals(1));

        String value = '';
        switch (element.locale) {
          case 'en':
            value = 'hello world';
            break;
          case 'es':
            value = 'hola mundo';
            break;
          case 'lv':
            value = 'sveika pasaule';
            break;
          default:
            throw Exception('Unexpected locale: ${element.locale}');
        }

        expect(
          element.translations['hello_world']!.getTranslation(args: {}),
          equals(value),
        );
      }
    });
  });
}
