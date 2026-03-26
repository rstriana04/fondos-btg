import 'package:equatable/equatable.dart';

class BalanceInfo extends Equatable {
  final double balance;
  final double investedAmount;

  const BalanceInfo({
    required this.balance,
    required this.investedAmount,
  });

  double get totalAssets => balance + investedAmount;

  @override
  List<Object?> get props => [balance, investedAmount];
}
