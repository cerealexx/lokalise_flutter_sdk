import 'dart:io';

Map<String, dynamic>? socketExceptionDetails(Object exception) {
  if (exception is! SocketException) {
    return null;
  }
  return {
    'message': exception.message,
    'os_error': exception.osError,
  };
}
