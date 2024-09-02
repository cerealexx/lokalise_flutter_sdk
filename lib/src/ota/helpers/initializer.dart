// ignore: implementation_imports
import 'package:intl/src/intl_helpers.dart';
import 'package:archive/archive_io.dart';
import 'package:http/http.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/data_source/local_bundle_data_source.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/data_source/remote_bundle_data_source.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/bundle.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/services/device_info.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/services/logger.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/services/message_lookup_proxy.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/use_cases/get_local_bundle_use_case.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/use_cases/get_up_to_date_bundle_use_case.dart';
import 'package:lokalise_flutter_sdk/src/ota/lokalise_v2.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/api/clients/bundle_downloader/bundle_downloader_client.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/api/clients/ota/ota_client.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/api/ota_api.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/persistence/bundle_persistence.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/repositories/local_bundle_repository.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/repositories/remote_bundle_repository.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/credentials.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Initializer {
  final String _projectId;
  final String _sdkToken;
  final bool _preRelease;
  final String _appVersion;
  final bool _logging;

  Initializer({
    required String projectId,
    required String sdkToken,
    required String appVersion,
    required bool preRelease,
    required bool logging,
  })  : _projectId = projectId,
        _sdkToken = sdkToken,
        _appVersion = appVersion,
        _preRelease = preRelease,
        _logging = logging;

  Future<LokaliseV2> get lokalise async {
    final localDS = await _localBundleDataSource;
    final deviceInfo = await _deviceInfoService;
    final logger = _logging ? Logger(deviceInfo: deviceInfo) : null;

    return LokaliseV2(
      credentials: Credentials(projectId: _projectId, token: _sdkToken),
      appVersion: deviceInfo.appVersion,
      preRelease: _preRelease,
      getLocalBundleUseCase: GetLocalBundleUseCase(
        localBundleDataSource: localDS,
        logger: logger,
      ),
      getUpToDateBundleUseCase: GetUpToDateBundleUseCase(
        localBundleDataSource: localDS,
        remoteBundleDataSource: _remoteBundleDataSource(deviceInfo),
        logger: logger,
      ),
      messageLookupProxy: MessageLookupProxy(
        messageLookup: messageLookup,
        bundle: Bundle.empty(
          projectId: _projectId,
          appVersion: deviceInfo.appVersion,
        ),
      ),
    );
  }

  Future<LocalBundleDataSource> get _localBundleDataSource async =>
      LocalBundleRepository(
        persistence: BundlePersistence(
          sharedPreferences: await SharedPreferences.getInstance(),
        ),
      );

  Future<DeviceInfo> get _deviceInfoService async => DeviceInfo(
        packageInfo: await PackageInfo.fromPlatform(),
        appVersion: _appVersion,
      );

  RemoteBundleDataSource _remoteBundleDataSource(DeviceInfo deviceInfo) {
    final client = Client();
    return RemoteBundleRepository(
      otaApi: OtaApi(
        otaClient: OtaClient(
          httpClient: client,
          deviceInfo: deviceInfo,
        ),
        downloaderClient: BundleDownloaderClient(
          httpClient: client,
          zipDecoder: ZipDecoder(),
        ),
      ),
    );
  }
}
