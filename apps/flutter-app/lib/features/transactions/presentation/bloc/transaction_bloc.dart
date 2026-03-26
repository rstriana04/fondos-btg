import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fondos_btg/features/transactions/domain/usecases/get_transactions.dart';
import 'package:fondos_btg/features/transactions/presentation/bloc/transaction_event.dart';
import 'package:fondos_btg/features/transactions/presentation/bloc/transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final GetTransactionsUseCase _getTransactions;

  TransactionBloc({
    required GetTransactionsUseCase getTransactions,
  })  : _getTransactions = getTransactions,
        super(const TransactionState()) {
    on<LoadTransactions>(_onLoadTransactions);
  }

  Future<void> _onLoadTransactions(
    LoadTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    emit(state.copyWith(status: TransactionStatus.loading));

    final result = await _getTransactions();
    result.fold(
      (failure) => emit(state.copyWith(
        status: TransactionStatus.error,
        errorMessage: failure.message,
      )),
      (transactions) => emit(state.copyWith(
        status: TransactionStatus.loaded,
        transactions: transactions,
      )),
    );
  }
}
