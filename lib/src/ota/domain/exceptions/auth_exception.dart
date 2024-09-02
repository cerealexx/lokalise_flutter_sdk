import 'package:lokalise_flutter_sdk/src/ota/domain/models/json_serializable.dart';

class AuthException implements Exception, JsonSerializable {
  @override
  Map<String, dynamic> toJson() => {'message': 'Unauthorized'};
}
