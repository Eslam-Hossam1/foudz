import 'package:flutter/material.dart';
import 'package:fuodz/create_deposit/presentation/pages/cash_deposit_page.dart';
import 'package:fuodz/create_deposit/presentation/pages/hewalla_deposit_page.dart';
import 'package:fuodz/create_deposit/presentation/pages/sham_cash_deposit_page.dart';
import 'package:fuodz/create_deposit/presentation/pages/usdt_deposit_page.dart';
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
        break;
      case DepositMethod.usdt:
        page = const UsdtDepositPage();
        break;
      case DepositMethod.hewalla:
        page = const HewallaDepositPage();
        break;
      case DepositMethod.shamCash:
        page = const ShamCashDepositPage();
        break;
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final method = DepositMethod.values[index];
        return Card(
          child: ListTile(
            title: Text(method.label.tr(), style: theme.textTheme.titleMedium),
            subtitle: Text(method.description.tr()),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _openMethod(context, method),
          ),
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemCount: DepositMethod.values.length,
    );
  }
}
