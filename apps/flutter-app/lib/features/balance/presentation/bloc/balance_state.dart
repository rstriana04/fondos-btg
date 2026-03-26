import 'package:equatable/equatable.dart';
import 'package:fondos_btg/features/balance/domain/entities/balance_info.dart';

enum BalanceStatus { initial, loading, loaded, error }

class BalanceState extends Equatable {
  final BalanceStatus status;
  final BalanceInfo? balanceInfo;
  final String? errorMessage;

  const BalanceState({
    this.status = BalanceStatus.initial,
    this.balanceInfo,
    this.errorMessage,
  });

  double get balance => balanceInfo?.balance ?? 0;
  double get investedAmount => balanceInfo?.investedAmount ?? 0;

  BalanceState copyWith({
    BalanceStatus? status,
    BalanceInfo? balanceInfo,
    String? errorMessage,
  }) {
    return BalanceState(
      status: status ?? this.status,
      balanceInfo: balanceInfo ?? this.balanceInfo,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, balanceInfo, errorMessage];
}
