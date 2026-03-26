import 'package:equatable/equatable.dart';

class Subscription extends Equatable {
  final int id;
  final int fundId;
  final String fundName;
  final String category;
  final double amount;
  final DateTime subscribedAt;

  const Subscription({
    required this.id,
    required this.fundId,
    required this.fundName,
    required this.category,
    required this.amount,
    required this.subscribedAt,
  });

  /// Whether this subscription belongs to the FPV category.
  bool get isFpv => category.toUpperCase() == 'FPV';

  /// Whether this subscription belongs to the FIC category.
  bool get isFic => category.toUpperCase() == 'FIC';

  @override
  List<Object?> get props => [
        id,
        fundId,
        fundName,
        category,
        amount,
        subscribedAt,
      ];
}
