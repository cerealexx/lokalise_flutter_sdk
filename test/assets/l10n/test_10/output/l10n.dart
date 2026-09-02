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
import 'package:lokalise_flutter_sdk/lokalise_flutter_sdk.dart';
import 'intl/messages_all.dart';

class Lt {
  Lt._internal() {
    _initializeMappedTranslations();
  }

  late final Map<String, dynamic> _translations;

  static const LocalizationsDelegate<Lt> delegate = _AppLocalizationDelegate();

  static const List<Locale> supportedLocales = [
    Locale.fromSubtags(languageCode: 'en'),
    Locale.fromSubtags(languageCode: 'es'),
  ];

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  static final Map<String, List<String>> _metadata = {
    'literal': [],
    'ordinary': ['name'],
    'reordered': ['first', 'second'],
    'plural': ['count'],
    'select': ['choice'],
    'formatted': ['amount'],
  };

  void _initializeMappedTranslations() {
    _translations = {
      'literal': () => literal,
      'ordinary': () => ordinary,
      'reordered': () => reordered,
      'plural': () => plural,
      'select': () => select,
      'formatted': () => formatted,
    };
  }

  String getByKey(String key, {Map<String, Object> arguments = const {}}) {
    final translation = _translations[key]?.call();
    final argumentNames = _metadata[key];
    if (translation == null || argumentNames == null) {
      return '';
    }
    if (argumentNames.isEmpty) {
      return translation is String ? translation : '';
    }
    if (argumentNames.any((name) => !arguments.containsKey(name))) {
      return '';
    }

    try {
      final value = Function.apply(
        translation as Function,
        argumentNames.map((name) => arguments[name]).toList(),
      );
      return value is String ? value : '';
    } catch (_) {
      return '';
    }
  }

  static Future<Lt> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    Lokalise.instance.metadata = _metadata;

    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = Lt._internal();
      return instance;
    });
  }

  static Lt of(BuildContext context) {
    final instance = Localizations.of<Lt>(context, Lt);
    assert(
      instance != null,
      'No instance of Lt present in the widget tree. Did you add Lt.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  /// `Plain text`
  String get literal {
    return Intl.message('Plain text', name: 'literal', desc: '', args: []);
  }

  /// `Hello {name}`
  String ordinary(Object name) {
    return Intl.message(
      'Hello $name',
      name: 'ordinary',
      desc: '',
      args: [name],
    );
  }

  /// `First {first}, second {second}`
  String reordered(Object first, Object second) {
    return Intl.message(
      'First $first, second $second',
      name: 'reordered',
      desc: '',
      args: [first, second],
    );
  }

  /// `{count, plural, =0 {No items} =1 {One item} other {{count} items}}`
  String plural(num count) {
    return Intl.plural(
      count,
      zero: 'No items',
      one: 'One item',
      other: '$count items',
      name: 'plural',
      desc: '',
      args: [count],
    );
  }

  /// `{choice, select, short {Short label} long {Long label} other {Other label}}`
  String select(Object choice) {
    return Intl.select(
      choice,
      {'short': 'Short label', 'long': 'Long label', 'other': 'Other label'},
      name: 'select',
      desc: '',
      args: [choice],
    );
  }

  /// `Total {amount}`
  String formatted(double amount) {
    final NumberFormat amountNumberFormat = NumberFormat.decimalPattern(
      Intl.getCurrentLocale(),
    );
    final String amountString = amountNumberFormat.format(amount);

    return Intl.message(
      'Total $amountString',
      name: 'formatted',
      desc: '',
      args: [amountString],
    );
  }
}

class _AppLocalizationDelegate extends LocalizationsDelegate<Lt> {
  const _AppLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => Lt.supportedLocales.any(
    (supportedLocale) => supportedLocale.languageCode == locale.languageCode,
  );

  @override
  Future<Lt> load(Locale locale) => Lt.load(locale);

  @override
  bool shouldReload(_AppLocalizationDelegate old) => false;
}
