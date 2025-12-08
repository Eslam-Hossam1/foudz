part of 'hewalla_deposit.cubit.dart';

abstract class HewallaDepositState {}

class HewallaDepositInitial extends HewallaDepositState {}

class HewallaDepositLoading extends HewallaDepositState {}

class HewallaDepositSuccess extends HewallaDepositState {
  final ApiResponse response;
  HewallaDepositSuccess(this.response);
}

class HewallaDepositFailure extends HewallaDepositState {
  final String message;
  HewallaDepositFailure(this.message);
}
