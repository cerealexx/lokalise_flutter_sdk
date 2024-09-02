import 'package:flutter_test/flutter_test.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/api/clients/ota/response/error/ota_error_info.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/api/clients/ota/response/error/ota_error_response.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/exceptions/validation_exception.dart';

void main() {
  group('OtaErrorResponse - fromJson', () {
    test('empty json', () {
      // Given
      final Map<String, dynamic> json = {};

      // When
      ValidationException? exception;
      try {
        OtaErrorResponse.fromJson(json: json);
      } on ValidationException catch (e) {
        exception = e;
      }

      // Then
      expect(exception, isNotNull);
      expect(exception!.errors.length, equals(2));
    });

    test('statusCode invalid type', () {
      // Given
      final Map<String, dynamic> json = {
        'statusCode': '',
        'message': '',
        'error': [],
      };

      // When
      ValidationException? exception;
      try {
        OtaErrorResponse.fromJson(json: json);
      } on ValidationException catch (e) {
        exception = e;
      }

      // Then
      expect(exception, isNotNull);
      expect(exception!.errors.length, equals(1));
      final error = exception.errors[0];
      expect(error.type, equals(OtaErrorResponse));
      expect(error.path, equals('statusCode'));
      expect(error.received, equals(''));
      expect(error.expectedType, equals(int));
    });

    test('message invalid type', () {
      // Given
      final Map<String, dynamic> json = {
        'statusCode': 200,
        'message': 1,
        'error': [],
      };

      // When
      ValidationException? exception;
      try {
        OtaErrorResponse.fromJson(json: json);
      } on ValidationException catch (e) {
        exception = e;
      }

      // Then
      expect(exception, isNotNull);
      expect(exception!.errors.length, equals(1));
      final error = exception.errors[0];
      expect(error.type, equals(OtaErrorResponse));
      expect(error.path, equals('message'));
      expect(error.received, equals(1));
      expect(error.expectedType, equals(String));
    });

    /// The OTA api has an issue and right now the error parameter can be
    /// an String or a List<String>, for now we only parse it if it is a
    /// List<String>, in other case we ignore it to avoid casting and
    /// typing errors.
    test('invalid type on error should not trigger exception', () {
      // Given
      final Map<String, dynamic> json = {
        'statusCode': 200,
        'message': 'message',
        'error': '',
      };

      // When
      final response = OtaErrorResponse.fromJson(json: json);

      // Then
      expect(response, isNotNull);
      expect(response.statusCode, equals(200));
      expect(response.message, equals('message'));
      expect(response.errors, isNull);
    });

    test('correct, errors is empty', () {
      // Given
      final Map<String, dynamic> json = {
        'statusCode': 200,
        'message': 'test-message',
        'error': [],
      };

      // When
      ValidationException? exception;
      OtaErrorResponse? response;
      try {
        response = OtaErrorResponse.fromJson(json: json);
      } on ValidationException catch (e) {
        exception = e;
      }

      // Then
      expect(exception, isNull);
      expect(response, isNotNull);
      expect(response!.statusCode, equals(json['statusCode']));
      expect(response.message, equals(json['message']));
      expect(response.errors, isEmpty);
    });

    test('correct', () {
      // Given
      final Map<String, dynamic> json = {
        'statusCode': 200,
        'message': 'test-message',
        'error': [
          {
            'code': 'test-code',
            'message': 'test-message',
            'path': [],
          }
        ],
      };

      // When
      ValidationException? exception;
      OtaErrorResponse? response;
      try {
        response = OtaErrorResponse.fromJson(json: json);
      } on ValidationException catch (e) {
        exception = e;
      }

      // Then
      expect(exception, isNull);
      expect(response, isNotNull);
      expect(response!.statusCode, equals(json['statusCode']));
      expect(response.message, equals(json['message']));
      expect(response.errors!.length, equals(1));
      final error = response.errors![0];
      expect(error.code, equals(json['error'][0]['code']));
      expect(error.message, equals(json['error'][0]['message']));
      expect(error.path, isEmpty);
    });
  });

  group('OtaErrorResponse - toJson', () {
    test('errors is null', () {
      // Given
      final instance = OtaErrorResponse(
        statusCode: 200,
        message: 'message',
        errors: null,
      );

      // When
      final json = instance.toJson();

      // Then
      expect(json, isNotNull);
      expect(json['status_code'], equals(instance.statusCode));
      expect(json['message'], equals(instance.message));
      expect(json['errors'], equals(instance.errors));
    });

    test('errors is not null', () {
      // Given
      final instance = OtaErrorResponse(
        statusCode: 200,
        message: 'message',
        errors: [
          OtaErrorInfo(code: '1', message: 'message', path: ['path'])
        ],
      );

      // When
      final json = instance.toJson();

      // Then
      expect(json, isNotNull);
      expect(json['status_code'], equals(instance.statusCode));
      expect(json['message'], equals(instance.message));
      expect(json['errors'], isNotEmpty);
      final errors = json['errors'] as List;
      expect(errors.length, equals(1));
      expect(errors[0]['code'], equals('1'));
      expect(errors[0]['message'], equals('message'));
      expect(errors[0]['path'], equals(['path']));
      expect(errors[0]['expected'], isNull);
      expect(errors[0]['received'], isNull);
    });
  });
}
