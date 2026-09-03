import 'package:lokalise_flutter_sdk/src/ota/domain/services/socket_exception_details_stub.dart'
    if (dart.library.io) 'package:lokalise_flutter_sdk/src/ota/domain/services/socket_exception_details_io.dart'
    as implementation;

Map<String, dynamic>? socketExceptionDetails(Object exception) =>
    implementation.socketExceptionDetails(exception);
