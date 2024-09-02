import 'package:lokalise_flutter_sdk/src/ota/domain/dto/get_up_to_date_bundle_dto.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/bundle.dart';

abstract class RemoteBundleDataSource {
  Future<Bundle?> getBundle({
    required GetUpToDateBundleDto getUpToDateBundleDto,
  });
}
