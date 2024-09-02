import 'package:archive/archive_io.dart';
import 'package:http/http.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/api/clients/bundle_downloader/response/bundle_downloader_response.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/api/exceptions/api_exception.dart';

class BundleDownloaderClient extends BaseClient {
  final Client _inner;
  final ZipDecoder _zipDecoder;

  BundleDownloaderClient({
    required Client httpClient,
    required ZipDecoder zipDecoder,
  })  : _inner = httpClient,
        _zipDecoder = zipDecoder;

  @override
  Future<StreamedResponse> send(BaseRequest request) => _inner.send(request);

  Future<BundleDownloaderResponse> download({
    required String resourceUrl,
  }) async {
    final response = await this.get(Uri.parse(resourceUrl));

    final code = response.statusCode;
    if (code != 200) {
      throw ApiException(httpCode: code, responseBody: response.body);
    }

    return BundleDownloaderResponse.success(
      httpCode: code,
      result: _zipDecoder.decodeBytes(response.bodyBytes),
    );
  }
}
