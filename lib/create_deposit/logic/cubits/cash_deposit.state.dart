part of 'cash_deposit.cubit.dart';

abstract class CashDepositState {}

class CashDepositInitial extends CashDepositState {}

class CashDepositLoading extends CashDepositState {}

class CashDepositSuccess extends CashDepositState {
  final ApiResponse response;
  CashDepositSuccess(this.response);
}

class CashDepositFailure extends CashDepositState {
  final String message;
  CashDepositFailure(this.message);
}
