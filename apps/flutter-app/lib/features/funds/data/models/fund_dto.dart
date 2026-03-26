import 'package:fondos_btg/features/funds/domain/entities/fund.dart';

class FundDto {
  final int id;
  final String name;
  final double minAmount;
  final String category;

  const FundDto({
    required this.id,
    required this.name,
    required this.minAmount,
    required this.category,
  });

  factory FundDto.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    return FundDto(
      id: rawId is int ? rawId : int.parse(rawId.toString()),
      name: json['name'] as String,
      minAmount: (json['minAmount'] as num).toDouble(),
      category: json['category'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'minAmount': minAmount,
      'category': category,
    };
  }

  Fund toEntity() {
    return Fund(
      id: id,
      name: name,
      minAmount: minAmount,
      category: category,
    );
  }

  static FundDto fromEntity(Fund fund) {
    return FundDto(
      id: fund.id,
      name: fund.name,
      minAmount: fund.minAmount,
      category: fund.category,
    );
  }
}
