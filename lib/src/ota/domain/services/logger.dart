import 'dart:io';
import 'package:logger/logger.dart' as package;
import 'package:lokalise_flutter_sdk/src/constants.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/json_serializable.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/services/device_info.dart';

class Logger {
  final DeviceInfo _deviceInfo;
  final package.Logger _logger;

  Logger({required DeviceInfo deviceInfo, package.Logger? logger})
      : _deviceInfo = deviceInfo,
        _logger = logger ??
            package.Logger(
              printer: package.PrettyPrinter(
                methodCount: 0,
                colors: deviceInfo.isWeb ? true : stdout.supportsAnsiEscapes,
                lineLength: deviceInfo.isWeb
                    ? kLoggerDefaultLineLength
                    : (stdout.hasTerminal
                        ? stdout.terminalColumns
                        : kLoggerDefaultLineLength),
              ),
              filter: package.DevelopmentFilter(),
            );

  void exception(Exception exception) {
    _logger.w({
      'name': 'Lokalise exception',
      'device_info': _deviceInfo.toJson(),
      'error': _transformException(exception)
    });
  }

  Map<String, dynamic> _transformException(Exception exception) {
    if (exception is JsonSerializable) {
      return (exception as JsonSerializable).toJson();
    }
    if (exception is SocketException) {
      return {
        'message': exception.message,
        'os_error': exception.osError,
      };
    }

    return {'message': exception.toString()};
  }
}
