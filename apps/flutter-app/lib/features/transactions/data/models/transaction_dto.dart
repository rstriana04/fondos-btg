import 'package:fondos_btg/features/transactions/domain/entities/transaction.dart';

class TransactionDto {
  final int id;
  final int fundId;
  final String fundName;
  final String category;
  final String type;
  final double amount;
  final String createdAt;

  const TransactionDto({
    required this.id,
    required this.fundId,
    required this.fundName,
    required this.category,
    required this.type,
    required this.amount,
    required this.createdAt,
  });

  factory TransactionDto.fromJson(Map<String, dynamic> json) {
    return TransactionDto(
      id: json['id'] as int,
      fundId: json['fundId'] as int,
      fundName: json['fundName'] as String,
      category: json['category'] as String,
      type: json['type'] as String,
      amount: (json['amount'] as num).toDouble(),
      createdAt: json['createdAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fundId': fundId,
      'fundName': fundName,
      'category': category,
      'type': type,
      'amount': amount,
      'createdAt': createdAt,
    };
  }

  FundTransaction toEntity() {
    return FundTransaction(
      id: id,
      fundId: fundId,
      fundName: fundName,
      category: category,
      type: type == 'subscription'
          ? TransactionType.subscription
          : TransactionType.cancellation,
      amount: amount,
      createdAt: DateTime.parse(createdAt),
    );
  }
}
