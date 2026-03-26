import 'package:flutter/material.dart';
import 'package:fondos_btg/core/theme/app_colors.dart';
import 'package:fondos_btg/core/theme/app_text_styles.dart';
import 'package:fondos_btg/core/utils/currency_formatter.dart';
import 'package:fondos_btg/core/utils/fund_name_formatter.dart';
import 'package:fondos_btg/features/funds/domain/entities/fund.dart';
import 'package:fondos_btg/features/funds/presentation/widgets/fund_category_badge.dart';

class FundCard extends StatelessWidget {
  final Fund fund;
  final VoidCallback onSubscribe;

  const FundCard({
    super.key,
    required this.fund,
    required this.onSubscribe,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FundCategoryBadge(category: fund.category),
                  const SizedBox(height: 10),
                  Text(
                    FundNameFormatter.formatWithHyphens(fund.name),
                    style: AppTextStyles.fundName,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Min. ${CurrencyFormatter.format(fund.minAmount)}',
                    style: AppTextStyles.fundMinAmount,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              height: 40,
              child: ElevatedButton(
                onPressed: onSubscribe,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blueAccent,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Suscribir',
                  style: AppTextStyles.buttonPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
