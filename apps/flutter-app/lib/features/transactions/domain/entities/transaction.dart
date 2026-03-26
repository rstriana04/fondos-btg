import 'package:equatable/equatable.dart';

enum TransactionType { subscription, cancellation }

class FundTransaction extends Equatable {
  final int id;
  final int fundId;
  final String fundName;
  final String category;
  final TransactionType type;
  final double amount;
  final String notification;
  final DateTime createdAt;

  const FundTransaction({
    required this.id,
    required this.fundId,
    required this.fundName,
    required this.category,
    required this.type,
    required this.amount,
    required this.notification,
    required this.createdAt,
  });

  /// Whether this is a subscription transaction.
  bool get isSubscription => type == TransactionType.subscription;

  /// Whether this is a cancellation transaction.
  bool get isCancellation => type == TransactionType.cancellation;

  @override
  List<Object?> get props => [
        id,
        fundId,
        fundName,
        category,
        type,
        amount,
        notification,
        createdAt,
      ];
}
