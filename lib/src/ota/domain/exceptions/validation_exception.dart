import 'package:lokalise_flutter_sdk/src/ota/domain/models/json_serializable.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/validation_error.dart';

class ValidationException implements Exception, JsonSerializable {
  final List<ValidationError> errors;

  ValidationException({
    required this.errors,
  });

  @override
  Map<String, dynamic> toJson() => {
        'errors': errors.map((e) => e.message).toList(),
      };
}
