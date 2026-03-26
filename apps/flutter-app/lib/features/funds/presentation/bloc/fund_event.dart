import 'package:equatable/equatable.dart';
import 'package:fondos_btg/features/funds/domain/entities/fund.dart';

sealed class FundEvent extends Equatable {
  const FundEvent();

  @override
  List<Object?> get props => [];
}

final class LoadFunds extends FundEvent {
  const LoadFunds();
}

final class SubscribeToFund extends FundEvent {
  final Fund fund;
  final double currentBalance;
  final String notificationMethod;

  const SubscribeToFund({
    required this.fund,
    required this.currentBalance,
    required this.notificationMethod,
  });

  @override
  List<Object?> get props => [fund, currentBalance, notificationMethod];
}

final class ClearSubscriptionResult extends FundEvent {
  const ClearSubscriptionResult();
}
