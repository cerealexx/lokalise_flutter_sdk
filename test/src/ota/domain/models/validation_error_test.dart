import 'package:flutter_test/flutter_test.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/validation_error.dart';

void main() {
  group('Validation error', () {
    test('without expected type', () {
      final error = ValidationError(
        type: String,
        path: 'path',
        received: 'received',
      );
      expect(
        error.message,
        equals('String -> [path] not valid (received: received)'),
      );
    });

    test('with expected type', () {
      final error = ValidationError(
          type: String, path: 'path', received: 'received', expectedType: int);
      expect(
        error.message,
        equals(
            'String -> [path] invalid type (expected: int, received: received)'),
      );
    });
  });
}
