import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuodz/models/api_response.dart';
import 'package:fuodz/create_deposit/data/repositories/deposit.repository.dart';
import 'package:fuodz/create_deposit/data/models/deposit_request_models.dart';

part 'usdt_deposit.state.dart';

class UsdtDepositCubit extends Cubit<UsdtDepositState> {
  final DepositRepository _repository;

  UsdtDepositCubit(this._repository) : super(UsdtDepositInitial());

  Future<void> submitDeposit({
    required double netAmount,
    required String txHash,
  }) async {
    if (isClosed) return; // Check before emitting
    emit(UsdtDepositLoading());

    try {
      final request = UsdtDepositRequest(netAmount: netAmount, txHash: txHash);
      final response = await _repository.createDeposit(request);

      // Check before each emit
      if (isClosed) return;

      if (response.allGood) {
        emit(UsdtDepositSuccess(response));
      } else {
        emit(UsdtDepositFailure(response.message ?? "An error occurred"));
      }
    } catch (e) {
      // Check before emitting error state
      if (isClosed) return;
      emit(UsdtDepositFailure(e.toString()));
    }
  }
}
