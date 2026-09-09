import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_shadows.dart';
import '../core/theme/app_spacing.dart';

/// The canonical card surface — 20px radius, 20px interior padding, a
/// soft diffused floating shadow (no hard border by default). Pass
/// [hero] for primary/emphasis cards (e.g. the current-surgery card, a
/// room header) to layer in a faint diagonal primary-tint gradient;
/// regular list-item cards stay flat white.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.cardPadding),
    this.margin,
    this.color = AppColors.surface,
    this.borderColor,
    this.elevated = false,
    this.hero = false,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color color;
  final Color? borderColor;
  final bool elevated;

  /// Marks this as primary/hero content — adds a subtle diagonal
  /// white-to-primary-tint gradient instead of a flat fill. Reserved
  /// for cards that deserve visual emphasis (current case, room
  /// header) so the treatment doesn't become noise everywhere.
  final bool hero;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppSpacing.radiusCard);
    final content = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: padding,
      decoration: BoxDecoration(
        color: hero ? null : color,
        gradient: hero
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color, AppColors.primary.withValues(alpha: 0.05)],
              )
            : null,
        borderRadius: radius,
        border: borderColor == null
            ? null
            : Border.all(color: borderColor!),
        boxShadow: elevated ? AppShadows.cardElevated : AppShadows.card,
      ),
      child: child,
    );

    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: onTap == null
          ? content
          : Material(
              color: Colors.transparent,
              borderRadius: radius,
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onTap,
                borderRadius: radius,
                highlightColor: AppColors.primary.withValues(alpha: 0.04),
                splashColor: AppColors.primary.withValues(alpha: 0.06),
                child: content,
              ),
            ),
    );
  }
}
