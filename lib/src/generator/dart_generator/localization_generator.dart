import 'dart:io';

import 'package:lokalise_flutter_sdk/src/generator/parser/label.dart';
import 'package:lokalise_flutter_sdk/src/extensions/string.dart';
import 'package:lokalise_flutter_sdk/src/extensions/file.dart';
import 'package:lokalise_flutter_sdk/src/extensions/directory.dart';

class LocalizationGenerator {
  final bool _otaEnabled = true;
  final List<Label> _labels;
  final List<String> _locales;

  LocalizationGenerator({
    required File templateArb,
    required List<String> locales,
    required List<String> preferedSupportedLocales,
  })  : _labels = _extractLabels(templateArb),
        // Dart pass Iterables by reference and we don't want to modify the
        // original values so we have to create a copy.
        _locales = _sortLocales(
          List<String>.from(locales),
          List<String>.from(preferedSupportedLocales),
        );

  static List<Label> _extractLabels(File templateArb) {
    final content = templateArb.readAsArb();

    return content.keys.where((key) => !key.startsWith('@')).map((key) {
      final Map<String, dynamic> meta = content['@$key'] ?? <String, dynamic>{};

      final Map<String, dynamic> metaPlaceholders =
          meta['placeholders'] ?? <String, dynamic>{};
      final placeholders = metaPlaceholders.keys
          .map((key) => Placeholder(key, key, metaPlaceholders[key]))
          .toList();

      return Label(
        key,
        content[key],
        type: meta['type'],
        description: meta['description'],
        placeholders: placeholders.isNotEmpty ? placeholders : null,
      );
    }).toList();
  }

  static List<String> _sortLocales(
    List<String> locales,
    List<String> preferedSupportedLocales,
  ) {
    // Sorting alphabetically
    locales.sort((a, b) => a.compareTo(b));
    // Removing preferedSupportedLocales which we don't want to generate (without files)
    preferedSupportedLocales.removeWhere((e) => !locales.contains(e));
    // Removing locales present in preferedSupportedLocales
    locales.removeWhere((e) => preferedSupportedLocales.contains(e));

    // preferedSupportedLocales + alphabetically sorted locales
    return preferedSupportedLocales + locales;
  }

  Future<File> generate({
    required Directory onDirectory,
    required String withFileName,
    required String withClassName,
  }) async {
    final content = _buildContent(withClassName);
    final lozalizationFile = await onDirectory.createFile(
      withName: withFileName,
    );
    lozalizationFile.writeDart(content: content);

    return lozalizationFile;
  }

  String _buildContent(String className) {
    return """
      // GENERATED CODE
      //
      // After the template files .arb have been changed,
      // generate this class by the command in the terminal:
      // flutter pub run lokalise_flutter_sdk:gen-lok-l10n
      //
      // Please see https://pub.dev/packages/lokalise_flutter_sdk

      // ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
      // ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
      // ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes
      // ignore_for_file: depend_on_referenced_packages

      import 'package:flutter/material.dart';
      import 'package:flutter_localizations/flutter_localizations.dart';
      import 'package:intl/intl.dart';
      ${_buildLokaliseSdkImport()}
      import 'intl/messages_all.dart';

      class $className {
        $className._internal() {
          _initializeMappedTranslations();
        }

        late final Map<String, dynamic> _translations;

        static const LocalizationsDelegate<$className> delegate = _AppLocalizationDelegate();

        static const List<Locale> supportedLocales = [${_buildLocales()}];

        static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
          delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ];

        ${_buildMetadata()}

        void _initializeMappedTranslations() {
          _translations = {
            ${_labels.map((l) => """
              '${l.name}': () => ${l.name},
            """).join()}
          };
        }

        dynamic getByKey(String key) {
          return _translations[key]?.call() ?? '';
        }

        static Future<$className> load(Locale locale) {
          final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
          final localeName = Intl.canonicalizedLocale(name);
          ${_buildMetadataSetter()}

          return initializeMessages(localeName).then((_) {
            Intl.defaultLocale = localeName;
            final instance = $className._internal();
            return instance;
          });
        } 

        static $className of(BuildContext context) {
          final instance = Localizations.of<$className>(context, $className);
          assert(instance != null,
              'No instance of $className present in the widget tree. Did you add $className.delegate in localizationsDelegates?');
          return instance!;
        }

        ${_labels.map((l) => l.generateDartGetter()).join()}
      }

      class _AppLocalizationDelegate extends LocalizationsDelegate<$className> {
        const _AppLocalizationDelegate();

        @override
        bool isSupported(Locale locale) => $className.supportedLocales.any(
            (supportedLocale) => supportedLocale.languageCode == locale.languageCode);

        @override
        Future<$className> load(Locale locale) => $className.load(locale);

        @override
        bool shouldReload(_AppLocalizationDelegate old) => false;
      }
    """;
  }

  String _buildLokaliseSdkImport() => _otaEnabled
      ? "import 'package:lokalise_flutter_sdk/lokalise_flutter_sdk.dart';"
      : '';

  String _buildMetadataSetter() =>
      _otaEnabled ? 'Lokalise.instance.metadata = _metadata;' : '';

  String _buildLocales() => _locales.map((locale) {
        final parts = locale.split('_');
        if (locale.isLangScriptCountryLocale) {
          return "Locale.fromSubtags(languageCode: '${parts[0]}', scriptCode: '${parts[1]}', countryCode: '${parts[2]}')";
        } else if (locale.isLangScriptLocale) {
          return "Locale.fromSubtags(languageCode: '${parts[0]}', scriptCode: '${parts[1]}')";
        } else if (locale.isLangCountryLocale) {
          return "Locale.fromSubtags(languageCode: '${parts[0]}', countryCode: '${parts[1]}')";
        } else {
          return "Locale.fromSubtags(languageCode: '${parts[0]}')";
        }
      }).join(',');

  String _buildMetadata() {
    if (!_otaEnabled) {
      return '';
    }

    final metadata = _labels.map((label) => label.generateMetadata()).join(',');
    return 'static final Map<String, List<String>> _metadata = {$metadata};';
  }
}
