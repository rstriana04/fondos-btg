import 'package:flutter/material.dart';
import 'package:fondos_btg/core/theme/app_colors.dart';
import 'package:fondos_btg/core/theme/app_text_styles.dart';
import 'package:fondos_btg/core/utils/currency_formatter.dart';
import 'package:fondos_btg/core/utils/date_formatter.dart';
import 'package:fondos_btg/core/utils/fund_name_formatter.dart';
import 'package:fondos_btg/features/transactions/domain/entities/transaction.dart';

class TransactionItem extends StatelessWidget {
  final FundTransaction transaction;

  const TransactionItem({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    final isSubscription = transaction.isSubscription;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Circular icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isSubscription
                  ? AppColors.subscriptionIconBg
                  : AppColors.cancellationIconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isSubscription
                  ? Icons.arrow_upward_rounded
                  : Icons.arrow_downward_rounded,
              color: isSubscription ? AppColors.error : AppColors.success,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),

          // Fund name + date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  FundNameFormatter.formatWithHyphens(transaction.fundName),
                  style: AppTextStyles.transactionFundName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  DateFormatter.format(transaction.createdAt),
                  style: AppTextStyles.transactionDate,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Amount + type label
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                CurrencyFormatter.formatWithSign(
                  transaction.amount,
                  positive: !isSubscription,
                ),
                style: isSubscription
                    ? AppTextStyles.transactionAmountNegative
                    : AppTextStyles.transactionAmountPositive,
              ),
              const SizedBox(height: 2),
              Text(
                isSubscription ? 'Suscripcion' : 'Cancelacion',
                style: AppTextStyles.transactionType,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
