import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuodz/models/api_response.dart';
import 'package:fuodz/create_deposit/data/repositories/deposit.repository.dart';
import 'package:fuodz/create_deposit/data/models/deposit_request_models.dart';

part 'hewalla_deposit.state.dart';

class HewallaDepositCubit extends Cubit<HewallaDepositState> {
  final DepositRepository _repository;

  HewallaDepositCubit(this._repository) : super(HewallaDepositInitial());

  Future<void> submitDeposit({
    required double amount,
    String? photoPath,
    required String currency,
  }) async {
    if (isClosed) return; // Check before emitting
    emit(HewallaDepositLoading());
    
    try {
      final request = HewallaDepositRequest(
        amount: amount,
        photoPath: photoPath,
        currency: currency,
      );
      final response = await _repository.createDeposit(request);
      
      // Check before each emit
      if (isClosed) return;
      
      if (response.allGood) {
        emit(HewallaDepositSuccess(response));
      } else {
        emit(HewallaDepositFailure(response.message ?? "An error occurred"));
      }
    } catch (e) {
      // Check before emitting error state
      if (isClosed) return;
      emit(HewallaDepositFailure(e.toString()));
    }
  }
}