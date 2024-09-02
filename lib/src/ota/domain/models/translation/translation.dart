import 'package:lokalise_flutter_sdk/src/ota/domain/models/enums/translation_type.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/json_serializable.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/translation/plural_translation.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/translation/simple_translation.dart';

abstract class Translation implements JsonSerializable {
  final TranslationType type;

  Translation({required this.type});

  static Translation? fromJson({required Map<String, dynamic> json}) {
    if (!json.containsKey('type')) {
      return null;
    }

    final type = TranslationType.values.byName(json['type']);
    switch (type) {
      case TranslationType.simple:
        return SimpleTranslation.fromJson(json: json);
      case TranslationType.plural:
        return PluralTranslation.fromJson(json: json);
      default:
        return null;
    }
  }

  String? getTranslation({required Map<String, Object> args});
}
