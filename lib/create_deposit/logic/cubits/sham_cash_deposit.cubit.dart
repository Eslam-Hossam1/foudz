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
    required String currency,
  }) async {
    if (isClosed) return; // Check before emitting
    emit(ShamCashDepositLoading());

    try {
      final request = ShamCashDepositRequest(
        amount: amount,
        photoPath: photoPath,
        currency: currency,
      );
      final response = await _repository.createDeposit(request);

      // Check before each emit
      if (isClosed) return;

      if (response.allGood) {
        emit(ShamCashDepositSuccess(response));
      } else {
        emit(ShamCashDepositFailure(response.message ?? "An error occurred"));
      }
    } catch (e) {
      // Check before emitting error state
      if (isClosed) return;
      emit(ShamCashDepositFailure(e.toString()));
    }
  }
}
