import 'package:flutter_test/flutter_test.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/api/clients/ota/response/error/ota_error_info.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/exceptions/validation_exception.dart';

void main() {
  group('OtaErrorInfo - fromJson', () {
    test('empty json', () {
      // Given
      final Map<String, dynamic> json = {};

      // When
      ValidationException? exception;
      try {
        OtaErrorInfo.fromJson(json: json);
      } on ValidationException catch (e) {
        exception = e;
      }

      // Then
      expect(exception, isNotNull);
      expect(exception!.errors.length, equals(3));
    });

    test('code invalid type', () {
      // Given
      final Map<String, dynamic> json = {
        'code': 1,
        'message': '',
        'path': [],
      };

      // When
      ValidationException? exception;
      try {
        OtaErrorInfo.fromJson(json: json);
      } on ValidationException catch (e) {
        exception = e;
      }

      // Then
      expect(exception, isNotNull);
      expect(exception!.errors.length, equals(1));
      final error = exception.errors[0];
      expect(error.type, equals(OtaErrorInfo));
      expect(error.path, equals('code'));
      expect(error.received, equals(1));
      expect(error.expectedType, equals(String));
    });

    test('message invalid type', () {
      // Given
      final Map<String, dynamic> json = {
        'code': '',
        'message': 1,
        'path': [],
      };

      // When
      ValidationException? exception;
      try {
        OtaErrorInfo.fromJson(json: json);
      } on ValidationException catch (e) {
        exception = e;
      }

      // Then
      expect(exception, isNotNull);
      expect(exception!.errors.length, equals(1));
      final error = exception.errors[0];
      expect(error.type, equals(OtaErrorInfo));
      expect(error.path, equals('message'));
      expect(error.received, equals(1));
      expect(error.expectedType, equals(String));
    });

    test('path invalid type', () {
      // Given
      final Map<String, dynamic> json = {
        'code': '',
        'message': '',
        'path': '',
      };

      // When
      ValidationException? exception;
      try {
        OtaErrorInfo.fromJson(json: json);
      } on ValidationException catch (e) {
        exception = e;
      }

      // Then
      expect(exception, isNotNull);
      expect(exception!.errors.length, equals(1));
      final error = exception.errors[0];
      expect(error.type, equals(OtaErrorInfo));
      expect(error.path, equals('path'));
      expect(error.received, equals(''));
      expect(error.expectedType, equals(List));
    });

    test('correct without expected and received', () {
      // Given
      final Map<String, dynamic> json = {
        'code': 'test-code',
        'message': 'test-message',
        'path': ['test-path'],
      };

      // When
      ValidationException? exception;
      OtaErrorInfo? response;
      try {
        response = OtaErrorInfo.fromJson(json: json);
      } on ValidationException catch (e) {
        exception = e;
      }

      // Then
      expect(exception, isNull);
      expect(response, isNotNull);
      expect(response!.code, equals(json['code']));
      expect(response.message, equals(json['message']));
      expect(response.path, equals(json['path']));
      expect(response.expected, isNull);
      expect(response.received, isNull);
    });

    test('expected invalid type', () {
      // Given
      final Map<String, dynamic> json = {
        'code': '',
        'message': '',
        'path': [],
        'expected': 1
      };

      // When
      ValidationException? exception;
      try {
        OtaErrorInfo.fromJson(json: json);
      } on ValidationException catch (e) {
        exception = e;
      }

      // Then
      expect(exception, isNotNull);
      expect(exception!.errors.length, equals(1));
      final error = exception.errors[0];
      expect(error.type, equals(OtaErrorInfo));
      expect(error.path, equals('expected'));
      expect(error.received, equals(1));
      expect(error.expectedType, equals(String));
    });

    test('received invalid type', () {
      // Given
      final Map<String, dynamic> json = {
        'code': '',
        'message': '',
        'path': [],
        'received': 1
      };

      // When
      ValidationException? exception;
      try {
        OtaErrorInfo.fromJson(json: json);
      } on ValidationException catch (e) {
        exception = e;
      }

      // Then
      expect(exception, isNotNull);
      expect(exception!.errors.length, equals(1));
      final error = exception.errors[0];
      expect(error.type, equals(OtaErrorInfo));
      expect(error.path, equals('received'));
      expect(error.received, equals(1));
      expect(error.expectedType, equals(String));
    });

    test('correct with expected and received', () {
      // Given
      final Map<String, dynamic> json = {
        'code': 'test-code',
        'message': 'test-message',
        'path': ['test-path'],
        'expected': 'test-expected',
        'received': 'test-received',
      };

      // When
      ValidationException? exception;
      OtaErrorInfo? response;
      try {
        response = OtaErrorInfo.fromJson(json: json);
      } on ValidationException catch (e) {
        exception = e;
      }

      // Then
      expect(exception, isNull);
      expect(response, isNotNull);
      expect(response!.code, equals(json['code']));
      expect(response.message, equals(json['message']));
      expect(response.path, equals(json['path']));
      expect(response.expected, equals(json['expected']));
      expect(response.received, equals(json['received']));
    });
  });

  group('OtaErrorInfo - toJson', () {
    test('All properties', () {
      // Given
      final instance = OtaErrorInfo(
        code: '200',
        message: 'test',
        path: ['test_1', 'test_2'],
        expected: 'expected',
        received: 'received',
      );

      // When
      final json = instance.toJson();

      // Then
      expect(json, isNotNull);
      expect(json['code'], equals(instance.code));
      expect(json['message'], equals(instance.message));
      expect(json['path'], equals(instance.path));
      expect(json['expected'], equals(instance.expected));
      expect(json['received'], equals(instance.received));
    });

    test('Only required properties', () {
      // Given
      final instance = OtaErrorInfo(
        code: '200',
        message: 'test',
        path: ['test_1', 'test_2'],
      );

      // When
      final json = instance.toJson();

      // Then
      expect(json, isNotNull);
      expect(json['code'], equals(instance.code));
      expect(json['message'], equals(instance.message));
      expect(json['path'], equals(instance.path));
      expect(json['expected'], isNull);
      expect(json['received'], isNull);
    });
  });
}
