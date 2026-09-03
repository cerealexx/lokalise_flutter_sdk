import 'dart:async';
import 'dart:js_interop';

import 'package:lokalise_flutter_sdk/src/ota/data/persistence/bundle_document_store.dart';
import 'package:web/web.dart';

BundleDocumentStore createBundleDocumentStore() => WebBundleDocumentStore();

class WebBundleDocumentStore implements BundleDocumentStore {
  static const defaultDatabaseName = 'lokalise_flutter_sdk';
  static const _databaseVersion = 1;
  static const _objectStoreName = 'bundle_documents';
  static const _bundleKey = 'ota_bundle';

  final String _databaseName;
  Future<IDBDatabase>? _database;

  WebBundleDocumentStore({String databaseName = defaultDatabaseName})
      : _databaseName = databaseName;

  @override
  Future<String?> read() async {
    final database = await _openDatabase();
    final transaction = database.transaction(
      _objectStoreName.toJS,
      'readonly',
    );
    final request = transaction.objectStore(_objectStoreName).get(
          _bundleKey.toJS,
        );
    final result = await _requestResult(request);
    final value = result?.dartify();
    return value is String ? value : null;
  }

  @override
  Future<void> replace(
    String value, {
    required BundleDocumentValidator validator,
  }) async {
    if (!validator(value)) {
      throw const FormatException('Invalid OTA bundle document');
    }

    final database = await _openDatabase();
    final transaction = database.transaction(
      _objectStoreName.toJS,
      'readwrite',
    );
    final completion = _transactionCompletion(transaction);
    transaction.objectStore(_objectStoreName).put(
          value.toJS,
          _bundleKey.toJS,
        );
    await completion;
  }

  @override
  Future<bool> remove() async {
    final existed = await read() != null;
    final database = await _openDatabase();
    final transaction = database.transaction(
      _objectStoreName.toJS,
      'readwrite',
    );
    final completion = _transactionCompletion(transaction);
    transaction.objectStore(_objectStoreName).delete(_bundleKey.toJS);
    await completion;
    return existed;
  }

  Future<IDBDatabase> _openDatabase() => _database ??= _createDatabase();

  Future<IDBDatabase> _createDatabase() {
    final completer = Completer<IDBDatabase>.sync();
    final request = window.indexedDB.open(_databaseName, _databaseVersion);

    request.onupgradeneeded = ((IDBVersionChangeEvent _) {
      final database = request.result as IDBDatabase;
      if (!database.objectStoreNames.contains(_objectStoreName)) {
        database.createObjectStore(_objectStoreName);
      }
    }).toJS;
    request.onsuccess = ((Event _) {
      if (!completer.isCompleted) {
        completer.complete(request.result as IDBDatabase);
      }
    }).toJS;
    request.onerror = ((Event event) {
      if (!completer.isCompleted) {
        completer.completeError(request.error ?? event);
      }
    }).toJS;
    request.onblocked = ((Event event) {
      if (!completer.isCompleted) {
        completer.completeError(request.error ?? event);
      }
    }).toJS;

    return completer.future;
  }

  Future<JSAny?> _requestResult(IDBRequest request) {
    final completer = Completer<JSAny?>.sync();
    request.onsuccess = ((Event _) {
      if (!completer.isCompleted) {
        completer.complete(request.result);
      }
    }).toJS;
    request.onerror = ((Event event) {
      if (!completer.isCompleted) {
        completer.completeError(request.error ?? event);
      }
    }).toJS;
    return completer.future;
  }

  Future<void> _transactionCompletion(IDBTransaction transaction) {
    final completer = Completer<void>.sync();
    transaction.oncomplete = ((Event _) {
      if (!completer.isCompleted) {
        completer.complete();
      }
    }).toJS;
    transaction.onerror = ((Event event) {
      if (!completer.isCompleted) {
        completer.completeError(transaction.error ?? event);
      }
    }).toJS;
    transaction.onabort = ((Event event) {
      if (!completer.isCompleted) {
        completer.completeError(transaction.error ?? event);
      }
    }).toJS;
    return completer.future;
  }
}
