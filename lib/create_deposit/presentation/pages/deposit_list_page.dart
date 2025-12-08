import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuodz/create_deposit/data/datasources/deposit.datasource.dart';
import 'package:fuodz/create_deposit/data/repositories/deposit.repository.dart';
import 'package:fuodz/create_deposit/logic/cubits/deposit_list/deposit_list.cubit.dart';
import 'package:fuodz/create_deposit/data/models/deposit.dart';
import 'package:intl/intl.dart';

class DepositListPage extends StatelessWidget {
  const DepositListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => DepositListCubit(
            DepositRepositoryImpl(DepositRemoteDataSourceImpl()),
          )..getDeposits(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Deposit History")),
        body: BlocBuilder<DepositListCubit, DepositListState>(
          builder: (context, state) {
            if (state is DepositListLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DepositListEmpty) {
              return const Center(child: Text("No deposits found"));
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
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
                  style: theme.textTheme.titleMedium,
                ),
                if (deposit.createdAt != null)
                  Text(
                    DateFormat('MMM d, y hh:mm a').format(deposit.createdAt!),
                    style: theme.textTheme.bodySmall,
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
                  deposit.status.toUpperCase(),
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
