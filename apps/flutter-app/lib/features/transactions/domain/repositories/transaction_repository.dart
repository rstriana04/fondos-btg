import 'package:dartz/dartz.dart';
import 'package:fondos_btg/core/error/failures.dart';
import 'package:fondos_btg/features/transactions/domain/entities/transaction.dart';

abstract class TransactionRepository {
  /// Returns all transactions for the user, sorted by most recent first.
  Future<Either<Failure, List<FundTransaction>>> getTransactions();
}
