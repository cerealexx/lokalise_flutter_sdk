// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static m1(name) => "Hello ${name}";

  static m2(count) =>
      "${Intl.plural(count, zero: 'No items', one: 'One item', other: '${count} items')}";

  static m3(first, second) => "First ${first}, second ${second}";

  static m4(choice) => "${Intl.select(choice, {
            'short': 'Short label',
            'long': 'Long label',
            'other': 'Other label',
          })}";

  @override
  final Map<String, dynamic> messages =
      _notInlinedMessages(_notInlinedMessages);

  static Map<String, dynamic> _notInlinedMessages(Object? _) => {
        'literal': MessageLookupByLibrary.simpleMessage('Plain text'),
        'ordinary': m1,
        'plural': m2,
        'reordered': m3,
        'select': m4
      };
}
