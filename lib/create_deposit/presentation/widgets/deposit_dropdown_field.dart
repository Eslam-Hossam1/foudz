import 'package:flutter/material.dart';
import 'package:fuodz/create_deposit/theme/deposit_theme_extension.dart';

class DepositDropdownField<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?) onChanged;
  final String? Function(T?)? validator;
  final String? hintText;
  final bool isRequired;

  const DepositDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
    this.hintText,
    this.isRequired = false,
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
        DropdownButtonFormField<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          validator: validator,
          style: theme.textTheme.bodyMedium?.copyWith(color: primaryTextColor),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: context.depositSecondaryTextColor,
          ),
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
          ),
          dropdownColor: context.depositCardColor,
        ),
      ],
    );
  }
}
