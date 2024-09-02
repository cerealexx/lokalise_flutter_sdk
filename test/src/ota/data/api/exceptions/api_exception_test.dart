import 'package:flutter_test/flutter_test.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/api/exceptions/api_exception.dart';

void main() {
  group('Api exception to json', () {
    test('works', () {
      // Given
      final ex = ApiException(httpCode: 400, responseBody: 'error');

      // When
      final json = ex.toJson();

      // Then
      expect(
          json,
          equals({
            'http_code': 400,
            'response_body': 'error',
          }));
    });
  });
}
