import 'package:lokalise_flutter_sdk/src/ota/data/persistence/bundle_document_store.dart';

BundleDocumentStore createBundleDocumentStore() =>
    const UnsupportedBundleDocumentStore();

class UnsupportedBundleDocumentStore implements BundleDocumentStore {
  const UnsupportedBundleDocumentStore();

  UnsupportedError get _error =>
      UnsupportedError('OTA bundle persistence is not supported');

  @override
  Future<String?> read() => Future<String?>.error(_error);

  @override
  Future<void> replace(
    String value, {
    required BundleDocumentValidator validator,
  }) =>
      Future<void>.error(_error);

  @override
  Future<bool> remove() => Future<bool>.error(_error);
}
