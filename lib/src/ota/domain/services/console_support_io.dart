import 'dart:io';

bool get supportsAnsiEscapes => stdout.supportsAnsiEscapes;
bool get hasTerminal => stdout.hasTerminal;
int get terminalColumns => stdout.terminalColumns;
