import 'package:lokalise_flutter_sdk/src/ota/data/persistence/bundle_document_store.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/persistence/bundle_document_store_stub.dart'
    if (dart.library.io) 'package:lokalise_flutter_sdk/src/ota/data/persistence/bundle_document_store_io.dart'
    if (dart.library.js_interop) 'package:lokalise_flutter_sdk/src/ota/data/persistence/bundle_document_store_web.dart'
    as implementation;

BundleDocumentStore createBundleDocumentStore() =>
    implementation.createBundleDocumentStore();
