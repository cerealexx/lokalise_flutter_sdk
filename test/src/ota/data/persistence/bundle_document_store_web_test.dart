import 'bundle_document_store_web_test_stub.dart'
    if (dart.library.js_interop) 'bundle_document_store_web_test_browser.dart'
    as implementation;

void main() => implementation.runTests();
