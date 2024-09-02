// ignore_for_file: implementation_imports
import 'package:intl_translation/src/message_parser.dart';
import 'package:intl_translation/src/messages/message.dart';
import 'package:intl_translation/src/messages/literal_string_message.dart';
import 'package:intl_translation/src/messages/variable_substitution_message.dart';
import 'package:intl_translation/src/messages/composite_message.dart';
import 'package:intl_translation/src/messages/submessages/plural.dart';

import 'package:lokalise_flutter_sdk/src/ota/domain/models/translation/plural_translation.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/translation/simple_translation.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/translation/translation.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/translation/translation_element.dart';

class MessageParserWrapper {
  final String _text;

  MessageParserWrapper({required String text}) : _text = text;

  Translation? get translation {
    final messageParser = MessageParser(_text);
    Message message = messageParser.pluralGenderSelectParse();
    if (message is LiteralString && message.string.isEmpty) {
      message = messageParser.nonIcuMessageParse();
    }

    return _convertToTranslation(message);
  }

  Translation? _convertToTranslation(Message? message) {
    if (message == null) {
      return null;
    } else if (message is LiteralString) {
      return SimpleTranslation(
        elements: [_convertToTranslationElements(message)]
            .whereType<TranslationElement>()
            .toList(),
      );
    } else if (message is CompositeMessage) {
      return SimpleTranslation(
          elements: message.pieces
              .map((e) => _convertToTranslationElements(e))
              .whereType<TranslationElement>()
              .toList());
    } else if (message is Plural) {
      return PluralTranslation(
        argument: message.mainArgument,
        zero: _convertToTranslation(message.zero),
        one: _convertToTranslation(message.one),
        two: _convertToTranslation(message.two),
        few: _convertToTranslation(message.few),
        many: _convertToTranslation(message.many),
        other: _convertToTranslation(message.other) ??
            SimpleTranslation(elements: []),
      );
    }

    return null;
  }

  TranslationElement? _convertToTranslationElements(Message message) {
    if (message is LiteralString) {
      return TranslationElement.literal(value: message.string);
    } else if (message is VariableSubstitution) {
      return TranslationElement.placeholder(value: message.variableName ?? '');
    }

    return null;
  }
}
