import 'package:fondos_btg/features/transactions/domain/entities/transaction.dart';

class TransactionDto {
  final String id;
  final String fundId;
  final String type;
  final double amount;
  final String date;
  final String? notification;
  final String? fundName;
  final String? category;

  const TransactionDto({
    required this.id,
    required this.fundId,
    required this.type,
    required this.amount,
    required this.date,
    this.notification,
    this.fundName,
    this.category,
  });

  factory TransactionDto.fromJson(Map<String, dynamic> json) {
    return TransactionDto(
      id: json['id'].toString(),
      fundId: json['fundId'].toString(),
      type: json['type'] as String,
      amount: (json['amount'] as num).toDouble(),
      date: json['date'] as String,
      notification: json['notification'] as String?,
      fundName: json['fundName'] as String?,
      category: json['category'] as String?,
    );
  }

  TransactionDto copyWith({String? fundName, String? category}) {
    return TransactionDto(
      id: id,
      fundId: fundId,
      type: type,
      amount: amount,
      date: date,
      notification: notification,
      fundName: fundName ?? this.fundName,
      category: category ?? this.category,
    );
  }

  FundTransaction toEntity() {
    return FundTransaction(
      id: id.hashCode,
      fundId: int.tryParse(fundId) ?? 0,
      fundName: fundName ?? fundId,
      category: category ?? '',
      type: type == 'subscription'
          ? TransactionType.subscription
          : TransactionType.cancellation,
      amount: amount,
      notification: notification ?? '',
      createdAt: DateTime.tryParse(date) ?? DateTime.now(),
    );
  }
}
