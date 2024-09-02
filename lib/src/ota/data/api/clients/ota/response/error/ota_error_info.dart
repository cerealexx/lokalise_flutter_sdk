import 'package:lokalise_flutter_sdk/src/ota/domain/exceptions/validation_exception.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/json_serializable.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/validation_error.dart';

class OtaErrorInfo implements JsonSerializable {
  final String code;
  final String message;
  final List<String> path;

  final String? expected;
  final String? received;

  OtaErrorInfo({
    required this.code,
    required this.message,
    required this.path,
    this.expected,
    this.received,
  });

  factory OtaErrorInfo.fromJson({required Map<String, dynamic> json}) {
    _validateJson(json);

    return OtaErrorInfo(
      code: json['code'] as String,
      message: json['message'] as String,
      path: List<String>.from(json['path']),
      expected: json['expected'] != null ? json['expected'] as String : null,
      received: json['received'] != null ? json['received'] as String : null,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'code': code,
        'message': message,
        'path': path,
        'expected': expected,
        'received': received,
      };

  static _validateJson(Map<String, dynamic> json) {
    final List<ValidationError> errors = [];

    if (json['code'] is! String) {
      errors.add(ValidationError(
        type: OtaErrorInfo,
        path: 'code',
        received: json['code'],
        expectedType: String,
      ));
    }

    if (json['message'] is! String) {
      errors.add(ValidationError(
        type: OtaErrorInfo,
        path: 'message',
        received: json['message'],
        expectedType: String,
      ));
    }

    if (json['path'] is! List) {
      errors.add(ValidationError(
        type: OtaErrorInfo,
        path: 'path',
        received: json['path'],
        expectedType: List,
      ));
    }

    if (json['expected'] != null && json['expected'] is! String) {
      errors.add(ValidationError(
        type: OtaErrorInfo,
        path: 'expected',
        received: json['expected'],
        expectedType: String,
      ));
    }

    if (json['received'] != null && json['received'] is! String) {
      errors.add(ValidationError(
        type: OtaErrorInfo,
        path: 'received',
        received: json['received'],
        expectedType: String,
      ));
    }

    if (errors.isNotEmpty) {
      throw ValidationException(errors: errors);
    }
  }
}
