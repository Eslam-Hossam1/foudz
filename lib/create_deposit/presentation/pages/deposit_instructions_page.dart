import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fuodz/create_deposit/theme/deposit_theme_extension.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class DepositInstructionsPage extends StatelessWidget {
  final String methodName;
  final String walletAddress;
  final VoidCallback onConfirm;

  const DepositInstructionsPage({
    super.key,
    required this.methodName,
    required this.walletAddress,
    required this.onConfirm,
  });

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: walletAddress));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Copied to clipboard".tr()),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.depositTheme;

    return Scaffold(
      backgroundColor: context.depositScaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Deposit Instructions".tr(),
          style: theme.textTheme.titleLarge?.copyWith(
            color: context.depositAppBarForeground,
          ),
        ),
        backgroundColor: context.depositAppBarBackground,
        iconTheme: IconThemeData(color: context.depositAppBarForeground),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Text(
                "Deposit Instructions".tr(),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: context.depositPrimaryTextColor,
                ),
              ),
              const SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  text: "${"You have selected".tr()} ",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 18,
                    color: context.depositSecondaryTextColor,
                  ),
                  children: [
                    TextSpan(
                      text: methodName,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: context.depositPrimaryTextColor,
                      ),
                    ),
                    TextSpan(
                      text: ".",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 18,
                        color: context.depositSecondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "Please send the desired amount to the wallet address below, then click \"I Have Transferred\"."
                    .tr(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 16,
                  color: context.depositPrimaryTextColor,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsetsDirectional.only(start: 16),
                height: 65,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: context.depositBorderColor,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 7,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          walletAddress,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 14,
                            fontFamily: 'monospace',
                            color: context.depositPrimaryTextColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: context.depositCopyButtonBorderColor,
                            width: 1,
                          ),
                          borderRadius: const BorderRadiusDirectional.only(
                            topEnd: Radius.circular(8),
                            bottomEnd: Radius.circular(8),
                          ),
                        ),
                        child: InkWell(
                          onTap: () => _copyToClipboard(context),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Copy".tr(),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 14,
                                color: context.depositCopyButtonTextColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "Make sure to double-check the address and network before sending. Transactions cannot be reversed."
                    .tr(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 15,
                  color: context.depositSecondaryTextColor,
                ),
              ),
              const Spacer(),
              CustomButton(
                title: "Cancel".tr(),
                color: context.depositSecondaryButtonBackground,
                titleStyle: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 16,
                  color: context.depositSecondaryButtonTextColor,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(height: 12),
              CustomButton(
                title: "I Have Transferred".tr(),
                titleStyle: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 16,
                  color: context.depositPrimaryButtonTextColor,
                ),
                onPressed: onConfirm,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
