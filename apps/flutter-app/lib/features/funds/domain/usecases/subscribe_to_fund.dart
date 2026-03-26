import 'package:dartz/dartz.dart';
import 'package:fondos_btg/core/error/failures.dart';
import 'package:fondos_btg/features/funds/domain/entities/fund.dart';
import 'package:fondos_btg/features/funds/domain/repositories/fund_repository.dart';
import 'package:fondos_btg/features/portfolio/domain/repositories/portfolio_repository.dart';

class SubscribeToFundUseCase {
  final FundRepository _fundRepository;
  final PortfolioRepository _portfolioRepository;

  const SubscribeToFundUseCase(
    this._fundRepository,
    this._portfolioRepository,
  );

  Future<Either<Failure, double>> call({
    required Fund fund,
    required double amount,
    required double currentBalance,
    required String notificationMethod,
  }) async {
    // Validate amount meets minimum
    if (amount < fund.minAmount) {
      return const Left(BelowMinimumAmountFailure());
    }

    // Validate sufficient balance
    if (currentBalance < amount) {
      return const Left(InsufficientBalanceFailure());
    }

    // Check if already subscribed
    final subscriptionsResult =
        await _portfolioRepository.getActiveSubscriptions();
    final isAlreadySubscribed = subscriptionsResult.fold(
      (_) => false,
      (subscriptions) => subscriptions.any((s) => s.fundId == fund.id),
    );

    if (isAlreadySubscribed) {
      return const Left(AlreadySubscribedFailure());
    }

    // Proceed with subscription
    return _fundRepository.subscribeToFund(
      fundId: fund.id,
      amount: amount,
      notificationMethod: notificationMethod,
    );
  }
}
