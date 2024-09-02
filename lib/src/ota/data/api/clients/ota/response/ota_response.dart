import 'package:lokalise_flutter_sdk/src/ota/data/api/clients/base_client_response.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/api/clients/ota/response/error/ota_error_response.dart';

class OtaResponse<T> extends BaseClientResponse<T, OtaErrorResponse> {
  OtaResponse.failure({required super.httpCode, required super.error})
      : super.failure();

  OtaResponse.success({required super.httpCode, required super.result})
      : super.success();
}
