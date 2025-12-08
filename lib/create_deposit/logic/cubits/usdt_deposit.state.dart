part of 'usdt_deposit.cubit.dart';

abstract class UsdtDepositState {}

class UsdtDepositInitial extends UsdtDepositState {}

class UsdtDepositLoading extends UsdtDepositState {}

class UsdtDepositSuccess extends UsdtDepositState {
  final ApiResponse response;
  UsdtDepositSuccess(this.response);
}

class UsdtDepositFailure extends UsdtDepositState {
  final String message;
  UsdtDepositFailure(this.message);
}
