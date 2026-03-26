import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fondos_btg/features/portfolio/domain/usecases/cancel_subscription.dart';
import 'package:fondos_btg/features/portfolio/domain/usecases/get_active_subscriptions.dart';
import 'package:fondos_btg/features/portfolio/presentation/bloc/portfolio_event.dart';
import 'package:fondos_btg/features/portfolio/presentation/bloc/portfolio_state.dart';

class PortfolioBloc extends Bloc<PortfolioEvent, PortfolioState> {
  final GetActiveSubscriptionsUseCase _getActiveSubscriptions;
  final CancelSubscriptionUseCase _cancelSubscription;

  PortfolioBloc({
    required GetActiveSubscriptionsUseCase getActiveSubscriptions,
    required CancelSubscriptionUseCase cancelSubscription,
  })  : _getActiveSubscriptions = getActiveSubscriptions,
        _cancelSubscription = cancelSubscription,
        super(const PortfolioState()) {
    on<LoadPortfolio>(_onLoadPortfolio);
    on<CancelSubscriptionEvent>(_onCancelSubscription);
    on<ClearCancellationResult>(_onClearCancellationResult);
  }

  Future<void> _onLoadPortfolio(
    LoadPortfolio event,
    Emitter<PortfolioState> emit,
  ) async {
    emit(state.copyWith(status: PortfolioStatus.loading));

    final result = await _getActiveSubscriptions();
    result.fold(
      (failure) => emit(state.copyWith(
        status: PortfolioStatus.error,
        errorMessage: failure.message,
      )),
      (subscriptions) => emit(state.copyWith(
        status: PortfolioStatus.loaded,
        subscriptions: subscriptions,
      )),
    );
  }

  Future<void> _onCancelSubscription(
    CancelSubscriptionEvent event,
    Emitter<PortfolioState> emit,
  ) async {
    emit(state.copyWith(cancellationStatus: CancellationStatus.loading));

    final result = await _cancelSubscription(
      subscriptionId: event.subscriptionId,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        cancellationStatus: CancellationStatus.error,
        cancellationError: failure.message,
      )),
      (newBalance) {
        // Remove the cancelled subscription from local state
        final updatedSubscriptions = state.subscriptions
            .where((s) => s.id != event.subscriptionId)
            .toList();
        emit(state.copyWith(
          cancellationStatus: CancellationStatus.success,
          subscriptions: updatedSubscriptions,
          newBalance: newBalance,
        ));
      },
    );
  }

  void _onClearCancellationResult(
    ClearCancellationResult event,
    Emitter<PortfolioState> emit,
  ) {
    emit(state.copyWith(
      cancellationStatus: CancellationStatus.idle,
      cancellationError: null,
      newBalance: null,
    ));
  }
}
