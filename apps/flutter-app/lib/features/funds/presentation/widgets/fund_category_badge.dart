import 'package:flutter/material.dart';
import 'package:fondos_btg/core/theme/app_colors.dart';
import 'package:fondos_btg/core/theme/app_text_styles.dart';

class FundCategoryBadge extends StatelessWidget {
  final String category;

  const FundCategoryBadge({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final isFpv = category.toUpperCase() == 'FPV';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isFpv ? AppColors.fpvBadgeBg : AppColors.ficBadgeBg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        category.toUpperCase(),
        style: AppTextStyles.categoryBadge.copyWith(
          color: isFpv ? AppColors.fpvBadgeText : AppColors.ficBadgeText,
        ),
      ),
    );
  }
}
