import 'package:flutter/material.dart';

@immutable
class DepositCustomColors extends ThemeExtension<DepositCustomColors> {
  final Color primaryTextColor;
  final Color secondaryTextColor;
  final Color cardColor;
  final Color borderColor;
  final Color primaryButtonBackground;
  final Color primaryButtonTextColor;
  final Color secondaryButtonBackground;
  final Color secondaryButtonTextColor;
  final Color chipBackgroundColor;
  final Color chipTextColor;
  final Color copyButtonBackground;
  final Color copyButtonBorderColor;
  final Color copyButtonTextColor;
  final Color appBarBackground;
  final Color appBarForeground;
  final Color shadowColor;

  const DepositCustomColors({
    required this.primaryTextColor,
    required this.secondaryTextColor,
    required this.cardColor,
    required this.borderColor,
    required this.primaryButtonBackground,
    required this.primaryButtonTextColor,
    required this.secondaryButtonBackground,
    required this.secondaryButtonTextColor,
    required this.chipBackgroundColor,
    required this.chipTextColor,
    required this.copyButtonBackground,
    required this.copyButtonBorderColor,
    required this.copyButtonTextColor,
    required this.appBarBackground,
    required this.appBarForeground,
    required this.shadowColor,
  });

  @override
  DepositCustomColors copyWith({
    Color? primaryTextColor,
    Color? secondaryTextColor,
    Color? cardColor,
    Color? borderColor,
    Color? primaryButtonBackground,
    Color? primaryButtonTextColor,
    Color? secondaryButtonBackground,
    Color? secondaryButtonTextColor,
    Color? chipBackgroundColor,
    Color? chipTextColor,
    Color? copyButtonBackground,
    Color? copyButtonBorderColor,
    Color? copyButtonTextColor,
    Color? appBarBackground,
    Color? appBarForeground,
    Color? shadowColor,
  }) {
    return DepositCustomColors(
      primaryTextColor: primaryTextColor ?? this.primaryTextColor,
      secondaryTextColor: secondaryTextColor ?? this.secondaryTextColor,
      cardColor: cardColor ?? this.cardColor,
      borderColor: borderColor ?? this.borderColor,
      primaryButtonBackground:
          primaryButtonBackground ?? this.primaryButtonBackground,
      primaryButtonTextColor:
          primaryButtonTextColor ?? this.primaryButtonTextColor,
      secondaryButtonBackground:
          secondaryButtonBackground ?? this.secondaryButtonBackground,
      secondaryButtonTextColor:
          secondaryButtonTextColor ?? this.secondaryButtonTextColor,
      chipBackgroundColor: chipBackgroundColor ?? this.chipBackgroundColor,
      chipTextColor: chipTextColor ?? this.chipTextColor,
      copyButtonBackground: copyButtonBackground ?? this.copyButtonBackground,
      copyButtonBorderColor:
          copyButtonBorderColor ?? this.copyButtonBorderColor,
      copyButtonTextColor: copyButtonTextColor ?? this.copyButtonTextColor,
      appBarBackground: appBarBackground ?? this.appBarBackground,
      appBarForeground: appBarForeground ?? this.appBarForeground,
      shadowColor: shadowColor ?? this.shadowColor,
    );
  }

  @override
  DepositCustomColors lerp(
    ThemeExtension<DepositCustomColors>? other,
    double t,
  ) {
    if (other is! DepositCustomColors) {
      return this;
    }
    return DepositCustomColors(
      primaryTextColor:
          Color.lerp(primaryTextColor, other.primaryTextColor, t)!,
      secondaryTextColor:
          Color.lerp(secondaryTextColor, other.secondaryTextColor, t)!,
      cardColor: Color.lerp(cardColor, other.cardColor, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
      primaryButtonBackground:
          Color.lerp(
            primaryButtonBackground,
            other.primaryButtonBackground,
            t,
          )!,
      primaryButtonTextColor:
          Color.lerp(primaryButtonTextColor, other.primaryButtonTextColor, t)!,
      secondaryButtonBackground:
          Color.lerp(
            secondaryButtonBackground,
            other.secondaryButtonBackground,
            t,
          )!,
      secondaryButtonTextColor:
          Color.lerp(
            secondaryButtonTextColor,
            other.secondaryButtonTextColor,
            t,
          )!,
      chipBackgroundColor:
          Color.lerp(chipBackgroundColor, other.chipBackgroundColor, t)!,
      chipTextColor: Color.lerp(chipTextColor, other.chipTextColor, t)!,
      copyButtonBackground:
          Color.lerp(copyButtonBackground, other.copyButtonBackground, t)!,
      copyButtonBorderColor:
          Color.lerp(copyButtonBorderColor, other.copyButtonBorderColor, t)!,
      copyButtonTextColor:
          Color.lerp(copyButtonTextColor, other.copyButtonTextColor, t)!,
      appBarBackground:
          Color.lerp(appBarBackground, other.appBarBackground, t)!,
      appBarForeground:
          Color.lerp(appBarForeground, other.appBarForeground, t)!,
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t)!,
    );
  }
}
