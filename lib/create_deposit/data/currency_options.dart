class CurrencyOption {
  final String label;
  final String code;
  const CurrencyOption({required this.label, required this.code});

  String get displayName => "$label ($code)";
}

const List<CurrencyOption> depositCurrencies = [
  CurrencyOption(label: "ليرة سورية", code: "SYP"),
  CurrencyOption(label: "دولار أمريكي", code: "USD"),
  CurrencyOption(label: "جنيه مصري", code: "EGP"),
  CurrencyOption(label: "ريال سعودي", code: "SAR"),
  CurrencyOption(label: "درهم إماراتي", code: "AED"),
];
