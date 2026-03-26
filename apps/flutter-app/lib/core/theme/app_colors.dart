import 'package:flutter/material.dart';

abstract final class AppColors {
  // Primary palette
  static const Color navy = Color(0xFF0A2647);
  static const Color blueDark = Color(0xFF144272);
  static const Color blueMid = Color(0xFF205295);
  static const Color blueAccent = Color(0xFF2C74B3);

  // Semantic
  static const Color success = Color(0xFF1D9E75);
  static const Color error = Color(0xFFE24B4A);
  static const Color warning = Color(0xFFEF9F27);

  // Surfaces
  static const Color surface = Color(0xFFF5F7FA);
  static const Color divider = Color(0xFFE8ECF1);
  static const Color white = Color(0xFFFFFFFF);

  // FPV badge
  static const Color fpvBadgeBg = Color(0xFFE6F1FB);
  static const Color fpvBadgeText = Color(0xFF0C447C);

  // FIC badge
  static const Color ficBadgeBg = Color(0xFFEEEDFE);
  static const Color ficBadgeText = Color(0xFF3C3489);

  // Text
  static const Color textPrimary = Color(0xFF0A2647);
  static const Color textSecondary = Color(0xFF888780);
  static const Color textMuted = Color(0xFFB4B2A9);

  // Balance
  static const Color balanceLabel = Color(0xFF85B7EB);

  // Portfolio
  static const Color investedGreen = Color(0xFF085041);

  // Transaction icons
  static const Color subscriptionIconBg = Color(0xFFFCEBEB);
  static const Color cancellationIconBg = Color(0xFFE1F5EE);

  // Cancel button
  static const Color cancelButtonBorder = Color(0xFFE24B4A);
  static const Color cancelButtonText = Color(0xFFA32D2D);

  // Disabled
  static const Color disabled = Color(0xFFB4B2A9);
}
