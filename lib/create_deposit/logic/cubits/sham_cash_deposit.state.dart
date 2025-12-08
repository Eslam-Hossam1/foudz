part of 'sham_cash_deposit.cubit.dart';

abstract class ShamCashDepositState {}

class ShamCashDepositInitial extends ShamCashDepositState {}

class ShamCashDepositLoading extends ShamCashDepositState {}

class ShamCashDepositSuccess extends ShamCashDepositState {
  final ApiResponse response;
  ShamCashDepositSuccess(this.response);
}

class ShamCashDepositFailure extends ShamCashDepositState {
  final String message;
  ShamCashDepositFailure(this.message);
}
