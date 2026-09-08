import 'package:flutter/material.dart';

/// Centralized color palette for the Shifa design system.
///
/// Values match the `surgical_precision_calm` design tokens exactly.
class AppColors {
  const AppColors._();

  // Brand — surgical teal spectrum. Primary anchors identity, actions,
  // and any "on / active" state; secondary is used for interactive
  // highlights and complementary confirmations.
  static const Color primary = Color(0xFF0F6E56);
  static const Color primaryDeep = Color(0xFF0A4D3C);
  static const Color secondary = Color(0xFF1D9E75);

  // Accent — warm amber. Reserved for warnings, turnover, and delay
  // states. Never used on primary CTAs or navigation.
  static const Color accent = Color(0xFFEF9F27);
  static const Color accentText = Color(0xFFB4710A);

  // Danger — reserved for emergency-priority surgeries and destructive
  // actions. Overuse dilutes the signal.
  static const Color danger = Color(0xFFE24B4A);

  // Surfaces — off-white background prevents glare; pure-white cards
  // sit on top; 1px hairline separates them without a heavy shadow.
  static const Color background = Color(0xFFF8FAF9);
  static const Color backgroundAlt = Color(0xFFF9FBFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFE5EBE8);
  static const Color softHover = Color(0xFFF0F3F2);

  // Text
  static const Color textPrimary = Color(0xFF17231F);
  static const Color textSecondary = Color(0xFF52665F);
  static const Color textPlaceholder = Color(0xFF8A9E97);
  static const Color textDisabled = Color(0xFF9AA8A4);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Clinical operational status tokens (per DESIGN.md).
  // "Free" — light-green pill.
  static const Color statusFreeBg = Color(0xFFE6F5F0);
  static const Color statusFreeText = primary;
  static const Color statusFreeBorder = Color(0xFFC4EADF);
  // "In use / active case" — solid primary fill with white text.
  static const Color statusInUseBg = primary;
  static const Color statusInUseText = Color(0xFFFFFFFF);
  static const Color statusInUseBorder = primary;
  // "Preparing / pre-op" — warm amber pill.
  static const Color statusPreparingBg = Color(0xFFFEF6E9);
  static const Color statusPreparingText = accentText;
  static const Color statusPreparingBorder = Color(0xFFF8DFB7);
  // "Cleaning / turnover" — neutral grey pill.
  static const Color statusCleaningBg = softHover;
  static const Color statusCleaningText = textSecondary;
  static const Color statusCleaningBorder = Color(0xFFDCE3E0);
}
