import 'package:localize_and_translate/localize_and_translate.dart';

class CurrencyOption {
  final String labelKey;
  final String code;
  const CurrencyOption({required this.labelKey, required this.code});

  String get displayName => "${labelKey.tr()} ($code)";
}

const List<CurrencyOption> depositCurrencies = [
  CurrencyOption(labelKey: "Syrian Pound", code: "SYP"),
  CurrencyOption(labelKey: "US Dollar", code: "USD"),
  CurrencyOption(labelKey: "Egyptian Pound", code: "EGP"),
  CurrencyOption(labelKey: "Saudi Riyal", code: "SAR"),
  CurrencyOption(labelKey: "UAE Dirham", code: "AED"),
];
