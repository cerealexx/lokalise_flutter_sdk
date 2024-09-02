import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/api/clients/ota/ota_client.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/api/exceptions/api_exception.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/api/requests/bundle_request.dart';
import 'package:http/testing.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/exceptions/internal_exception.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/exceptions/validation_exception.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/credentials.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/services/device_info.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'ota_client_test.mocks.dart';

@GenerateMocks([DeviceInfo])
void main() {
  final credentials = Credentials(
    projectId: 'test-project',
    token: 'test-token',
  );
  final bundleRequest = BundleRequest(
    translationVersion: 20,
    appVersion: '10',
    preRelease: true,
  );
  const appVersion = 'test-app-version';
  const platform = 'test-platform';
  const packageName = 'test-package-name';
  const lokaliseSdkVersion = 'test-lokalise-sdk-version';

  late MockDeviceInfo deviceInfo;

  setUp(() {
    deviceInfo = MockDeviceInfo();
    when(deviceInfo.appVersion).thenReturn(appVersion);
    when(deviceInfo.platform).thenReturn(platform);
    when(deviceInfo.packageName).thenReturn(packageName);
    when(deviceInfo.lokaliseSdkVersion).thenReturn(lokaliseSdkVersion);
    when(deviceInfo.isWeb).thenReturn(false);
  });

  MockClient getMockClient(Map<String, dynamic> body, int code) {
    final expectedUri =
        'https://ota.lokalise.com/v3/lokalise/projects/${credentials.projectId}/frameworks/flutter_sdk?transVersion=${bundleRequest.translationVersion}&appVersion=${bundleRequest.appVersion}&prerelease=${bundleRequest.preRelease}';
    const expectedUserAgent =
        'Lokalise SDK; $lokaliseSdkVersion; Flutter $platform; $packageName; $appVersion';

    return MockClient((request) async {
      expect(request.method, equals('GET'));
      expect(request.url.toString(), equals(expectedUri));
      expect(request.headers['x-ota-api-token'], equals(credentials.token));
      expect(request.headers['content-type'], equals('application/json'));
      expect(request.headers['User-Agent'], equals(expectedUserAgent));

      return Response(jsonEncode(body), code);
    });
  }

  group('OtaClient - getBundle', () {
    test('204 response', () async {
      // Given
      final clientMock = getMockClient({}, 204);
      final otaClient = OtaClient(
        httpClient: clientMock,
        deviceInfo: deviceInfo,
      );

      // When
      final response = await otaClient.getBundle(
        request: bundleRequest,
        credentials: credentials,
      );

      // Then
      expect(response.httpCode, equals(204));
      expect(response.isSuccess, equals(true));
      expect(response.result!.isEmpty, equals(true));
    });

    test('200 response', () async {
      // Given
      const code = 200;
      const getBundleResponse = {
        'data': {
          'url': 'http://test.com',
          'version': 1,
        }
      };

      final clientMock = getMockClient(getBundleResponse, code);
      final otaClient = OtaClient(
        httpClient: clientMock,
        deviceInfo: deviceInfo,
      );

      // When
      final response = await otaClient.getBundle(
        request: bundleRequest,
        credentials: credentials,
      );

      // Then
      expect(response.httpCode, equals(200));
      expect(response.isSuccess, equals(true));

      final result = response.result!;
      expect(result.url, equals(getBundleResponse['data']!['url']));
      expect(result.version, equals(getBundleResponse['data']!['version']));
    });

    test('200 response with validation exception', () async {
      // Given
      const code = 200;
      const getBundleResponse = {'data': {}};

      final clientMock = getMockClient(getBundleResponse, code);
      final otaClient = OtaClient(
        httpClient: clientMock,
        deviceInfo: deviceInfo,
      );

      // When
      late InternalException ex;
      try {
        await otaClient.getBundle(
          request: bundleRequest,
          credentials: credentials,
        );
      } on InternalException catch (e) {
        ex = e;
      }

      // Then
      expect(ex, isInstanceOf<InternalException<ValidationException>>());
    });

    test('400 response', () async {
      // Given
      const code = 400;
      const otaError = {
        'message': 'test-message',
        'statusCode': code,
        'error': [
          {
            'code': 'test-code',
            'expected': 'test-expected',
            'message': 'test-message',
            'path': ['test-path1', 'test-path2'],
            'received': 'test-received',
          }
        ],
      };

      final clientMock = getMockClient(otaError, code);
      final otaClient = OtaClient(
        httpClient: clientMock,
        deviceInfo: deviceInfo,
      );

      // When
      final response = await otaClient.getBundle(
        request: bundleRequest,
        credentials: credentials,
      );

      // Then
      expect(response.httpCode, equals(400));
      expect(response.isSuccess, equals(false));

      final error = response.error!;
      expect(error.message, equals(otaError['message']));
      expect(error.statusCode, equals(otaError['statusCode']));
      expect(error.errors!.length, equals(1));

      final otaErrorInfo = (otaError['error'] as List)[0] as Map;
      expect(error.errors![0].code, equals(otaErrorInfo['code']));
      expect(error.errors![0].expected, equals(otaErrorInfo['expected']));
      expect(error.errors![0].message, equals(otaErrorInfo['message']));
      expect(error.errors![0].path, equals(otaErrorInfo['path']));
      expect(error.errors![0].received, equals(otaErrorInfo['received']));
    });

    test('400 response with validation exception', () async {
      // Given
      const code = 400;
      const getBundleResponse = <String, dynamic>{};

      final clientMock = getMockClient(getBundleResponse, code);
      final otaClient = OtaClient(
        httpClient: clientMock,
        deviceInfo: deviceInfo,
      );

      // When
      late InternalException ex;
      try {
        await otaClient.getBundle(
          request: bundleRequest,
          credentials: credentials,
        );
      } on InternalException catch (e) {
        ex = e;
      }

      // Then
      expect(ex, isInstanceOf<InternalException<ValidationException>>());
    });

    test('500 response', () async {
      // Given
      final clientMock = getMockClient({}, 500);
      final otaClient = OtaClient(
        httpClient: clientMock,
        deviceInfo: deviceInfo,
      );

      // When - Then
      ApiException? exception;
      try {
        await otaClient.getBundle(
          request: bundleRequest,
          credentials: credentials,
        );
      } on ApiException catch (e) {
        exception = e;
      }

      // Then
      expect(exception!.httpCode, equals(500));
      expect(exception.responseBody, equals('{}'));
    });
  });
}
