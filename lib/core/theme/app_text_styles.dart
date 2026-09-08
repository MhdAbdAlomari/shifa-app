import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Typography scale for Shifa, aligned exactly with the
/// `surgical_precision_calm` DESIGN.md tokens.
///
/// Two families: Plus Jakarta Sans for headline/title-lg (semi-bold and
/// bold), Inter for data-dense body/label. Both are provided by the
/// system font stack (fallbacks to the platform default if the fonts
/// aren't bundled — the shape and weight system still holds).
class AppTextStyles {
  const AppTextStyles._();

  static const String _headingFamily = 'Plus Jakarta Sans';
  static const String _bodyFamily = 'Inter';

  // Headline — Plus Jakarta Sans, tabular-friendly for numeric IDs
  // ("OR 2", "07:30"). We enable feature "tnum" on time/number widgets
  // as needed, but the style itself doesn't force it.
  static const TextStyle headlineLg = TextStyle(
    fontFamily: _headingFamily,
    fontSize: 30,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 38 / 30,
  );

  static const TextStyle headlineMd = TextStyle(
    fontFamily: _headingFamily,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 28 / 22,
  );

  static const TextStyle headlineSm = TextStyle(
    fontFamily: _headingFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 24 / 18,
  );

  static const TextStyle titleLg = TextStyle(
    fontFamily: _headingFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 22 / 16,
  );

  static const TextStyle titleMd = TextStyle(
    fontFamily: _bodyFamily,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 20 / 15,
  );

  static const TextStyle bodyLg = TextStyle(
    fontFamily: _bodyFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 24 / 16,
  );

  static const TextStyle bodyMd = TextStyle(
    fontFamily: _bodyFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 20 / 14,
  );

  static const TextStyle bodySm = TextStyle(
    fontFamily: _bodyFamily,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 18 / 13,
  );

  static const TextStyle labelLg = TextStyle(
    fontFamily: _bodyFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 18 / 14,
  );

  static const TextStyle labelMd = TextStyle(
    fontFamily: _bodyFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 16 / 12,
  );

  static const TextStyle labelSm = TextStyle(
    fontFamily: _bodyFamily,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    height: 14 / 11,
    letterSpacing: 0.4,
  );

  // Button — matches label-lg per DESIGN.md.
  static const TextStyle button = TextStyle(
    fontFamily: _bodyFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textOnPrimary,
    height: 18 / 14,
    letterSpacing: 0.2,
  );
}
