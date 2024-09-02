import 'package:archive/archive_io.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/api/clients/base_client_response.dart';

class BundleDownloaderResponse extends BaseClientResponse<Archive, String> {
  BundleDownloaderResponse.success({
    required super.httpCode,
    required super.result,
  }) : super.success();
}
