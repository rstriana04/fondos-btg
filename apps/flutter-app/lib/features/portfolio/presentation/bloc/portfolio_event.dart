import 'package:equatable/equatable.dart';

sealed class PortfolioEvent extends Equatable {
  const PortfolioEvent();

  @override
  List<Object?> get props => [];
}

final class LoadPortfolio extends PortfolioEvent {
  const LoadPortfolio();
}

final class CancelSubscriptionEvent extends PortfolioEvent {
  final int subscriptionId;

  const CancelSubscriptionEvent({required this.subscriptionId});

  @override
  List<Object?> get props => [subscriptionId];
}

final class ClearCancellationResult extends PortfolioEvent {
  const ClearCancellationResult();
}
