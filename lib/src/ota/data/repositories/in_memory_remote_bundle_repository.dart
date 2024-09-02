import 'package:flutter/material.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/data_source/remote_bundle_data_source.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/dto/get_up_to_date_bundle_dto.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/bundle.dart';

class InMemoryRemoteBundleRepository implements RemoteBundleDataSource {
  final Bundle? _remoteBundle;

  InMemoryRemoteBundleRepository({@required Bundle? bundle})
      : _remoteBundle = bundle;

  @override
  Future<Bundle?> getBundle({
    required GetUpToDateBundleDto getUpToDateBundleDto,
  }) {
    return getUpToDateBundleDto.translationVersion ==
            _remoteBundle?.translationVersion
        ? Future.value(null)
        : Future.value(_remoteBundle);
  }
}
