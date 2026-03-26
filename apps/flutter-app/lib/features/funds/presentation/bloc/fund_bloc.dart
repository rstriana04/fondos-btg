import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fondos_btg/features/funds/domain/usecases/get_funds.dart';
import 'package:fondos_btg/features/funds/domain/usecases/subscribe_to_fund.dart';
import 'package:fondos_btg/features/funds/presentation/bloc/fund_event.dart';
import 'package:fondos_btg/features/funds/presentation/bloc/fund_state.dart';

class FundBloc extends Bloc<FundEvent, FundState> {
  final GetFundsUseCase _getFunds;
  final SubscribeToFundUseCase _subscribeToFund;

  FundBloc({
    required GetFundsUseCase getFunds,
    required SubscribeToFundUseCase subscribeToFund,
  })  : _getFunds = getFunds,
        _subscribeToFund = subscribeToFund,
        super(const FundState()) {
    on<LoadFunds>(_onLoadFunds);
    on<SubscribeToFund>(_onSubscribeToFund);
    on<ClearSubscriptionResult>(_onClearSubscriptionResult);
  }

  Future<void> _onLoadFunds(
    LoadFunds event,
    Emitter<FundState> emit,
  ) async {
    emit(state.copyWith(status: FundStatus.loading));

    final result = await _getFunds();
    result.fold(
      (failure) => emit(state.copyWith(
        status: FundStatus.error,
        errorMessage: failure.message,
      )),
      (funds) => emit(state.copyWith(
        status: FundStatus.loaded,
        funds: funds,
      )),
    );
  }

  Future<void> _onSubscribeToFund(
    SubscribeToFund event,
    Emitter<FundState> emit,
  ) async {
    emit(state.copyWith(subscriptionStatus: SubscriptionStatus.loading));

    final result = await _subscribeToFund(
      fund: event.fund,
      amount: event.amount,
      currentBalance: event.currentBalance,
      notificationMethod: event.notificationMethod,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        subscriptionStatus: SubscriptionStatus.error,
        subscriptionError: failure.message,
      )),
      (newBalance) => emit(state.copyWith(
        subscriptionStatus: SubscriptionStatus.success,
        newBalance: newBalance,
      )),
    );
  }

  void _onClearSubscriptionResult(
    ClearSubscriptionResult event,
    Emitter<FundState> emit,
  ) {
    emit(state.copyWith(
      subscriptionStatus: SubscriptionStatus.idle,
      subscriptionError: null,
      newBalance: null,
    ));
  }
}
