import 'package:dartz/dartz.dart';
import 'package:fondos_btg/core/error/failures.dart';
import 'package:fondos_btg/features/portfolio/domain/entities/subscription.dart';
import 'package:fondos_btg/features/portfolio/domain/repositories/portfolio_repository.dart';

class GetActiveSubscriptionsUseCase {
  final PortfolioRepository _repository;

  const GetActiveSubscriptionsUseCase(this._repository);

  Future<Either<Failure, List<Subscription>>> call() {
    return _repository.getActiveSubscriptions();
  }
}
