import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart' as package;
import 'package:lokalise_flutter_sdk/src/ota/data/api/exceptions/api_exception.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/exceptions/internal_exception.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/services/device_info.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/services/logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'logger_test.mocks.dart';

@GenerateMocks([package.Logger, DeviceInfo])
void main() {
  late MockDeviceInfo deviceInfo;
  late MockLogger loggerPack;
  late Logger logger;

  group('Logger - exception', () {
    setUp(() {
      deviceInfo = MockDeviceInfo();
      loggerPack = MockLogger();
      logger = Logger(deviceInfo: deviceInfo, logger: loggerPack);
    });

    test('with internal exeption', () {
      // Given
      when(deviceInfo.toJson())
          .thenAnswer((_) => {'message': 'device info response'});
      final ex = InternalException.fromApiException(
        param: ApiException(httpCode: 400, responseBody: 'error'),
      );

      // When
      logger.exception(ex);

      // Then
      final expected = {
        'name': 'Lokalise exception',
        'device_info': {'message': 'device info response'},
        'error': ex.toJson(),
      };
      verify(loggerPack.w(expected)).called(1);
    });

    test('with socket exeption', () {
      // Given
      when(deviceInfo.toJson())
          .thenAnswer((_) => {'message': 'device info response'});
      const ex = SocketException(
        'error message',
        osError: OSError('os error', 9),
      );

      // When
      logger.exception(ex);

      // Then
      final expected = {
        'name': 'Lokalise exception',
        'device_info': {'message': 'device info response'},
        'error': {
          'message': ex.message,
          'os_error': ex.osError,
        },
      };
      verify(loggerPack.w(expected)).called(1);
    });

    test('with generic exeption', () {
      // Given
      when(deviceInfo.toJson())
          .thenAnswer((_) => {'message': 'device info response'});
      final ex = Exception('this is a message');

      // When
      logger.exception(ex);

      // Then
      final expected = {
        'name': 'Lokalise exception',
        'device_info': {'message': 'device info response'},
        'error': {'message': ex.toString()},
      };
      verify(loggerPack.w(expected)).called(1);
    });
  });
}
