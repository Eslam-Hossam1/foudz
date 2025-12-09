import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuodz/create_deposit/data/models/deposit.dart';
import 'package:fuodz/create_deposit/data/repositories/deposit.repository.dart';

part 'deposit_list.state.dart';

class DepositListCubit extends Cubit<DepositListState> {
  final DepositRepository _repository;

  DepositListCubit(this._repository) : super(DepositListInitial());

  Future<void> getDeposits() async {
    if (isClosed) return; // Check before emitting
    emit(DepositListLoading());

    try {
      final deposits = await _repository.getDeposits();

      // Check before each emit
      if (isClosed) return;

      if (deposits.isEmpty) {
        emit(DepositListEmpty());
      } else {
        emit(DepositListSuccess(deposits));
      }
    } catch (e) {
      // Check before emitting error state
      if (isClosed) return;
      emit(DepositListFailure(e.toString()));
    }
  }
}
