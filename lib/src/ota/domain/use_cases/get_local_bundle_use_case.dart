import 'package:lokalise_flutter_sdk/src/ota/domain/data_source/local_bundle_data_source.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/bundle.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/services/logger.dart';

class GetLocalBundleUseCase {
  final LocalBundleDataSource _localDS;
  final Logger? _logger;

  GetLocalBundleUseCase({
    required LocalBundleDataSource localBundleDataSource,
    required Logger? logger,
  })  : _localDS = localBundleDataSource,
        _logger = logger;

  Future<Bundle> getBundle({
    required String projectId,
    required String appVersion,
  }) async {
    Bundle? bundle;

    try {
      bundle = _localDS.getBundle();

      if (bundle != null) {
        if (bundle.projectId != projectId || bundle.appVersion != appVersion) {
          bundle = null;
          await _localDS.removeBundle();
        }
      }
    } on Exception catch (e) {
      _logger?.exception(e);
    } catch (_) {
      // Nothing to do.
    }

    return bundle ?? Bundle.empty(projectId: projectId, appVersion: appVersion);
  }
}
