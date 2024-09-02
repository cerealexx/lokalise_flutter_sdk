import 'package:lokalise_flutter_sdk/src/ota/domain/data_source/local_bundle_data_source.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/data_source/remote_bundle_data_source.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/dto/get_up_to_date_bundle_dto.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/exceptions/auth_exception.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/exceptions/bundle_not_found_exception.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/exceptions/lokalise_exception.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/bundle.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/services/logger.dart';

class GetUpToDateBundleUseCase {
  final RemoteBundleDataSource _remoteDS;
  final LocalBundleDataSource _localDS;
  final Logger? _logger;

  GetUpToDateBundleUseCase({
    required RemoteBundleDataSource remoteBundleDataSource,
    required LocalBundleDataSource localBundleDataSource,
    required Logger? logger,
  })  : _remoteDS = remoteBundleDataSource,
        _localDS = localBundleDataSource,
        _logger = logger;

  Future<Bundle> getBundle({required GetUpToDateBundleDto dto}) async {
    Bundle? bundle;
    try {
      bundle = await _remoteDS.getBundle(getUpToDateBundleDto: dto);

      if (bundle != null &&
          bundle.translationVersion != dto.translationVersion) {
        await _localDS.saveBundle(bundle: bundle);
      } else {
        bundle = _localDS.getBundle();
      }
    } on BundleNotFoundException {
      await _localDS.removeBundle();
    } on AuthException catch (e) {
      _logger?.exception(e);
      await _localDS.removeBundle();
    } on Exception catch (e) {
      _logger?.exception(e);
      throw LokaliseException(e.toString());
    } catch (e) {
      final exception = LokaliseException('Unexpected error');
      _logger?.exception(exception);
      throw exception;
    }

    return bundle ??
        Bundle.empty(
          projectId: dto.credentials.projectId,
          appVersion: dto.appVersion,
        );
  }
}
