import 'package:flutter/material.dart';
import 'package:fondos_btg/core/theme/app_colors.dart';
import 'package:fondos_btg/core/utils/currency_formatter.dart';
import 'package:fondos_btg/features/transactions/domain/entities/transaction.dart';

class TransactionSummaryCards extends StatelessWidget {
  final List<FundTransaction> transactions;

  const TransactionSummaryCards({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    final subscriptions =
        transactions.where((t) => t.isSubscription).toList();
    final cancellations =
        transactions.where((t) => t.isCancellation).toList();
    final totalSubscribed =
        subscriptions.fold<double>(0, (sum, t) => sum + t.amount);
    final totalCancelled =
        cancellations.fold<double>(0, (sum, t) => sum + t.amount);

    return SizedBox(
      height: 88,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _StatCard(
            label: 'Total',
            value: '${transactions.length}',
            icon: Icons.receipt_long_outlined,
            color: AppColors.blueAccent,
          ),
          const SizedBox(width: 10),
          _StatCard(
            label: 'Suscripciones',
            value: '${subscriptions.length}',
            icon: Icons.arrow_upward_rounded,
            color: AppColors.error,
          ),
          const SizedBox(width: 10),
          _StatCard(
            label: 'Cancelaciones',
            value: '${cancellations.length}',
            icon: Icons.arrow_downward_rounded,
            color: AppColors.success,
          ),
          const SizedBox(width: 10),
          _StatCard(
            label: 'Invertido',
            value: CurrencyFormatter.format(totalSubscribed),
            icon: Icons.trending_down_rounded,
            color: AppColors.error,
            wide: true,
          ),
          const SizedBox(width: 10),
          _StatCard(
            label: 'Devuelto',
            value: CurrencyFormatter.format(totalCancelled),
            icon: Icons.trending_up_rounded,
            color: AppColors.success,
            wide: true,
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool wide;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.wide = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: wide ? 150 : 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
