import 'dart:convert';
import 'package:http/http.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/api/clients/ota/response/error/ota_error_response.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/api/clients/ota/response/ota_response.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/api/clients/ota/response/success/get_bundle_response.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/api/exceptions/api_exception.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/api/requests/bundle_request.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/exceptions/internal_exception.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/exceptions/validation_exception.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/credentials.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/services/device_info.dart';

class OtaClient extends BaseClient {
  static const String _domain = 'ota.lokalise.com';

  final Client _inner;
  final DeviceInfo _deviceInfo;

  OtaClient({required Client httpClient, required DeviceInfo deviceInfo})
      : _inner = httpClient,
        _deviceInfo = deviceInfo;

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    request.headers['content-type'] = 'application/json';
    /**
     * On web platform we should not override this header to avoid 
     * `Refused to set unsafe header "User-Agent"` error
     */
    if (!_deviceInfo.isWeb) request.headers['User-Agent'] = _userAgentHeader;

    return _inner.send(request);
  }

  Future<OtaResponse<GetBundleResponse>> getBundle({
    required Credentials credentials,
    required BundleRequest request,
  }) async {
    final url = Uri.https(
      _domain,
      'v3/lokalise/projects/${credentials.projectId}/frameworks/flutter_sdk',
      request.toQueryParams(),
    );
    final response = await this.get(
      url,
      headers: {'x-ota-api-token': credentials.token},
    );

    try {
      final code = response.statusCode;
      if (code == 200) {
        return OtaResponse.success(
          httpCode: code,
          result: GetBundleResponse.fromJson(json: jsonDecode(response.body)),
        );
      } else if (code == 204) {
        return OtaResponse.success(
          httpCode: code,
          result: GetBundleResponse.empty(),
        );
      } else if (code >= 400 && code < 500) {
        return OtaResponse.failure(
          httpCode: code,
          error: OtaErrorResponse.fromJson(json: jsonDecode(response.body)),
        );
      } else {
        throw ApiException(
          httpCode: code,
          responseBody: response.body,
        );
      }
    } on ValidationException catch (e) {
      throw InternalException.fromValidationException(param: e);
    }
  }

  String get _userAgentHeader => [
        'Lokalise SDK',
        _deviceInfo.lokaliseSdkVersion,
        'Flutter ${_deviceInfo.platform}',
        _deviceInfo.packageName,
        _deviceInfo.appVersion
      ].join('; ');
}
