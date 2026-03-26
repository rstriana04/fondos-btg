import 'package:flutter/material.dart';
import 'package:fondos_btg/core/theme/app_colors.dart';
import 'package:fondos_btg/core/theme/app_text_styles.dart';
import 'package:fondos_btg/core/utils/currency_formatter.dart';
import 'package:fondos_btg/core/utils/date_formatter.dart';
import 'package:fondos_btg/core/utils/fund_name_formatter.dart';
import 'package:fondos_btg/features/funds/presentation/widgets/fund_category_badge.dart';
import 'package:fondos_btg/features/portfolio/domain/entities/subscription.dart';

class SubscriptionCard extends StatelessWidget {
  final Subscription subscription;
  final VoidCallback onCancel;
  final bool isCancelling;

  const SubscriptionCard({
    super.key,
    required this.subscription,
    required this.onCancel,
    this.isCancelling = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                FundCategoryBadge(category: subscription.category),
                const Spacer(),
                Text(
                  CurrencyFormatter.format(subscription.amount),
                  style: AppTextStyles.subscriptionAmount,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              FundNameFormatter.formatWithHyphens(subscription.fundName),
              style: AppTextStyles.fundName,
            ),
            const SizedBox(height: 4),
            Text(
              'Suscrito el ${DateFormatter.formatShort(subscription.subscribedAt)}',
              style: AppTextStyles.subscriptionDate,
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 38,
              child: OutlinedButton(
                onPressed: isCancelling ? null : onCancel,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.cancelButtonText,
                  side: const BorderSide(color: AppColors.cancelButtonBorder),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: isCancelling
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.cancelButtonText,
                          ),
                        ),
                      )
                    : const Text(
                        'Cancelar suscripcion',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.cancelButtonText,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
