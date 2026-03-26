import 'package:dartz/dartz.dart';
import 'package:fondos_btg/core/error/failures.dart';
import 'package:fondos_btg/features/portfolio/domain/entities/subscription.dart';

abstract class PortfolioRepository {
  /// Returns all active subscriptions for the user.
  Future<Either<Failure, List<Subscription>>> getActiveSubscriptions();

  /// Cancels an active subscription.
  /// Returns the restored amount on success.
  Future<Either<Failure, double>> cancelSubscription({
    required int subscriptionId,
  });
}
