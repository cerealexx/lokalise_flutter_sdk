// ignore: implementation_imports
import 'package:intl/src/intl_helpers.dart';
import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/bundle.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/language_bundle.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/translation/translation.dart';

class MessageLookupProxy implements MessageLookup {
  final MessageLookup _messageLookup;
  Bundle _bundle;
  final List<Map<String, List<String>>>
      _argsNamesByKeyNameList; // should be a list to support the multi-delegate case

  MessageLookupProxy({
    required MessageLookup messageLookup,
    required Bundle bundle,
  })  : _messageLookup = (messageLookup is UninitializedLocaleData)
            ? CompositeMessageLookup()
            : messageLookup,
        _bundle = bundle,
        _argsNamesByKeyNameList = [];

  int get translationVersion => _bundle.translationVersion;

  set bundle(Bundle bundle) {
    _bundle = bundle;
  }

  void addArgNamesByKeyName(Map<String, List<String>> param) {
    // always inserting at the beginning, so last added has more priority
    _argsNamesByKeyNameList.insert(0, param);
  }

  @override
  void addLocale(String localeName, Function findLocale) {
    _messageLookup.addLocale(localeName, findLocale);
  }

  @override
  String? lookupMessage(
    String? messageText,
    String? locale,
    String? name,
    List<Object>? args,
    String? meaning, {
    MessageIfAbsent? ifAbsent,
  }) {
    final currentLocale = locale ?? Intl.getCurrentLocale();
    final translations = _bundle.languageBundles
        .firstWhere(
          (e) => e.locale.toLowerCase() == currentLocale.toLowerCase(),
          orElse: () => LanguageBundle(locale: currentLocale, translations: {}),
        )
        .translations;

    return _resolveMessage(translations, name, args) ??
        _messageLookup.lookupMessage(
          messageText,
          locale,
          name,
          args,
          meaning,
          ifAbsent: ifAbsent,
        );
  }

  String? _resolveMessage(Map<String, Translation> translations,
      String? keyName, List<Object>? argsValues) {
    if (!translations.containsKey(keyName)) {
      // If we don't have that translation just return null
      return null;
    }
    if (_argsNamesByKeyNameList.isEmpty && argsValues == null) {
      // if no args names and values it could be a simple translation so trying to get it
      return translations[keyName]?.getTranslation(args: {});
    }

    for (final argsNamesByKeyName in _argsNamesByKeyNameList) {
      final translationArgs = _mapArgs(argsNamesByKeyName[keyName], argsValues);
      if (translationArgs == null) {
        // if translation args is null -> try with next argsNamesByKeyName
        continue;
      }

      final message =
          translations[keyName]?.getTranslation(args: translationArgs);

      if (message != null) {
        // if we can't rebuild the the translation -> try with next argsNamesByKeyName
        return message;
      }
    }

    // if we arrive to this point is because we are not able to extract and build
    // the bundle translation so retuning null and leting caller to handle it
    return null;
  }

  Map<String, Object>? _mapArgs(
      List<String>? argsNames, List<Object>? argsValues) {
    // in metadata we have the names of the arguments for the translation
    // so here we are getting it using the keyName, note that in theory,
    // it can be null

    if (argsNames == null && argsValues == null) {
      // If both are nulls we consider it as empty,
      // which means no arguments for the translation
      return <String, Object>{};
    } else if (argsNames?.length == argsValues?.length) {
      // if both have the same length, it is also checking that both
      // are not null, we can build the result map {argName: argValue}
      return Map.fromIterables(argsNames!, argsValues!);
    }

    // if we arrive here means that there is something wrong with arguments
    // caller will handle this situation
    return null;
  }
}
