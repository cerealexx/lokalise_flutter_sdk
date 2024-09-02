import 'package:lokalise_flutter_sdk/src/ota/domain/models/enums/translation_element_type.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/json_serializable.dart';

class TranslationElement implements JsonSerializable {
  final TranslationElementType type;
  final String value;

  TranslationElement({required this.type, required this.value});

  TranslationElement.literal({required String value})
      : this(type: TranslationElementType.literal, value: value);

  TranslationElement.placeholder({required String value})
      : this(type: TranslationElementType.placeholder, value: value);

  factory TranslationElement.fromJson({required Map<String, dynamic> json}) =>
      TranslationElement(
        type: TranslationElementType.values.byName(json['type'] as String),
        value: json['value'] as String,
      );

  @override
  Map<String, dynamic> toJson() => {'type': type.name, 'value': value};
}
