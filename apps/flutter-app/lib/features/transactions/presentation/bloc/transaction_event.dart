import 'package:equatable/equatable.dart';

sealed class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

final class LoadTransactions extends TransactionEvent {
  const LoadTransactions();
}
