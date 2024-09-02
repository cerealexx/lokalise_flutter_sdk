import 'package:lokalise_flutter_sdk/src/ota/data/api/clients/ota/response/error/ota_error_info.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/exceptions/validation_exception.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/json_serializable.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/validation_error.dart';

class OtaErrorResponse implements JsonSerializable {
  final int statusCode;
  final String message;
  final List<OtaErrorInfo>? errors;

  OtaErrorResponse({
    required this.statusCode,
    required this.message,
    required this.errors,
  });

  /// The OTA api has an issue and right now the error parameter can be
  /// an String or a List<String>, for now we only parse it if it is a
  /// List<String>, in other case we ignore it to avoid casting and
  /// typing errors.
  factory OtaErrorResponse.fromJson({required Map<String, dynamic> json}) {
    _validateJson(json);

    List<OtaErrorInfo>? errors;
    if (json['error'] is List) {
      errors = (json['error'] as List)
          .map((e) => OtaErrorInfo.fromJson(json: e))
          .toList();
    }

    return OtaErrorResponse(
      statusCode: json['statusCode'] as int,
      message: json['message'] as String,
      errors: errors,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'status_code': statusCode,
        'message': message,
        'errors': errors?.map((e) => e.toJson()).toList(),
      };

  static void _validateJson(Map<String, dynamic> json) {
    final List<ValidationError> errors = [];

    if (json['statusCode'] is! int) {
      errors.add(ValidationError(
        type: OtaErrorResponse,
        path: 'statusCode',
        received: json['statusCode'],
        expectedType: int,
      ));
    }

    if (json['message'] is! String) {
      errors.add(ValidationError(
        type: OtaErrorResponse,
        path: 'message',
        received: json['message'],
        expectedType: String,
      ));
    }

    if (errors.isNotEmpty) {
      throw ValidationException(errors: errors);
    }
  }
}
