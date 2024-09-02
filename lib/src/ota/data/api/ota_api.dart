import 'package:lokalise_flutter_sdk/src/ota/data/api/clients/bundle_downloader/bundle_downloader_client.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/api/clients/ota/ota_client.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/api/clients/ota/response/ota_response.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/api/exceptions/api_exception.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/api/requests/bundle_request.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/api/responses/bundle_response.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/exceptions/auth_exception.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/exceptions/bundle_not_found_exception.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/exceptions/internal_exception.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/credentials.dart';

class OtaApi {
  final OtaClient _otaClient;
  final BundleDownloaderClient _downloaderClient;

  OtaApi({
    required OtaClient otaClient,
    required BundleDownloaderClient downloaderClient,
  })  : _otaClient = otaClient,
        _downloaderClient = downloaderClient;

  Future<BundleResponse?> getBundle({
    required Credentials credentials,
    required BundleRequest request,
  }) async {
    try {
      final otaResponse = await _otaClient.getBundle(
        credentials: credentials,
        request: request,
      );

      if (!otaResponse.isSuccess) _handleGetBundleError(otaResponse);

      final otaResult = otaResponse.result!;
      if (otaResult.isEmpty) return null;

      final downloaderResponse = await _downloaderClient.download(
        resourceUrl: otaResult.url,
      );

      if (!downloaderResponse.isSuccess) {
        throw InternalException.unexpected(
          param: 'Unexpected bundle downloader error',
        );
      }

      return BundleResponse(
        bundle: downloaderResponse.result!,
        version: otaResult.version,
      );
    } on ApiException catch (e) {
      throw InternalException.fromApiException(param: e);
    }
  }

  void _handleGetBundleError(OtaResponse response) {
    switch (response.httpCode) {
      case 404:
        throw BundleNotFoundException();
      case 401:
        throw AuthException();
      default:
        throw InternalException.fromOtaErrorResponse(param: response.error!);
    }
  }
}
