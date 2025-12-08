import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuodz/models/api_response.dart';
import 'package:fuodz/create_deposit/data/repositories/deposit.repository.dart';
import 'package:fuodz/create_deposit/data/models/deposit_request_models.dart';

part 'sham_cash_deposit.state.dart';

class ShamCashDepositCubit extends Cubit<ShamCashDepositState> {
  final DepositRepository _repository;

  ShamCashDepositCubit(this._repository) : super(ShamCashDepositInitial());

  Future<void> submitDeposit({
    required double amount,
    String? photoPath,
  }) async {
    emit(ShamCashDepositLoading());
    try {
      final request = ShamCashDepositRequest(
        amount: amount,
        photoPath: photoPath,
      );
      final response = await _repository.createDeposit(request);
      if (response.allGood) {
        emit(ShamCashDepositSuccess(response));
      } else {
        emit(ShamCashDepositFailure(response.message ?? "An error occurred"));
      }
    } catch (e) {
      emit(ShamCashDepositFailure(e.toString()));
    }
  }
}
