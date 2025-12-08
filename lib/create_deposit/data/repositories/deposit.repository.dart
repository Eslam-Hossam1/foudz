import 'package:fuodz/models/api_response.dart';
import 'package:fuodz/create_deposit/data/datasources/deposit.datasource.dart';
import 'package:fuodz/create_deposit/data/models/deposit_request_models.dart';

abstract class DepositRepository {
  Future<ApiResponse> createDeposit(DepositRequest request);
}

class DepositRepositoryImpl implements DepositRepository {
  final DepositRemoteDataSource remoteDataSource;

  DepositRepositoryImpl(this.remoteDataSource);

  @override
  Future<ApiResponse> createDeposit(DepositRequest request) async {
    return await remoteDataSource.createDeposit(request);
  }
}
