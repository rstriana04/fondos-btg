import 'package:dartz/dartz.dart';
import 'package:fondos_btg/core/error/exceptions.dart';
import 'package:fondos_btg/core/error/failures.dart';
import 'package:fondos_btg/features/balance/data/datasources/balance_remote_datasource.dart';
import 'package:fondos_btg/features/balance/domain/entities/balance_info.dart';
import 'package:fondos_btg/features/balance/domain/repositories/balance_repository.dart';

class BalanceRepositoryImpl implements BalanceRepository {
  final BalanceRemoteDatasource _remoteDatasource;

  const BalanceRepositoryImpl(this._remoteDatasource);

  @override
  Future<Either<Failure, BalanceInfo>> getBalance() async {
    try {
      final balanceInfo = await _remoteDatasource.getBalance();
      return Right(balanceInfo);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
