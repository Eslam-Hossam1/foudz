import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuodz/models/api_response.dart';
import 'package:fuodz/create_deposit/data/repositories/deposit.repository.dart';
import 'package:fuodz/create_deposit/data/models/deposit_request_models.dart';

part 'cash_deposit.state.dart';

class CashDepositCubit extends Cubit<CashDepositState> {
  final DepositRepository _repository;

  CashDepositCubit(this._repository) : super(CashDepositInitial());

  Future<void> submitDeposit({
    required String currency,
    required double amount,
  }) async {
    if (isClosed) return; // Check before emitting
    emit(CashDepositLoading());

    try {
      final request = CashDepositRequest(currency: currency, amount: amount);
      final response = await _repository.createDeposit(request);

      // Check before each emit
      if (isClosed) return;

      if (response.allGood) {
        emit(CashDepositSuccess(response));
      } else {
        emit(CashDepositFailure(response.message ?? "An error occurred"));
      }
    } catch (e) {
      // Check before emitting error state
      if (isClosed) return;
      emit(CashDepositFailure(e.toString()));
    }
  }
}
