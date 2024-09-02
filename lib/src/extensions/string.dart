extension LocaleValidation on String {
  /// Check if the string is a valid locale
  /// in whatever format
  /// Regex meaning:
  ///   ^                 match beginning of string
  ///   [A-Za-z]{2,4}     match between 2 and 4 characters in the set
  ///   (
  ///     [_][A-Za-z]{4}  match '_' followed by 4 characters in the set
  ///   )?                matches the previous token between zero and one times
  ///   (
  ///     [_](            match '_' followed by
  ///       [A-Za-z]{2}   2 characters in the set
  ///       |             or
  ///       [0-9]{3}      3 characters in the set
  ///     )
  ///   )?                matches the previous token between zero and one times
  ///   $                 match end of the string
  ///
  /// Reference -> https://stackoverflow.com/a/48300605
  /// Note      -> Flutter uses '_' and not '-' for locales
  bool get isLocale => RegExp(
        r'^[A-Za-z]{2,4}([_][A-Za-z]{4})?([_]([A-Za-z]{2}|[0-9]{3}))?$',
      ).hasMatch(this);

  /// check if the string is a locale with the format: {lang}_{script}_{country}
  /// Regex meaning -> extracted from isLocale, check description above
  bool get isLangScriptCountryLocale => RegExp(
        r'^[A-Za-z]{2,4}_[A-Za-z]{4}_([A-Za-z]{2}|[0-9]{3})$',
      ).hasMatch(this);

  /// check if the string is a locale with the format: {lang}_{script}
  /// Regex meaning -> extracted from isLocale, check description above
  bool get isLangScriptLocale => RegExp(
        r'^[A-Za-z]{2,4}_[A-Za-z]{4}$',
      ).hasMatch(this);

  /// check if the string is a locale with the format: {lang}_{country}
  /// Regex meaning -> extracted from isLocale, check description above
  bool get isLangCountryLocale => RegExp(
        r'^[A-Za-z]{2,4}_([A-Za-z]{2}|[0-9]{3})$',
      ).hasMatch(this);

  /// check if the string is a locale with the format: {lang}
  /// Regex meaning -> extracted from isLocale, check description above
  bool get isLangLocale => RegExp(
        r'^[A-Za-z]{2,4}$',
      ).hasMatch(this);
}

extension ClassValidation on String {
  /// Checks if the string is a valid class name
  /// Regex meaning:
  ///   ^               match beginning of string
  ///   [a-zA-Z]        match a letter for the first char
  ///   (?:             start non-capture group
  ///     _?            match 0 or 1 '_'
  ///     [a-zA-Z0-9]+  match a letter or number, 1 or more times
  ///   )*              end non-capture group, match whole group 0 or more times
  ///   $               match end of the string
  bool get isValidClassName =>
      RegExp(r'^[a-zA-Z](?:_?[a-zA-Z0-9]+)*$').hasMatch(this);
}
