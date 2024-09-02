import 'package:flutter_test/flutter_test.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/api/clients/ota/response/success/get_bundle_response.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/exceptions/validation_exception.dart';

void main() {
  group('GetBundleResponse - isEmpty', () {
    test('empty constructor', () {
      final response = GetBundleResponse.empty();
      expect(response.isEmpty, equals(true));
    });
  });

  group('GetBundleResponse - fromJson', () {
    test('empty json', () {
      // Given
      final Map<String, dynamic> json = {};

      // When
      ValidationException? exception;
      try {
        GetBundleResponse.fromJson(json: json);
      } on ValidationException catch (e) {
        exception = e;
      }

      // Then
      expect(exception, isNotNull);
      expect(exception!.errors.length, equals(1));
      final error = exception.errors[0];
      expect(error.type, equals(GetBundleResponse));
      expect(error.path, equals('data'));
      expect(error.received, equals(null));
      expect(error.expectedType, equals(Map<String, dynamic>));
    });

    test('invalid data type', () {
      // Given
      final Map<String, dynamic> json = {'data': 1};

      // When
      ValidationException? exception;
      try {
        GetBundleResponse.fromJson(json: json);
      } on ValidationException catch (e) {
        exception = e;
      }

      // Then
      expect(exception, isNotNull);
      expect(exception!.errors.length, equals(1));
      final error = exception.errors[0];
      expect(error.type, equals(GetBundleResponse));
      expect(error.path, equals('data'));
      expect(error.received, equals(1));
      expect(error.expectedType, equals(Map<String, dynamic>));
    });

    test('empty data', () {
      // Given
      final Map<String, dynamic> json = {
        'data': <String, dynamic>{},
      };

      // When
      ValidationException? exception;
      try {
        GetBundleResponse.fromJson(json: json);
      } on ValidationException catch (e) {
        exception = e;
      }

      // Then
      expect(exception, isNotNull);
      expect(exception!.errors.length, equals(2));
    });

    test('invalid url type', () {
      // Given
      final Map<String, dynamic> json = {
        'data': {
          'url': 1,
          'version': 10,
        },
      };

      // When
      ValidationException? exception;
      try {
        GetBundleResponse.fromJson(json: json);
      } on ValidationException catch (e) {
        exception = e;
      }

      // Then
      expect(exception, isNotNull);
      expect(exception!.errors.length, equals(1));
      final error = exception.errors[0];
      expect(error.type, equals(GetBundleResponse));
      expect(error.path, equals('data -> url'));
      expect(error.received, equals(1));
      expect(error.expectedType, equals(String));
    });

    test('empty url', () {
      // Given
      final Map<String, dynamic> json = {
        'data': {
          'url': '',
          'version': 10,
        },
      };

      // When
      ValidationException? exception;
      try {
        GetBundleResponse.fromJson(json: json);
      } on ValidationException catch (e) {
        exception = e;
      }

      // Then
      expect(exception, isNotNull);
      expect(exception!.errors.length, equals(1));
      final error = exception.errors[0];
      expect(error.type, equals(GetBundleResponse));
      expect(error.path, equals('data -> url'));
      expect(error.received, equals(''));
      expect(error.expectedType, equals(null));
    });

    test('bad url format', () {
      // Given
      final Map<String, dynamic> json = {
        'data': {
          'url': 'bad url',
          'version': 10,
        },
      };

      // When
      ValidationException? exception;
      try {
        GetBundleResponse.fromJson(json: json);
      } on ValidationException catch (e) {
        exception = e;
      }

      // Then
      expect(exception, isNotNull);
      expect(exception!.errors.length, equals(1));
      final error = exception.errors[0];
      expect(error.type, equals(GetBundleResponse));
      expect(error.path, equals('data -> url'));
      expect(error.received, equals('bad url'));
      expect(error.expectedType, equals(null));
    });

    test('invalid version type', () {
      // Given
      final Map<String, dynamic> json = {
        'data': {
          'url': 'https://test.com',
          'version': '',
        },
      };

      // When
      ValidationException? exception;
      try {
        GetBundleResponse.fromJson(json: json);
      } on ValidationException catch (e) {
        exception = e;
      }

      // Then
      expect(exception, isNotNull);
      expect(exception!.errors.length, equals(1));
      final error = exception.errors[0];
      expect(error.type, equals(GetBundleResponse));
      expect(error.path, equals('data -> version'));
      expect(error.received, equals(''));
      expect(error.expectedType, equals(int));
    });

    test('negative version', () {
      // Given
      final Map<String, dynamic> json = {
        'data': {
          'url': 'https://test.com',
          'version': -1,
        },
      };

      // When
      ValidationException? exception;
      try {
        GetBundleResponse.fromJson(json: json);
      } on ValidationException catch (e) {
        exception = e;
      }

      // Then
      expect(exception, isNotNull);
      expect(exception!.errors.length, equals(1));
      final error = exception.errors[0];
      expect(error.type, equals(GetBundleResponse));
      expect(error.path, equals('data -> version'));
      expect(error.received, equals(-1));
    });

    test('Correct', () {
      // Given
      final Map<String, dynamic> json = {
        'data': {
          'url': 'https://test.com',
          'version': 10,
        },
      };

      // When
      ValidationException? exception;
      GetBundleResponse? response;
      try {
        response = GetBundleResponse.fromJson(json: json);
      } on ValidationException catch (e) {
        exception = e;
      }

      // Then
      expect(exception, isNull);
      expect(response, isNotNull);
      expect(response!.url, equals(json['data']['url']));
      expect(response.version, equals(json['data']['version']));
    });
  });
}
