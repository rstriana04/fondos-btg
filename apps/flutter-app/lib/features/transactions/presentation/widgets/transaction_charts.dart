import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:fondos_btg/core/theme/app_colors.dart';
import 'package:fondos_btg/core/utils/currency_formatter.dart';
import 'package:fondos_btg/core/utils/fund_name_formatter.dart';
import 'package:fondos_btg/features/transactions/domain/entities/transaction.dart';

class TransactionCharts extends StatelessWidget {
  final List<FundTransaction> transactions;

  const TransactionCharts({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _DonutChart(transactions: transactions),
        const SizedBox(height: 12),
        _FundBarChart(transactions: transactions),
      ],
    );
  }
}

class _DonutChart extends StatelessWidget {
  final List<FundTransaction> transactions;

  const _DonutChart({required this.transactions});

  @override
  Widget build(BuildContext context) {
    final subscriptionCount =
        transactions.where((t) => t.isSubscription).length;
    final cancellationCount =
        transactions.where((t) => t.isCancellation).length;
    final total = transactions.length;
    if (total == 0) return const SizedBox.shrink();

    final subPct = subscriptionCount / total;
    final canPct = cancellationCount / total;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Distribucion por tipo',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: CustomPaint(
                  painter: _DonutPainter(
                    subscriptionPct: subPct,
                    cancellationPct: canPct,
                  ),
                  child: Center(
                    child: Text(
                      '$total',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _LegendItem(
                      color: AppColors.error,
                      label: 'Suscripciones',
                      count: subscriptionCount,
                      pct: (subPct * 100).round(),
                    ),
                    const SizedBox(height: 10),
                    _LegendItem(
                      color: AppColors.success,
                      label: 'Cancelaciones',
                      count: cancellationCount,
                      pct: (canPct * 100).round(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final double subscriptionPct;
  final double cancellationPct;

  _DonutPainter({
    required this.subscriptionPct,
    required this.cancellationPct,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 14.0;
    final rect = Rect.fromCircle(center: center, radius: radius - strokeWidth / 2);

    final bgPaint = Paint()
      ..color = AppColors.divider
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius - strokeWidth / 2, bgPaint);

    const startAngle = -math.pi / 2;

    if (subscriptionPct > 0) {
      final subPaint = Paint()
        ..color = AppColors.error
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        rect,
        startAngle,
        subscriptionPct * 2 * math.pi,
        false,
        subPaint,
      );
    }

    if (cancellationPct > 0) {
      final canPaint = Paint()
        ..color = AppColors.success
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        rect,
        startAngle + subscriptionPct * 2 * math.pi,
        cancellationPct * 2 * math.pi,
        false,
        canPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) =>
      subscriptionPct != oldDelegate.subscriptionPct ||
      cancellationPct != oldDelegate.cancellationPct;
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final int count;
  final int pct;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.count,
    required this.pct,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '$label ($count)',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Text(
          '$pct%',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _FundBarChart extends StatelessWidget {
  final List<FundTransaction> transactions;

  const _FundBarChart({required this.transactions});

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) return const SizedBox.shrink();

    final fundTotals = <String, double>{};
    for (final tx in transactions) {
      final name = FundNameFormatter.format(tx.fundName);
      fundTotals[name] = (fundTotals[name] ?? 0) + tx.amount;
    }

    final sorted = fundTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final maxAmount = sorted.first.value;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Movimientos por fondo',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          ...sorted.map((entry) => _BarItem(
                name: entry.key,
                amount: entry.value,
                maxAmount: maxAmount,
              )),
        ],
      ),
    );
  }
}

class _BarItem extends StatelessWidget {
  final String name;
  final double amount;
  final double maxAmount;

  const _BarItem({
    required this.name,
    required this.amount,
    required this.maxAmount,
  });

  @override
  Widget build(BuildContext context) {
    final fraction = maxAmount > 0 ? amount / maxAmount : 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                CurrencyFormatter.format(amount),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: fraction,
              backgroundColor: AppColors.divider,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.blueAccent),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
