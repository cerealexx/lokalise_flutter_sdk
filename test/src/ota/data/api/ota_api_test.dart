import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/api/clients/bundle_downloader/bundle_downloader_client.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/api/clients/bundle_downloader/response/bundle_downloader_response.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/api/clients/ota/ota_client.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/api/clients/ota/response/error/ota_error_response.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/api/clients/ota/response/ota_response.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/api/clients/ota/response/success/get_bundle_response.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/api/exceptions/api_exception.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/api/ota_api.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/api/requests/bundle_request.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/exceptions/auth_exception.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/exceptions/bundle_not_found_exception.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/exceptions/internal_exception.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/credentials.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../assets/assets_routes.dart';
import 'ota_api_test.mocks.dart';

@GenerateMocks([OtaClient, BundleDownloaderClient])
void main() {
  late MockOtaClient otaClientMock;
  late MockBundleDownloaderClient bundleDownloaderMock;
  late OtaApi otaApi;

  setUp(() {
    otaClientMock = MockOtaClient();
    bundleDownloaderMock = MockBundleDownloaderClient();
    otaApi = OtaApi(
      otaClient: otaClientMock,
      downloaderClient: bundleDownloaderMock,
    );
  });

  group('OtaApi - getBundle', () {
    final BundleRequest request = BundleRequest(
      translationVersion: 1,
      appVersion: '1',
      preRelease: true,
    );
    final credentials = Credentials(
      projectId: 'project-test',
      token: 'token-test',
    );
    test('Bundle not found (404 response)', () {
      // Given
      when(otaClientMock.getBundle(request: request, credentials: credentials))
          .thenAnswer(
        (_) => Future.value(
          OtaResponse.failure(
            httpCode: 404,
            error: OtaErrorResponse(statusCode: 404, message: '', errors: []),
          ),
        ),
      );

      // When - Then
      expect(
        otaApi.getBundle(request: request, credentials: credentials),
        throwsA(isA<BundleNotFoundException>()),
      );
    });

    test('Auth error (401 response)', () {
      // Given
      when(otaClientMock.getBundle(request: request, credentials: credentials))
          .thenAnswer(
        (_) => Future.value(
          OtaResponse.failure(
            httpCode: 401,
            error: OtaErrorResponse(statusCode: 401, message: '', errors: []),
          ),
        ),
      );

      // When - Then
      expect(
        otaApi.getBundle(request: request, credentials: credentials),
        throwsA(isA<AuthException>()),
      );
    });

    test('Ota response is an error (not 404)', () async {
      // Given
      final otaError = OtaErrorResponse(
        statusCode: 400,
        message: '',
        errors: [],
      );
      when(otaClientMock.getBundle(request: request, credentials: credentials))
          .thenAnswer(
        (_) => Future.value(
          OtaResponse.failure(
            httpCode: 400,
            error: otaError,
          ),
        ),
      );

      // When
      InternalException? exception;
      try {
        await otaApi.getBundle(request: request, credentials: credentials);
      } on InternalException catch (e) {
        exception = e;
      }

      // Then
      expect(exception, isInstanceOf<InternalException<OtaErrorResponse>>());
      expect(exception!.code, equals(InternalException.otaApiError));
      expect(exception.param, equals(otaError));
    });

    test('Ota client throws ApiException', () async {
      // Given
      final expectedException = ApiException(
        httpCode: 500,
        responseBody: 'test',
      );
      when(otaClientMock.getBundle(request: request, credentials: credentials))
          .thenThrow(expectedException);

      // When
      InternalException? exception;
      try {
        await otaApi.getBundle(request: request, credentials: credentials);
      } on InternalException catch (e) {
        exception = e;
      }

      // Then
      expect(exception, isInstanceOf<InternalException<ApiException>>());
      expect(exception!.code, equals(InternalException.otaApiError));
      expect(exception.param, equals(expectedException));
    });

    test('Ota client throws unexpected exception', () {
      // Given
      when(otaClientMock.getBundle(request: request, credentials: credentials))
          .thenThrow(Exception());

      // When - Then
      expect(
        otaApi.getBundle(request: request, credentials: credentials),
        throwsA(isA<Exception>()),
      );
    });

    test('downloader client throws ApiException', () async {
      // Given
      const bundleUrl = 'https://test.com';
      when(otaClientMock.getBundle(request: request, credentials: credentials))
          .thenAnswer(
        (_) => Future.value(
          OtaResponse.success(
            httpCode: 200,
            result: GetBundleResponse(
              url: bundleUrl,
              version: 5,
            ),
          ),
        ),
      );

      final expectedException = ApiException(
        httpCode: 500,
        responseBody: 'test',
      );
      when(bundleDownloaderMock.download(resourceUrl: bundleUrl))
          .thenThrow(expectedException);

      // When
      InternalException? exception;
      try {
        await otaApi.getBundle(request: request, credentials: credentials);
      } on InternalException catch (e) {
        exception = e;
      }

      // Then
      expect(exception, isInstanceOf<InternalException<ApiException>>());
      expect(exception!.code, equals(InternalException.otaApiError));
      expect(exception.param, equals(expectedException));
    });

    test('downloader client throws unexpected exception', () {
      // Given
      const bundleUrl = 'https://test.com';
      when(otaClientMock.getBundle(request: request, credentials: credentials))
          .thenAnswer(
        (_) => Future.value(
          OtaResponse.success(
            httpCode: 200,
            result: GetBundleResponse(
              url: bundleUrl,
              version: 5,
            ),
          ),
        ),
      );

      when(bundleDownloaderMock.download(resourceUrl: bundleUrl))
          .thenThrow(Exception());

      // When - Then
      expect(otaApi.getBundle(request: request, credentials: credentials),
          throwsA(isA<Exception>()));
    });

    test('success', () async {
      // Given
      const bundleUrl = 'https://test.com';
      const version = 5;
      when(otaClientMock.getBundle(request: request, credentials: credentials))
          .thenAnswer(
        (_) => Future.value(
          OtaResponse.success(
            httpCode: 200,
            result: GetBundleResponse(
              url: bundleUrl,
              version: version,
            ),
          ),
        ),
      );

      final zipDecoder = ZipDecoder();
      final zipFile = File('$kBundlesRute/bundle-correct.zip');
      when(bundleDownloaderMock.download(resourceUrl: bundleUrl)).thenAnswer(
        (_) => Future.value(
          BundleDownloaderResponse.success(
            httpCode: 200,
            result: zipDecoder.decodeBytes(zipFile.readAsBytesSync()),
          ),
        ),
      );

      // When
      final response =
          await otaApi.getBundle(request: request, credentials: credentials);

      // Then
      expect(response, isNotNull);
      expect(response!.bundle.isNotEmpty, equals(true));
      expect(response.version, equals(version));
    });
  });
}
