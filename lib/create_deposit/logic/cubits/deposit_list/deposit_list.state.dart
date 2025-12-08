part of 'deposit_list.cubit.dart';

abstract class DepositListState {}

class DepositListInitial extends DepositListState {}

class DepositListLoading extends DepositListState {}

class DepositListSuccess extends DepositListState {
  final List<Deposit> deposits;
  DepositListSuccess(this.deposits);
}

class DepositListFailure extends DepositListState {
  final String message;
  DepositListFailure(this.message);
}

class DepositListEmpty extends DepositListState {}
