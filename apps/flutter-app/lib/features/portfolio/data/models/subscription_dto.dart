import 'package:fondos_btg/features/portfolio/domain/entities/subscription.dart';

class SubscriptionDto {
  final int id;
  final int fundId;
  final String fundName;
  final String category;
  final double amount;
  final String subscribedAt;

  const SubscriptionDto({
    required this.id,
    required this.fundId,
    required this.fundName,
    required this.category,
    required this.amount,
    required this.subscribedAt,
  });

  factory SubscriptionDto.fromJson(Map<String, dynamic> json) {
    return SubscriptionDto(
      id: json['id'] as int,
      fundId: json['fundId'] as int,
      fundName: json['fundName'] as String,
      category: json['category'] as String,
      amount: (json['amount'] as num).toDouble(),
      subscribedAt: json['subscribedAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fundId': fundId,
      'fundName': fundName,
      'category': category,
      'amount': amount,
      'subscribedAt': subscribedAt,
    };
  }

  Subscription toEntity() {
    return Subscription(
      id: id,
      fundId: fundId,
      fundName: fundName,
      category: category,
      amount: amount,
      subscribedAt: DateTime.parse(subscribedAt),
    );
  }
}
