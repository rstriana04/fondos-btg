import 'package:dartz/dartz.dart';
import 'package:fondos_btg/core/error/failures.dart';
import 'package:fondos_btg/features/portfolio/domain/repositories/portfolio_repository.dart';

class CancelSubscriptionUseCase {
  final PortfolioRepository _repository;

  const CancelSubscriptionUseCase(this._repository);

  Future<Either<Failure, double>> call({required int subscriptionId}) {
    return _repository.cancelSubscription(subscriptionId: subscriptionId);
  }
}
