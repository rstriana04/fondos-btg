import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fondos_btg/features/balance/domain/usecases/get_balance.dart';
import 'package:fondos_btg/features/balance/presentation/bloc/balance_event.dart';
import 'package:fondos_btg/features/balance/presentation/bloc/balance_state.dart';

class BalanceBloc extends Bloc<BalanceEvent, BalanceState> {
  final GetBalanceUseCase _getBalance;

  BalanceBloc({
    required GetBalanceUseCase getBalance,
  })  : _getBalance = getBalance,
        super(const BalanceState()) {
    on<LoadBalance>(_onLoadBalance);
    on<RefreshBalance>(_onRefreshBalance);
  }

  Future<void> _onLoadBalance(
    LoadBalance event,
    Emitter<BalanceState> emit,
  ) async {
    emit(state.copyWith(status: BalanceStatus.loading));
    await _fetchBalance(emit);
  }

  Future<void> _onRefreshBalance(
    RefreshBalance event,
    Emitter<BalanceState> emit,
  ) async {
    await _fetchBalance(emit);
  }

  Future<void> _fetchBalance(Emitter<BalanceState> emit) async {
    final result = await _getBalance();
    result.fold(
      (failure) => emit(state.copyWith(
        status: BalanceStatus.error,
        errorMessage: failure.message,
      )),
      (balanceInfo) => emit(state.copyWith(
        status: BalanceStatus.loaded,
        balanceInfo: balanceInfo,
      )),
    );
  }
}
