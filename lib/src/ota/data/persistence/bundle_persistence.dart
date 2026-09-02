import 'dart:convert';

import 'package:lokalise_flutter_sdk/src/ota/data/persistence/bundle_document_store.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/persistence/entities/bundle_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BundlePersistence {
  static const legacyBundleKey = 'lokalise_stored_bundle';

  final SharedPreferences _sharedPreferences;
  final BundleDocumentStore _documentStore;

  BundlePersistence({
    required SharedPreferences sharedPreferences,
    required BundleDocumentStore documentStore,
  })  : _sharedPreferences = sharedPreferences,
        _documentStore = documentStore;

  Future<BundleEntity?> get() async {
    String? storedValue;
    try {
      storedValue = await _documentStore.read();
    } catch (_) {
      // A legacy value can still keep startup operational.
    }

    final storedEntity = _decode(storedValue);
    if (storedEntity != null) {
      await _removeLegacyBestEffort();
      return storedEntity;
    }

    String? legacyValue;
    try {
      legacyValue = _sharedPreferences.getString(legacyBundleKey);
    } catch (_) {
      return null;
    }
    final legacyEntity = _decode(legacyValue);
    if (legacyEntity == null) {
      return null;
    }

    try {
      await _documentStore.replace(
        legacyValue!,
        validator: _isValid,
      );
      final migratedValue = await _documentStore.read();
      if (migratedValue != legacyValue || _decode(migratedValue) == null) {
        return legacyEntity;
      }
      await _removeLegacyBestEffort();
    } catch (_) {
      // Keep using and retaining the legacy value so migration can retry.
    }

    return legacyEntity;
  }

  Future<bool> save({required BundleEntity bundleEntity}) async {
    final value = jsonEncode(bundleEntity.toJson());
    try {
      await _documentStore.replace(value, validator: _isValid);
      final storedValue = await _documentStore.read();
      if (storedValue != value || _decode(storedValue) == null) {
        return false;
      }
      await _removeLegacyBestEffort();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> remove() async {
    var removed = false;
    try {
      removed = await _documentStore.remove();
    } catch (_) {
      // Still remove the legacy value to avoid resurrecting invalid data.
    }
    try {
      removed = await _sharedPreferences.remove(legacyBundleKey) || removed;
    } catch (_) {
      // Persistence failures are non-fatal to SDK consumers.
    }
    return removed;
  }

  Future<void> _removeLegacyBestEffort() async {
    try {
      if (_sharedPreferences.getString(legacyBundleKey) != null) {
        await _sharedPreferences.remove(legacyBundleKey);
      }
    } catch (_) {
      // A valid document store always takes precedence over legacy cleanup.
    }
  }

  bool _isValid(String value) => _decode(value) != null;

  BundleEntity? _decode(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    try {
      final json = jsonDecode(value);
      if (json is! Map<String, dynamic>) {
        return null;
      }
      return BundleEntity.fromJson(json: json);
    } catch (_) {
      return null;
    }
  }
}
