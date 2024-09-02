// ignore: implementation_imports
import 'package:intl/src/intl_helpers.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/update_result.dart';
import 'package:lokalise_flutter_sdk/lokalise_flutter_sdk.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/dto/get_up_to_date_bundle_dto.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/credentials.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/services/message_lookup_proxy.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/use_cases/get_local_bundle_use_case.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/use_cases/get_up_to_date_bundle_use_case.dart';

class LokaliseV2 extends Lokalise {
  final Credentials _credentials;
  final String _appVersion;
  final bool _preRelease;
  final GetLocalBundleUseCase _getLocalBundleUseCase;
  final GetUpToDateBundleUseCase _getUpToDateBundleUseCase;
  final MessageLookupProxy _messageLookupProxy;

  LokaliseV2({
    required Credentials credentials,
    required String appVersion,
    required bool preRelease,
    required GetLocalBundleUseCase getLocalBundleUseCase,
    required GetUpToDateBundleUseCase getUpToDateBundleUseCase,
    required MessageLookupProxy messageLookupProxy,
  })  : _credentials = credentials,
        _appVersion = appVersion,
        _preRelease = preRelease,
        _getLocalBundleUseCase = getLocalBundleUseCase,
        _getUpToDateBundleUseCase = getUpToDateBundleUseCase,
        _messageLookupProxy = messageLookupProxy {
    messageLookup = _messageLookupProxy;
  }

  Future<void> load() async {
    final bundle = await _getLocalBundleUseCase.getBundle(
      projectId: _credentials.projectId,
      appVersion: _appVersion,
    );
    _messageLookupProxy.bundle = bundle;
  }

  @override
  Future<UpdateResult> update() async {
    final dto = GetUpToDateBundleDto(
      credentials: _credentials,
      appVersion: _appVersion,
      translationVersion: _messageLookupProxy.translationVersion,
      preRelease: _preRelease,
    );
    final bundle = await _getUpToDateBundleUseCase.getBundle(dto: dto);

    _messageLookupProxy.bundle = bundle;

    return UpdateResult(
      oldbundleVersion: dto.translationVersion,
      newBundleVersion: bundle.translationVersion,
    );
  }

  @override
  set metadata(Map<String, List<String>> metadata) {
    _messageLookupProxy.addArgNamesByKeyName(metadata);
  }
}
