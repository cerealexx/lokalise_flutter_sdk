typedef BundleDocumentValidator = bool Function(String value);

/// Durable storage for the serialized OTA bundle document.
abstract class BundleDocumentStore {
  Future<String?> read();

  /// Atomically replaces the stored document after [validator] accepts it.
  Future<void> replace(
    String value, {
    required BundleDocumentValidator validator,
  });

  /// Removes the document and reports whether it existed.
  Future<bool> remove();
}
