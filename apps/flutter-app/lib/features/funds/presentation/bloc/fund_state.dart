import 'package:equatable/equatable.dart';
import 'package:fondos_btg/features/funds/domain/entities/fund.dart';

enum FundStatus { initial, loading, loaded, error }

enum SubscriptionStatus { idle, loading, success, error }

class FundState extends Equatable {
  final FundStatus status;
  final List<Fund> funds;
  final String? errorMessage;
  final SubscriptionStatus subscriptionStatus;
  final String? subscriptionError;
  final double? newBalance;

  const FundState({
    this.status = FundStatus.initial,
    this.funds = const [],
    this.errorMessage,
    this.subscriptionStatus = SubscriptionStatus.idle,
    this.subscriptionError,
    this.newBalance,
  });

  FundState copyWith({
    FundStatus? status,
    List<Fund>? funds,
    String? errorMessage,
    SubscriptionStatus? subscriptionStatus,
    String? subscriptionError,
    double? newBalance,
  }) {
    return FundState(
      status: status ?? this.status,
      funds: funds ?? this.funds,
      errorMessage: errorMessage ?? this.errorMessage,
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
      subscriptionError: subscriptionError,
      newBalance: newBalance,
    );
  }

  @override
  List<Object?> get props => [
        status,
        funds,
        errorMessage,
        subscriptionStatus,
        subscriptionError,
        newBalance,
      ];
}
