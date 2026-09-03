import 'package:logger/logger.dart' as package;
import 'package:lokalise_flutter_sdk/src/constants.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/json_serializable.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/services/console_support.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/services/device_info.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/services/socket_exception_details.dart';

class Logger {
  final DeviceInfo _deviceInfo;
  final package.Logger _logger;

  Logger({required DeviceInfo deviceInfo, package.Logger? logger})
      : _deviceInfo = deviceInfo,
        _logger = logger ??
            package.Logger(
              printer: package.PrettyPrinter(
                methodCount: 0,
                colors: deviceInfo.isWeb ? true : consoleSupportsAnsiEscapes,
                lineLength: deviceInfo.isWeb
                    ? kLoggerDefaultLineLength
                    : (consoleHasTerminal
                        ? consoleTerminalColumns
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
    final socketDetails = socketExceptionDetails(exception);
    if (socketDetails != null) {
      return socketDetails;
    }

    return {'message': exception.toString()};
  }
}
