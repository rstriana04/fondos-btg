import 'package:dartz/dartz.dart';
import 'package:fondos_btg/core/error/exceptions.dart';
import 'package:fondos_btg/core/error/failures.dart';
import 'package:fondos_btg/features/funds/data/datasources/fund_remote_datasource.dart';
import 'package:fondos_btg/features/funds/domain/entities/fund.dart';
import 'package:fondos_btg/features/funds/domain/repositories/fund_repository.dart';

class FundRepositoryImpl implements FundRepository {
  final FundRemoteDatasource _remoteDatasource;

  const FundRepositoryImpl(this._remoteDatasource);

  @override
  Future<Either<Failure, List<Fund>>> getFunds() async {
    try {
      final dtos = await _remoteDatasource.getFunds();
      final funds = dtos.map((dto) => dto.toEntity()).toList();
      return Right(funds);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> subscribeToFund({
    required int fundId,
    required double amount,
    required String notificationMethod,
  }) async {
    try {
      final newBalance = await _remoteDatasource.subscribeToFund(
        fundId: fundId,
        amount: amount,
        notificationMethod: notificationMethod,
      );
      return Right(newBalance);
    } on BadRequestException catch (e) {
      if (e.message.contains('already subscribed') ||
          e.message.contains('ya vinculado')) {
        return Left(AlreadySubscribedFailure(e.message));
      }
      if (e.message.contains('insufficient') ||
          e.message.contains('saldo')) {
        return Left(InsufficientBalanceFailure(e.message));
      }
      return Left(ServerFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
