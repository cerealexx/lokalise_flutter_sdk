// ignore: dangling_library_doc_comments
/// This class is based on
/// https://github.com/dart-lang/intl_translation/blob/e27424105c3380297ce564a95771446080181e48/bin/extract_to_arb.dart
///
/// We need to create a proxy to connect with the intl_translation library
/// because it doesn't have 'public' methods to call to the generator, as it
/// is a command.
/// Also, we can't execute the command directly from our code using
/// Process.run because flutter doesn't let executing commands on transitive
/// dependencies and we need to control the version of intl_translation that we are
/// using.
///
/// Important Note: this file need to be revised after update to the intl_translation
/// version to adapt to the new version of the library, please check the new
/// version of generate_from_arb.dart from the library to understand what changes
/// should you apply here.

// ignore_for_file: implementation_imports

import 'dart:io';
import 'package:lokalise_flutter_sdk/src/generator/exceptions/generator_exception.dart';
import 'package:lokalise_flutter_sdk/src/extensions/file.dart';
import 'package:lokalise_flutter_sdk/src/extensions/directory.dart';
import 'package:intl_translation/extract_messages.dart';
import 'package:intl_translation/generate_localized.dart';
import 'package:intl_translation/src/message_parser.dart';
import 'package:intl_translation/src/messages/message.dart';
import 'package:intl_translation/src/messages/literal_string_message.dart';
import 'package:intl_translation/src/messages/main_message.dart';

class IntlTranslationProxy {
  final MessageExtraction _extraction = MessageExtraction();
  final MessageGeneration _generation = MessageGeneration();

  IntlTranslationProxy() {
    _extraction.suppressWarnings = true;
    _generation.useDeferredLoading = false;
    _generation.generatedFilePrefix = '';
  }

  Future<void> generateFromArb({
    required Directory outputDir,
    required File localizationFile,
    required List<File> arbFiles,
  }) async {
    Map<String, MainMessage> allMessages =
        _extraction.parseFile(localizationFile);
    Map<String, List<MainMessage>> messages = {};
    allMessages.forEach(
        (key, value) => messages.putIfAbsent(key, () => []).add(value));

    _generateLocaleFiles(arbFiles, outputDir, messages);

    outputDir.createFile(
      withName: '${_generation.generatedFilePrefix}messages_all.dart',
    );

    final mainImportFile = await outputDir.createFile(
      withName: '${_generation.generatedFilePrefix}messages_all.dart',
    );
    mainImportFile.writeAsStringSync(_generation.generateMainImportFile());

    final localesImportFile = await outputDir.createFile(
      withName: '${_generation.generatedFilePrefix}messages_all_locales.dart',
    );
    localesImportFile
        .writeAsStringSync(_generation.generateLocalesImportFile());
  }

  void _generateLocaleFiles(
    List<File> arbFiles,
    Directory outputDir,
    Map<String, List<MainMessage>> messages,
  ) {
    for (File arbFile in arbFiles) {
      String? locale = arbFile.extractLocale();
      if (locale == null) {
        throw GeneratorException('@@locale not found on ${arbFile.path}');
      }

      final parsedArb = arbFile.readAsArb();
      parsedArb.removeWhere((key, _) => key.startsWith('@'));

      final translations = parsedArb.entries
          .map((e) => _recreateIntlObjects(e.key, e.value, messages))
          .toList();

      _generation.allLocales.add(locale);
      _generation.generateIndividualMessageFile(
        locale,
        translations,
        outputDir.path,
      );
    }
  }

  TranslatedMessage _recreateIntlObjects(
    String id,
    String data,
    Map<String, List<MainMessage>> messages,
  ) {
    MessageParser messageParser = MessageParser(data);
    Message parsed = messageParser.pluralGenderSelectParse();
    if (parsed is LiteralString && parsed.string.isEmpty) {
      parsed = messageParser.nonIcuMessageParse();
    }
    return TranslatedMessage(id, parsed, messages[id] ?? []);
  }
}
