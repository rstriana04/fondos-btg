import 'package:dartz/dartz.dart';
import 'package:fondos_btg/core/error/exceptions.dart';
import 'package:fondos_btg/core/error/failures.dart';
import 'package:fondos_btg/features/portfolio/data/datasources/portfolio_remote_datasource.dart';
import 'package:fondos_btg/features/portfolio/domain/entities/subscription.dart';
import 'package:fondos_btg/features/portfolio/domain/repositories/portfolio_repository.dart';

class PortfolioRepositoryImpl implements PortfolioRepository {
  final PortfolioRemoteDatasource _remoteDatasource;

  const PortfolioRepositoryImpl(this._remoteDatasource);

  @override
  Future<Either<Failure, List<Subscription>>> getActiveSubscriptions() async {
    try {
      final dtos = await _remoteDatasource.getActiveSubscriptions();
      final subscriptions = dtos.map((dto) => dto.toEntity()).toList();
      return Right(subscriptions);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> cancelSubscription({
    required int subscriptionId,
  }) async {
    try {
      final newBalance = await _remoteDatasource.cancelSubscription(
        subscriptionId: subscriptionId,
      );
      return Right(newBalance);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
