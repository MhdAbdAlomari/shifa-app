import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

/// The app's canonical action button — 48px tall, 12px radius, three
/// variants (filled, subdued, danger). Loading state renders a spinner
/// in place of the label so the caller doesn't have to manage its own
/// busy state.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.expand = true,
    this.variant = PrimaryButtonVariant.filled,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool expand;
  final PrimaryButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final button = SizedBox(
      height: AppSpacing.buttonHeight,
      child: switch (variant) {
        PrimaryButtonVariant.filled => _filled(),
        PrimaryButtonVariant.subdued => _subdued(),
        PrimaryButtonVariant.outlined => _outlined(),
        PrimaryButtonVariant.danger => _danger(),
      },
    );
    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }

  ButtonStyle _base(Color bg, Color fg) => FilledButton.styleFrom(
        backgroundColor: bg,
        disabledBackgroundColor: bg.withValues(alpha: 0.4),
        foregroundColor: fg,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
        ),
        textStyle: AppTextStyles.button.copyWith(color: fg),
      );

  Widget _filled() {
    final button = FilledButton(
      onPressed: isLoading ? null : onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: Colors.transparent,
        disabledBackgroundColor: Colors.transparent,
        foregroundColor: AppColors.textOnPrimary,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
        ),
        textStyle: AppTextStyles.button.copyWith(color: AppColors.textOnPrimary),
      ),
      child: _content(AppColors.textOnPrimary),
    );
    // Layered as a gradient container behind a transparent FilledButton
    // (rather than a raw GestureDetector) so we keep Material's ripple,
    // focus, and disabled-opacity behavior for free.
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: onPressed == null && !isLoading
            ? null
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primary, AppColors.primaryDeep],
              ),
        color: onPressed == null && !isLoading
            ? AppColors.primary.withValues(alpha: 0.4)
            : null,
        borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
      ),
      child: button,
    );
  }

  Widget _subdued() => FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: _base(AppColors.statusFreeBg, AppColors.primary),
        child: _content(AppColors.primary),
      );

  Widget _outlined() => OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
          ),
          textStyle: AppTextStyles.button.copyWith(color: AppColors.primary),
        ),
        child: _content(AppColors.primary),
      );

  Widget _danger() => FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: _base(AppColors.danger, AppColors.textOnPrimary),
        child: _content(AppColors.textOnPrimary),
      );

  Widget _content(Color foreground) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.2,
          valueColor: AlwaysStoppedAnimation(foreground),
        ),
      );
    }
    if (icon == null) return Text(label);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: AppSpacing.xs),
        Text(label),
      ],
    );
  }
}

enum PrimaryButtonVariant { filled, subdued, outlined, danger }
