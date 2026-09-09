import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

/// Shows a SnackBar for a failed action — server error, validation
/// conflict, network failure. Deliberately styled in [AppColors.danger]
/// rather than the app's default neutral SnackBar theme, so a critical
/// state (booking conflict, forbidden action, etc.) is unmistakable at
/// a glance in a hospital context. Success/informational messages
/// should keep using the plain `SnackBar(content: Text(...))` +
/// `ScaffoldMessenger` pattern, which inherits the neutral theme.
void showErrorSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(
      SnackBar(
        backgroundColor: AppColors.danger,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
        ),
        content: Row(
          children: [
            const Icon(
              Icons.error_outline,
              color: AppColors.textOnPrimary,
              size: 20,
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.textOnPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
}
