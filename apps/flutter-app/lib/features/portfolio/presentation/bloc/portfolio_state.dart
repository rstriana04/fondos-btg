import 'package:equatable/equatable.dart';
import 'package:fondos_btg/features/portfolio/domain/entities/subscription.dart';

enum PortfolioStatus { initial, loading, loaded, error }

enum CancellationStatus { idle, loading, success, error }

class PortfolioState extends Equatable {
  final PortfolioStatus status;
  final List<Subscription> subscriptions;
  final String? errorMessage;
  final CancellationStatus cancellationStatus;
  final String? cancellationError;
  final double? newBalance;

  const PortfolioState({
    this.status = PortfolioStatus.initial,
    this.subscriptions = const [],
    this.errorMessage,
    this.cancellationStatus = CancellationStatus.idle,
    this.cancellationError,
    this.newBalance,
  });

  double get totalInvested =>
      subscriptions.fold(0.0, (sum, s) => sum + s.amount);

  PortfolioState copyWith({
    PortfolioStatus? status,
    List<Subscription>? subscriptions,
    String? errorMessage,
    CancellationStatus? cancellationStatus,
    String? cancellationError,
    double? newBalance,
  }) {
    return PortfolioState(
      status: status ?? this.status,
      subscriptions: subscriptions ?? this.subscriptions,
      errorMessage: errorMessage ?? this.errorMessage,
      cancellationStatus: cancellationStatus ?? this.cancellationStatus,
      cancellationError: cancellationError,
      newBalance: newBalance,
    );
  }

  @override
  List<Object?> get props => [
        status,
        subscriptions,
        errorMessage,
        cancellationStatus,
        cancellationError,
        newBalance,
      ];
}
