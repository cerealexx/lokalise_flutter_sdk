import 'package:lokalise_flutter_sdk/src/ota/domain/models/translation/translation.dart';

class LanguageBundle {
  final String locale;
  final Map<String, Translation> translations;

  LanguageBundle({required this.locale, required this.translations});

  LanguageBundle.empty({required this.locale}) : translations = {};

  bool get isEmpty => translations.isEmpty;

  bool get isNotEmpty => translations.isNotEmpty;
}
