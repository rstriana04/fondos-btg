import 'package:dartz/dartz.dart';
import 'package:fondos_btg/core/error/failures.dart';
import 'package:fondos_btg/features/funds/domain/entities/fund.dart';
import 'package:fondos_btg/features/funds/domain/repositories/fund_repository.dart';

class GetFundsUseCase {
  final FundRepository _repository;

  const GetFundsUseCase(this._repository);

  Future<Either<Failure, List<Fund>>> call() {
    return _repository.getFunds();
  }
}
