import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuodz/create_deposit/data/datasources/deposit.datasource.dart';
import 'package:fuodz/create_deposit/data/models/deposit.dart';
import 'package:fuodz/create_deposit/data/repositories/deposit.repository.dart';
import 'package:fuodz/create_deposit/logic/cubits/deposit_list/deposit_list.cubit.dart';
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
        return const Color(0xFF2ECC71);
      case 'pending':
        return const Color(0xFFF1C40F);
      case 'rejected':
      case 'failed':
        return const Color(0xFFE74C3C);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.depositTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.depositCardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: context.depositBorderColor.withOpacity(0.25),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: context.depositShadowColor,
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // ICON BOX
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.primaryColor.withOpacity(0.15),
                  theme.primaryColor.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.account_balance_wallet,
              size: 26,
              color: theme.primaryColor,
            ),
          ),

          const SizedBox(width: 14),

          // TITLE + DATE
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deposit.method.toUpperCase(),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                    color: context.depositPrimaryTextColor,
                  ),
                ),
                if (deposit.createdAt != null)
                  Text(
                    DateFormat('MMM d, y • hh:mm a').format(deposit.createdAt!),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: context.depositSecondaryTextColor,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // AMOUNT + STATUS
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                deposit.displayAmount,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: context.depositPrimaryTextColor,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(deposit.status).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  deposit.status.tr(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(deposit.status),
                    fontSize: 11,
                    letterSpacing: 0.3,
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
