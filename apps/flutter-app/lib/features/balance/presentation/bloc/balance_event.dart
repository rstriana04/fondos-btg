import 'package:equatable/equatable.dart';

sealed class BalanceEvent extends Equatable {
  const BalanceEvent();

  @override
  List<Object?> get props => [];
}

final class LoadBalance extends BalanceEvent {
  const LoadBalance();
}

final class RefreshBalance extends BalanceEvent {
  const RefreshBalance();
}
