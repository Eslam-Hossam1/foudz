import 'package:flutter/material.dart';

import 'deposit_custom_colors.dart';

extension DepositThemeExtension on BuildContext {
  ThemeData get depositTheme => Theme.of(this);
  DepositCustomColors get depositColors =>
      depositTheme.extension<DepositCustomColors>()!;
  ColorScheme get depositColorScheme => depositTheme.colorScheme;

  Color get depositPrimaryTextColor => depositColors.primaryTextColor;
  Color get depositSecondaryTextColor => depositColors.secondaryTextColor;
  Color get depositCardColor => depositColors.cardColor;
  Color get depositBorderColor => depositColors.borderColor;
  Color get depositPrimaryButtonBackground =>
      depositColors.primaryButtonBackground;
  Color get depositPrimaryButtonTextColor =>
      depositColors.primaryButtonTextColor;
  Color get depositSecondaryButtonBackground =>
      depositColors.secondaryButtonBackground;
  Color get depositSecondaryButtonTextColor =>
      depositColors.secondaryButtonTextColor;
  Color get depositChipBackgroundColor => depositColors.chipBackgroundColor;
  Color get depositChipTextColor => depositColors.chipTextColor;
  Color get depositCopyButtonBackground => depositColors.copyButtonBackground;
  Color get depositCopyButtonBorderColor => depositColors.copyButtonBorderColor;
  Color get depositCopyButtonTextColor => depositColors.copyButtonTextColor;
  Color get depositAppBarBackground => depositColors.appBarBackground;
  Color get depositAppBarForeground => depositColors.appBarForeground;
  Color get depositShadowColor => depositColors.shadowColor;
  Color get depositScaffoldBackgroundColor =>
      depositTheme.scaffoldBackgroundColor;
}
