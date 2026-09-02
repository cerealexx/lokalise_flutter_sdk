import 'package:lokalise_flutter_sdk/src/ota/domain/services/console_support_stub.dart'
    if (dart.library.io) 'package:lokalise_flutter_sdk/src/ota/domain/services/console_support_io.dart'
    as implementation;

bool get consoleSupportsAnsiEscapes => implementation.supportsAnsiEscapes;

bool get consoleHasTerminal => implementation.hasTerminal;

int get consoleTerminalColumns => implementation.terminalColumns;
