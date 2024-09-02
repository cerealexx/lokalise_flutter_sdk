import 'package:flutter/foundation.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/data_source/local_bundle_data_source.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/bundle.dart';

class InMemoryLocalBundleRepository implements LocalBundleDataSource {
  Bundle? _localBundle;

  InMemoryLocalBundleRepository({@required Bundle? bundle})
      : _localBundle = bundle;

  @override
  Bundle? getBundle() => _localBundle;

  @override
  Future<bool> removeBundle() {
    final exists = _localBundle != null;
    _localBundle = null;
    return Future.value(exists);
  }

  @override
  Future<bool> saveBundle({required Bundle bundle}) {
    _localBundle = bundle;
    return Future.value(true);
  }
}
