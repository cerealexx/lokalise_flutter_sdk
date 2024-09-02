import 'package:flutter_test/flutter_test.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/api/exceptions/api_exception.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/exceptions/internal_exception.dart';

void main() {
  group('Internal exception - toJson', () {
    test('with a json serializable class', () {
      // Given
      final apiError = ApiException(httpCode: 400, responseBody: 'error');
      final exception = InternalException.fromApiException(param: apiError);

      // When
      final json = exception.toJson();

      // Then
      expect(
          json,
          equals({
            'code': InternalException.otaApiError,
            'error': apiError.toJson(),
          }));
    });

    test('with a non json serializable class', () {
      // Given
      const param = 'This is a string';
      final exception = InternalException.unexpected(param: param);

      // When
      final json = exception.toJson();

      // Then
      expect(
          json,
          equals({
            'code': InternalException.unexpectedError,
            'error': {'message': param}
          }));
    });
  });
}
