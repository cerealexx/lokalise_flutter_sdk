import 'package:lokalise_flutter_sdk/src/ota/domain/models/enums/translation_element_type.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/enums/translation_type.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/translation/translation.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/translation/translation_element.dart';

class SimpleTranslation extends Translation {
  final List<TranslationElement> elements;

  SimpleTranslation({
    required this.elements,
  }) : super(type: TranslationType.simple);

  factory SimpleTranslation.fromJson({required Map<String, dynamic> json}) =>
      SimpleTranslation(
        elements: (json['elements'] as List)
            .map((e) => TranslationElement.fromJson(json: e))
            .toList(),
      );

  @override
  Map<String, dynamic> toJson() => {
        'type': type.name,
        'elements': elements.map((e) => e.toJson()).toList(),
      };

  @override
  String? getTranslation({required Map<String, Object> args}) {
    if (elements.isEmpty) {
      return null;
    }

    final textElements = elements.map((e) {
      switch (e.type) {
        case TranslationElementType.literal:
          return e.value;
        case TranslationElementType.placeholder:
          return args[e.value];
        default:
          return null;
      }
    });

    return textElements.every((e) => e != null) ? textElements.join() : null;
  }
}
