import 'package:flutter/foundation.dart';
import 'package:lokalise_flutter_sdk/src/constants.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/json_serializable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:io';

class DeviceInfo implements JsonSerializable {
  final PackageInfo _packageInfo;
  String _appVersion;

  DeviceInfo({
    required PackageInfo packageInfo,
    required String appVersion,
  })  : _packageInfo = packageInfo,
        _appVersion = appVersion;

  String get appVersion {
    if (_appVersion.trim().isEmpty) {
      _appVersion = _standardizeVersion(_packageInfo.version);
    }
    return _appVersion;
  }

  String get packageName => _packageInfo.packageName;

  bool get isWeb => kIsWeb;

  String get platform => isWeb ? 'web' : Platform.operatingSystem;

  String get lokaliseSdkVersion => kLokaliseSdkVersion;

  String _standardizeVersion(String version) {
    if (version.contains('-')) {
      return _standardizeVersion(version.split('-').first);
    }

    if (version.contains('+')) {
      return _standardizeVersion(version.split('+').first);
    }

    return version;
  }

  @override
  Map<String, dynamic> toJson() => {
        'sdk_version': lokaliseSdkVersion,
        'app_version': appVersion,
        'package_name': packageName,
        'platform': platform,
      };
}
