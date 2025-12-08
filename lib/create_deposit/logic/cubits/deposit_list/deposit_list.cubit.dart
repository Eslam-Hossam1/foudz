import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuodz/create_deposit/data/models/deposit.dart';
import 'package:fuodz/create_deposit/data/repositories/deposit.repository.dart';

part 'deposit_list.state.dart';

class DepositListCubit extends Cubit<DepositListState> {
  final DepositRepository _repository;

  DepositListCubit(this._repository) : super(DepositListInitial());

  Future<void> getDeposits() async {
    emit(DepositListLoading());
    try {
      final deposits = await _repository.getDeposits();
      if (deposits.isEmpty) {
        emit(DepositListEmpty());
      } else {
        emit(DepositListSuccess(deposits));
      }
    } catch (e) {
      emit(DepositListFailure(e.toString()));
    }
  }
}
