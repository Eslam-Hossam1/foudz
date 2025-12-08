import 'package:flutter/material.dart';

import 'deposit_app_colors.dart';
import 'deposit_custom_colors.dart';

abstract class DepositAppThemes {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: DepositAppColors.lightScaffoldBackground,
    dialogBackgroundColor: DepositAppColors.lightDialogBackground,
    colorScheme: const ColorScheme.light(
      primary: DepositAppColors.lightPrimary,
      secondary: DepositAppColors.lightSecondary,
      onSurfaceVariant: DepositAppColors.lightOnSurfaceVariant,
      outline: DepositAppColors.lightOutline,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: DepositAppColors.lightAppBarBackground,
      foregroundColor: DepositAppColors.lightAppBarForeground,
      elevation: 0,
    ),
    cardColor: DepositAppColors.lightCardColor,
    shadowColor: DepositAppColors.lightShadowColor,
    dividerColor: DepositAppColors.lightOutline,
    extensions: const <ThemeExtension<dynamic>>[
      DepositCustomColors(
        primaryTextColor: DepositAppColors.lightMainTextColor,
        secondaryTextColor: DepositAppColors.lightSecondaryTextColor,
        cardColor: DepositAppColors.lightCardColor,
        borderColor: DepositAppColors.lightBorderColor,
        primaryButtonBackground: DepositAppColors.lightPrimaryButtonBackground,
        primaryButtonTextColor: DepositAppColors.lightPrimaryButtonTextColor,
        secondaryButtonBackground:
            DepositAppColors.lightSecondaryButtonBackground,
        secondaryButtonTextColor:
            DepositAppColors.lightSecondaryButtonTextColor,
        chipBackgroundColor: DepositAppColors.lightChipBackgroundColor,
        chipTextColor: DepositAppColors.lightChipTextColor,
        copyButtonBackground: DepositAppColors.lightCopyButtonBackground,
        copyButtonBorderColor: DepositAppColors.lightCopyButtonBorderColor,
        copyButtonTextColor: DepositAppColors.lightCopyButtonTextColor,
        appBarBackground: DepositAppColors.lightAppBarBackground,
        appBarForeground: DepositAppColors.lightAppBarForeground,
        shadowColor: DepositAppColors.lightShadowColor,
      ),
    ],
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: DepositAppColors.darkScaffoldBackground,
    dialogBackgroundColor: DepositAppColors.darkDialogBackground,
    colorScheme: const ColorScheme.dark(
      primary: DepositAppColors.darkPrimary,
      secondary: DepositAppColors.darkSecondary,
      onSurfaceVariant: DepositAppColors.darkOnSurfaceVariant,
      outline: DepositAppColors.darkOutline,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: DepositAppColors.darkAppBarBackground,
      foregroundColor: DepositAppColors.darkAppBarForeground,
      elevation: 0,
    ),
    cardColor: DepositAppColors.darkCardColor,
    shadowColor: DepositAppColors.darkShadowColor,
    dividerColor: DepositAppColors.darkOutline,
    extensions: const <ThemeExtension<dynamic>>[
      DepositCustomColors(
        primaryTextColor: DepositAppColors.darkMainTextColor,
        secondaryTextColor: DepositAppColors.darkSecondaryTextColor,
        cardColor: DepositAppColors.darkCardColor,
        borderColor: DepositAppColors.darkBorderColor,
        primaryButtonBackground: DepositAppColors.darkPrimaryButtonBackground,
        primaryButtonTextColor: DepositAppColors.darkPrimaryButtonTextColor,
        secondaryButtonBackground:
            DepositAppColors.darkSecondaryButtonBackground,
        secondaryButtonTextColor: DepositAppColors.darkSecondaryButtonTextColor,
        chipBackgroundColor: DepositAppColors.darkChipBackgroundColor,
        chipTextColor: DepositAppColors.darkChipTextColor,
        copyButtonBackground: DepositAppColors.darkCopyButtonBackground,
        copyButtonBorderColor: DepositAppColors.darkCopyButtonBorderColor,
        copyButtonTextColor: DepositAppColors.darkCopyButtonTextColor,
        appBarBackground: DepositAppColors.darkAppBarBackground,
        appBarForeground: DepositAppColors.darkAppBarForeground,
        shadowColor: DepositAppColors.darkShadowColor,
      ),
    ],
  );
}
