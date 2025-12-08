import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuodz/create_deposit/data/datasources/deposit.datasource.dart';
import 'package:fuodz/create_deposit/data/models/deposit.dart';
import 'package:fuodz/create_deposit/data/repositories/deposit.repository.dart';
import 'package:fuodz/create_deposit/logic/cubits/deposit_list/deposit_list.cubit.dart';
import 'package:fuodz/create_deposit/theme/deposit_app_themes.dart';
import 'package:fuodz/create_deposit/theme/deposit_theme_extension.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class DepositListPage extends StatelessWidget {
  const DepositListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.depositTheme;

    return BlocProvider(
      create:
          (context) => DepositListCubit(
            DepositRepositoryImpl(DepositRemoteDataSourceImpl()),
          )..getDeposits(),
      child: Scaffold(
        backgroundColor: context.depositScaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            "Deposit History".tr(),
            style: theme.textTheme.titleLarge?.copyWith(
              color: context.depositAppBarForeground,
            ),
          ),
          backgroundColor: context.depositAppBarBackground,
          iconTheme: IconThemeData(color: context.depositAppBarForeground),
        ),
        body: BlocBuilder<DepositListCubit, DepositListState>(
          builder: (context, state) {
            if (state is DepositListLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DepositListEmpty) {
              return Center(child: Text("No deposits found".tr()));
            } else if (state is DepositListFailure) {
              return Center(child: Text(state.message));
            } else if (state is DepositListSuccess) {
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.deposits.length,
                separatorBuilder:
                    (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final deposit = state.deposits[index];
                  return _DepositListTile(deposit: deposit);
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _DepositListTile extends StatelessWidget {
  final Deposit deposit;

  const _DepositListTile({required this.deposit});

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
      case 'successful':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    // We can assume context has the theme because DepositListPage wraps it.
    // However, if this widget was used elsewhere, we might want to check.
    // But for now, we use the extension methods directly or via context.depositTheme
    final theme = context.depositTheme;
    // We can also use context.depositCardColor, etc.

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.depositCardColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: context.depositShadowColor,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.account_balance_wallet,
              color: theme.primaryColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deposit.method.toUpperCase(),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: context.depositPrimaryTextColor,
                  ),
                ),
                if (deposit.createdAt != null)
                  Text(
                    DateFormat('MMM d, y hh:mm a').format(deposit.createdAt!),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: context.depositSecondaryTextColor,
                    ),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                deposit.displayAmount,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.depositPrimaryTextColor,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _getStatusColor(deposit.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  deposit.status.toUpperCase().tr(),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: _getStatusColor(deposit.status),
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
