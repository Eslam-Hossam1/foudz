import 'package:currency_formatter/currency_formatter.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:supercharged/supercharged.dart';

extension NumberParsing on dynamic {
  //
  String currencyFormat([String? currencySymbol]) {
    final uiConfig = AppStrings.uiConfig;
    if (uiConfig != null && uiConfig["currency"] != null) {
      final thousandSeparator = uiConfig["currency"]["format"] ?? ",";
      final decimalSeparator = uiConfig["currency"]["decimal_format"] ?? ".";
      final decimals = uiConfig["currency"]["decimals"];
      final currencylOCATION = uiConfig["currency"]["location"] ?? 'left';
      final decimalsValue = "".padLeft(decimals.toString().toInt()!, "0");

      final symbol = currencySymbol ?? AppStrings.currencySymbol;

      // Remove currency symbol and spaces
      String cleanValue = this.toString();

      // Remove known currency symbols
      cleanValue = cleanValue.replaceAll(symbol, '').replaceAll(' ', '').trim();

      // Remove any remaining non-numeric characters except dots and commas
      cleanValue = cleanValue.replaceAll(RegExp(r'[^0-9.,]'), '');

      // Normalize decimal separator to dot for parsing
      if (decimalSeparator == ",") {
        // If decimal is comma, replace it with dot for parsing
        cleanValue = cleanValue.replaceAll(',', '.');
      } else {
        // If decimal is dot, remove commas (thousand separators)
        cleanValue = cleanValue.replaceAll(',', '');
      }

      // Handle empty or invalid values
      if (cleanValue.isEmpty || double.tryParse(cleanValue) == null) {
        cleanValue = "0";
      }

      CurrencyFormat currencySettings = CurrencyFormat(
        symbol: symbol,
        symbolSide:
            currencylOCATION.toLowerCase() == "left"
                ? SymbolSide.left
                : SymbolSide.right,
        thousandSeparator: thousandSeparator,
        decimalSeparator: decimalSeparator,
      );

      return CurrencyFormatter.format(
        cleanValue,
        currencySettings,
        decimal: decimalsValue.length,
        enforceDecimals: true,
      );
    } else {
      return this.toString();
    }
  }

  String currencyValueFormat() {
    final uiConfig = AppStrings.uiConfig;
    if (uiConfig != null && uiConfig["currency"] != null) {
      final thousandSeparator = uiConfig["currency"]["format"] ?? ",";
      final decimalSeparator = uiConfig["currency"]["decimal_format"] ?? ".";
      final decimals = uiConfig["currency"]["decimals"];
      final decimalsValue = "".padLeft(decimals.toString().toInt()!, "0");
      final values = this.toString().split(" ").join("");

      //
      CurrencyFormat currencySettings = CurrencyFormat(
        symbol: "",
        symbolSide: SymbolSide.right,
        thousandSeparator: thousandSeparator,
        decimalSeparator: decimalSeparator,
      );
      return CurrencyFormatter.format(
        values,
        currencySettings,
        decimal: decimalsValue.length,
        enforceDecimals: true,
      );
    } else {
      return this.toString();
    }
  }

  bool get isNotDefaultImage {
    return !this.toString().contains("default");
  }

  String maskString({int start = 3, int? end, String mask = "*"}) {
    final String value = this.toString();
    // make sure start and end are within the string length
    if (start < 0) {
      start = 0;
    }

    int endPoint = end ?? value.length;
    if (endPoint > value.length) {
      endPoint = value.length;
    }

    // get the front and end of the string
    final String frontString = start == 0 ? "" : value.substring(0, start);
    final String endString = value.substring(endPoint);
    final String maskedString = "$mask".padLeft(
      value.substring(start, endPoint).length,
      "$mask",
    );
    return "$frontString$maskedString$endString";
  }
}
