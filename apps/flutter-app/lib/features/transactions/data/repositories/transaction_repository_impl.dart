import 'package:dartz/dartz.dart';
import 'package:fondos_btg/core/error/exceptions.dart';
import 'package:fondos_btg/core/error/failures.dart';
import 'package:fondos_btg/features/transactions/data/datasources/transaction_remote_datasource.dart';
import 'package:fondos_btg/features/transactions/domain/entities/transaction.dart';
import 'package:fondos_btg/features/transactions/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDatasource _remoteDatasource;

  const TransactionRepositoryImpl(this._remoteDatasource);

  @override
  Future<Either<Failure, List<FundTransaction>>> getTransactions() async {
    try {
      final dtos = await _remoteDatasource.getTransactions();
      final transactions = dtos.map((dto) => dto.toEntity()).toList();
      // Sort by most recent first
      transactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return Right(transactions);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
