import 'package:equatable/equatable.dart';

class Fund extends Equatable {
  final int id;
  final String name;
  final double minAmount;
  final String category;

  const Fund({
    required this.id,
    required this.name,
    required this.minAmount,
    required this.category,
  });

  /// Whether this fund belongs to the FPV category.
  bool get isFpv => category.toUpperCase() == 'FPV';

  /// Whether this fund belongs to the FIC category.
  bool get isFic => category.toUpperCase() == 'FIC';

  @override
  List<Object?> get props => [id, name, minAmount, category];
}
