import 'package:equatable/equatable.dart';
import 'package:fondos_btg/features/transactions/domain/entities/transaction.dart';

enum TransactionStatus { initial, loading, loaded, error }

class TransactionState extends Equatable {
  final TransactionStatus status;
  final List<FundTransaction> transactions;
  final String? errorMessage;

  const TransactionState({
    this.status = TransactionStatus.initial,
    this.transactions = const [],
    this.errorMessage,
  });

  TransactionState copyWith({
    TransactionStatus? status,
    List<FundTransaction>? transactions,
    String? errorMessage,
  }) {
    return TransactionState(
      status: status ?? this.status,
      transactions: transactions ?? this.transactions,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, transactions, errorMessage];
}
