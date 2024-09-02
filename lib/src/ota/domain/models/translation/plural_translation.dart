import 'package:intl/intl.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/enums/translation_type.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/translation/simple_translation.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/translation/translation.dart';

class PluralTranslation extends Translation {
  final String argument;

  final Translation? zero;
  final Translation? one;
  final Translation? two;
  final Translation? few;
  final Translation? many;
  final Translation other;

  PluralTranslation({
    required this.argument,
    required this.zero,
    required this.one,
    required this.two,
    required this.few,
    required this.many,
    required this.other,
  }) : super(type: TranslationType.plural);

  factory PluralTranslation.fromJson({required Map<String, dynamic> json}) {
    return PluralTranslation(
      argument: json['argument'] as String,
      other: Translation.fromJson(json: json['other']) ??
          SimpleTranslation(elements: []),
      zero: json['zero'] != null
          ? Translation.fromJson(json: json['zero'])
          : null,
      one: json['one'] != null ? Translation.fromJson(json: json['one']) : null,
      two: json['two'] != null ? Translation.fromJson(json: json['two']) : null,
      few: json['few'] != null ? Translation.fromJson(json: json['few']) : null,
      many: json['many'] != null
          ? Translation.fromJson(json: json['many'])
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': type.name,
        'argument': argument,
        'zero': zero?.toJson(),
        'one': one?.toJson(),
        'two': two?.toJson(),
        'few': few?.toJson(),
        'many': many?.toJson(),
        'other': other.toJson(),
      };

  @override
  String? getTranslation({required Map<String, Object> args}) {
    if (!args.containsKey(argument) || args[argument] is! num) {
      return null;
    }

    return Intl.plural(
      args[argument] as num,
      zero: zero?.getTranslation(args: args),
      one: one?.getTranslation(args: args),
      two: two?.getTranslation(args: args),
      few: few?.getTranslation(args: args),
      many: many?.getTranslation(args: args),
      other: other.getTranslation(args: args) ?? '',
    );
  }
}
