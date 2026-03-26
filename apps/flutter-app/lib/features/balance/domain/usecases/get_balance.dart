import 'package:dartz/dartz.dart';
import 'package:fondos_btg/core/error/failures.dart';
import 'package:fondos_btg/features/balance/domain/entities/balance_info.dart';
import 'package:fondos_btg/features/balance/domain/repositories/balance_repository.dart';

class GetBalanceUseCase {
  final BalanceRepository _repository;

  const GetBalanceUseCase(this._repository);

  Future<Either<Failure, BalanceInfo>> call() {
    return _repository.getBalance();
  }
}
