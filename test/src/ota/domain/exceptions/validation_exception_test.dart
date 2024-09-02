import 'package:flutter_test/flutter_test.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/exceptions/validation_exception.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/validation_error.dart';

void main() {
  group('Validation exception - to json', () {
    test('to json works as expected', () {
      // Given
      final errors = [
        ValidationError(type: String, path: 'path', received: 'test'),
        ValidationError(type: int, path: 'path_2', received: 'test_2')
      ];
      final exception = ValidationException(errors: errors);

      // When
      final json = exception.toJson();

      // Then
      expect(json['errors'], isNotNull);
      final jsonErrors = json['errors'] as List;
      expect(jsonErrors.length, equals(2));
      expect(
          jsonErrors,
          equals([
            'String -> [path] not valid (received: test)',
            'int -> [path_2] not valid (received: test_2)',
          ]));
    });
  });
}
