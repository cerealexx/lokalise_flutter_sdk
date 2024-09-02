import 'dart:io';

import 'package:logger/logger.dart' as package;
import 'package:lokalise_flutter_sdk/src/constants.dart';

class Logger {
  static final Logger instance = Logger._internal();

  final package.Logger _logger;

  Logger({required package.Logger logger}) : _logger = logger;

  Logger._internal()
      : this(
          logger: package.Logger(
            printer: package.PrettyPrinter(
              methodCount: 0,
              colors: stdout.supportsAnsiEscapes,
              lineLength: stdout.hasTerminal
                  ? stdout.terminalColumns
                  : kLoggerDefaultLineLength,
            ),
            filter: package.ProductionFilter(),
          ),
        );

  void info(String message) => _logger.i(message);

  void warning(String message) => _logger.w(message);

  void error(String message) => _logger.e(message);
}
