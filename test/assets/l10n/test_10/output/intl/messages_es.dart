// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a es locale. All the
// messages from the main program should be duplicated here with the same
// function name.
// @dart=2.12
// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = MessageLookup();

typedef String? MessageIfAbsent(String? messageStr, List<Object>? args);

class MessageLookup extends MessageLookupByLibrary {
  @override
  String get localeName => 'es';

  static m1(name) => "Hola ${name}";

  static m2(count) =>
      "${Intl.plural(count, zero: 'Ningún elemento', one: 'Un elemento', other: '${count} elementos')}";

  static m3(first, second) => "Segundo ${second}, primero ${first}";

  static m4(choice) => "${Intl.select(choice, {
            'short': 'Etiqueta corta',
            'long': 'Etiqueta larga',
            'other': 'Otra etiqueta',
          })}";

  @override
  final Map<String, dynamic> messages =
      _notInlinedMessages(_notInlinedMessages);

  static Map<String, dynamic> _notInlinedMessages(Object? _) => {
        'literal': MessageLookupByLibrary.simpleMessage('Texto plano'),
        'ordinary': m1,
        'plural': m2,
        'reordered': m3,
        'select': m4
      };
}
