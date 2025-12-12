import 'package:flutter/material.dart';
import 'package:fuodz/create_deposit/presentation/pages/cash_deposit_page.dart';
import 'package:fuodz/create_deposit/presentation/pages/deposit_instructions_page.dart';
import 'package:fuodz/create_deposit/presentation/pages/hewalla_deposit_page.dart';
import 'package:fuodz/create_deposit/presentation/pages/sham_cash_deposit_page.dart';
import 'package:fuodz/create_deposit/presentation/pages/usdt_deposit_page.dart';
import 'package:fuodz/create_deposit/theme/deposit_app_themes.dart';
import 'package:fuodz/create_deposit/theme/deposit_theme_extension.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

enum DepositMethod {
  cash(label: "Cash", description: "Pay in cash at our office/agent"),
  usdt(
    label: "USDT",
    description:
        "Send USDT to the address, then enter the net amount and transaction hash",
  ),
  hewalla(
    label: "Transfer",
    description:
        "Make a bank transfer to the provided account and upload the receipt",
  ),
  shamCash(
    label: "Sham Cash",
    description:
        "Send via Sham Cash to the provided number and upload a screenshot",
  );

  const DepositMethod({required this.label, required this.description});

  final String label;
  final String description;
}

class ChooseMethodPageBody extends StatelessWidget {
  const ChooseMethodPageBody({super.key});

  void _openMethod(BuildContext context, DepositMethod method) {
    Widget page;
    switch (method) {
      case DepositMethod.cash:
        page = const CashDepositPage();
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
        break;
      case DepositMethod.usdt:
        // Show instructions page first for USDT
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (_) => DepositInstructionsPage(
                  methodName: "USDT - TRON (TRC20)",
                  walletAddress: 'TUUDPUD7pNGjGmVi7hPAWJsJm5AfQCrZHb',
                  onConfirm: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const UsdtDepositPage(),
                      ),
                    );
                  },
                ),
          ),
        );
        break;
      case DepositMethod.hewalla:
        page = const HewallaDepositPage();
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
        break;
      case DepositMethod.shamCash:
        // Show instructions page first for Sham Cash
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (_) => DepositInstructionsPage(
                  methodName: method.label.tr(),
                  walletAddress: 'b960e9f054db2bc25b4aa609660cc30b',
                  onConfirm: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const ShamCashDepositPage(),
                      ),
                    );
                  },
                ),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.depositTheme;

    // Wrap with Theme so it works inside standard BottomSheet or Page
    return Container(
      color: context.depositScaffoldBackgroundColor,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final method = DepositMethod.values[index];
          return Container(
            decoration: BoxDecoration(
              color: context.depositCardColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: context.depositBorderColor.withOpacity(0.6),
              ),
              boxShadow: [
                BoxShadow(
                  color: context.depositShadowColor,
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              title: Text(
                method.label.tr(),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.depositPrimaryTextColor,
                ),
              ),
              subtitle: Text(
                method.description.tr(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: context.depositSecondaryTextColor,
                ),
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: context.depositSecondaryTextColor,
              ),
              onTap: () => _openMethod(context, method),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemCount: DepositMethod.values.length,
      ),
    );
  }
}
