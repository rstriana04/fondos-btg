import 'package:dartz/dartz.dart';
import 'package:fondos_btg/core/error/failures.dart';
import 'package:fondos_btg/features/transactions/domain/entities/transaction.dart';
import 'package:fondos_btg/features/transactions/domain/repositories/transaction_repository.dart';

class GetTransactionsUseCase {
  final TransactionRepository _repository;

  const GetTransactionsUseCase(this._repository);

  Future<Either<Failure, List<FundTransaction>>> call() {
    return _repository.getTransactions();
  }
}
