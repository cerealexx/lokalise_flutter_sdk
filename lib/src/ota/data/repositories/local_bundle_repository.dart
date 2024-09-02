import 'package:lokalise_flutter_sdk/src/ota/data/persistence/bundle_persistence.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/persistence/entities/bundle_entity.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/data_source/local_bundle_data_source.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/bundle.dart';

class LocalBundleRepository implements LocalBundleDataSource {
  final BundlePersistence _persistence;

  LocalBundleRepository({required BundlePersistence persistence})
      : _persistence = persistence;

  @override
  Bundle? getBundle() {
    final bundleEntity = _persistence.get();
    if (bundleEntity == null) {
      return null;
    }

    return bundleEntity.toBundle();
  }

  @override
  Future<bool> saveBundle({required Bundle bundle}) {
    return _persistence.save(
      bundleEntity: BundleEntity.fromBundle(bundle: bundle),
    );
  }

  @override
  Future<bool> removeBundle() {
    return _persistence.remove();
  }
}
