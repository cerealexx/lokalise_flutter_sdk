import 'dart:convert';
import 'package:lokalise_flutter_sdk/src/ota/data/persistence/entities/bundle_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BundlePersistence {
  static const _bundleKey = 'lokalise_stored_bundle';

  final SharedPreferences _sharedPreferences;

  BundlePersistence({required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences;

  BundleEntity? get() {
    final jsonString = _sharedPreferences.getString(_bundleKey);
    if (jsonString == null || jsonString.isEmpty) {
      return null;
    }
    return BundleEntity.fromJson(json: jsonDecode(jsonString));
  }

  Future<bool> save({required BundleEntity bundleEntity}) async {
    final json = bundleEntity.toJson();
    return _sharedPreferences.setString(_bundleKey, jsonEncode(json));
  }

  Future<bool> remove() async {
    return _sharedPreferences.remove(_bundleKey);
  }
}
