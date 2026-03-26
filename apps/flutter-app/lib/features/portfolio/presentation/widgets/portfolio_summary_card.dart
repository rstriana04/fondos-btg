import 'package:flutter/material.dart';
import 'package:fondos_btg/core/theme/app_colors.dart';
import 'package:fondos_btg/core/theme/app_text_styles.dart';
import 'package:fondos_btg/core/utils/currency_formatter.dart';

class PortfolioSummaryCard extends StatelessWidget {
  final double balance;
  final double investedAmount;

  const PortfolioSummaryCard({
    super.key,
    required this.balance,
    required this.investedAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Saldo disponible',
                    style: AppTextStyles.summaryLabel,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    CurrencyFormatter.format(balance),
                    style: AppTextStyles.summaryAmount,
                  ),
                ],
              ),
            ),
            Container(
              width: 1,
              height: 48,
              color: AppColors.divider,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Monto invertido',
                      style: AppTextStyles.summaryLabel,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      CurrencyFormatter.format(investedAmount),
                      style: AppTextStyles.investedAmount,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
