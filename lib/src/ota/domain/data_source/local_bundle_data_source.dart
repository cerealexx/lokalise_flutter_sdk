import 'package:lokalise_flutter_sdk/src/ota/domain/models/bundle.dart';

abstract class LocalBundleDataSource {
  Future<Bundle?> getBundle();
  Future<bool> saveBundle({required Bundle bundle});
  Future<bool> removeBundle();
}
