import 'package:lokalise_flutter_sdk/src/ota/domain/models/json_serializable.dart';

class ApiException implements Exception, JsonSerializable {
  final int httpCode;
  final String responseBody;

  ApiException({required this.httpCode, required this.responseBody});

  @override
  Map<String, dynamic> toJson() => {
        'http_code': httpCode,
        'response_body': responseBody,
      };
}
