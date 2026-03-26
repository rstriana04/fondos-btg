import 'package:flutter/material.dart';
import 'package:fondos_btg/core/theme/app_colors.dart';

abstract final class AppTextStyles {
  // Headers
  static const TextStyle appBarTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
    letterSpacing: 0.5,
  );

  static const TextStyle balanceAmount = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
  );

  static const TextStyle balanceLabel = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.balanceLabel,
  );

  // Fund card
  static const TextStyle fundName = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle fundMinAmount = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle categoryBadge = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  // Buttons
  static const TextStyle buttonPrimary = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  static const TextStyle buttonOutlined = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );

  // Bottom sheet
  static const TextStyle sheetTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle sheetSubtitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle inputLabel = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle inputValue = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Portfolio
  static const TextStyle summaryLabel = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle summaryAmount = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle investedAmount = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.investedGreen,
  );

  static const TextStyle subscriptionDate = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle subscriptionAmount = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Transactions
  static const TextStyle transactionFundName = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle transactionDate = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle transactionAmountPositive = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.success,
  );

  static const TextStyle transactionAmountNegative = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.error,
  );

  static const TextStyle transactionType = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  // Error
  static const TextStyle errorBanner = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.error,
  );

  // Section header
  static const TextStyle sectionHeader = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  // Navigation
  static const TextStyle navLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );
}
