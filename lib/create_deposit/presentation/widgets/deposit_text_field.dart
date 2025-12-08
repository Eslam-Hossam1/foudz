import 'package:flutter/material.dart';
import 'package:fuodz/create_deposit/theme/deposit_theme_extension.dart';

class DepositTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String? hintText;
  final bool isRequired;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? icon;
  final int? maxLines;

  const DepositTextField({
    super.key,
    required this.label,
    this.controller,
    this.hintText,
    this.isRequired = false,
    this.validator,
    this.keyboardType,
    this.readOnly = false,
    this.onTap,
    this.icon,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.depositTheme;
    final primaryTextColor = context.depositPrimaryTextColor;
    final borderColor = context.depositBorderColor.withOpacity(0.5);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: primaryTextColor,
              ),
            ),
            if (isRequired)
              Text(
                " *",
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          readOnly: readOnly,
          onTap: onTap,
          maxLines: maxLines,
          style: theme.textTheme.bodyMedium?.copyWith(color: primaryTextColor),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: context.depositSecondaryTextColor,
            ),
            filled: true,
            fillColor: context.depositCardColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.primaryColor, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            suffixIcon: icon,
          ),
        ),
      ],
    );
  }
}
