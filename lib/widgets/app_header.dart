import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../blocs/auth/auth_bloc.dart';
import '../blocs/unread_notifications/unread_notifications_cubit.dart';
import '../core/router/app_routes.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../l10n/generated/app_localizations.dart';

/// Fixed top header used on every authenticated screen.
///
/// Contains:
///   - Shifa logo + role-specific subtitle (e.g. "Or Schedule",
///     "My Surgeries", "Clinical Alerts")
///   - Notification bell with unread indicator (routes to Notifications)
///   - Circular avatar showing the current user's initials, tapping
///     which opens a menu with the logout action.
///
/// Rendered as a `PreferredSizeWidget` so screens can slot it into
/// `Scaffold.appBar` without extra plumbing.
class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppHeader({super.key, required this.subtitle});

  /// Small line under the "Shifa" wordmark. Reflects the screen the
  /// user is currently on ("Or Schedule", "My Surgeries", etc.).
  final String subtitle;

  static const double _height = 64;

  @override
  Size get preferredSize => const Size.fromHeight(_height);

  @override
  Widget build(BuildContext context) {
    // The gradient container wraps SafeArea (rather than the reverse)
    // so the fill paints full-bleed behind the status bar too — SafeArea
    // only insets its child with padding, it doesn't extend whatever's
    // behind it, so nesting it the other way left a plain white strip
    // above the gradient (item 2 fix). AnnotatedRegion switches the
    // status bar's icons/text to light so they stay legible against the
    // teal gradient, restored to the default (dark) once this header is
    // no longer the topmost region — e.g. Settings' plain AppBar.
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.secondary],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Container(
            height: _height,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenEdge,
              vertical: AppSpacing.xs,
            ),
            // A Row with two Spacers only *visually* centers the middle
            // child when its flanking siblings are equal width — here
            // `_Brand` (logo + wordmark) is wider than the bell+avatar
            // cluster, so the title drifted right. A Stack with the
            // title as a full-width, centered layer guarantees true
            // centering regardless of the side content's width (item 5
            // fix).
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: _TitleColumn(subtitle: subtitle),
                ),
                Row(
                  children: [
                    const _Brand(),
                    const Spacer(),
                    const _NotificationBell(),
                    const SizedBox(width: AppSpacing.xs),
                    const _UserAvatar(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand();

  @override
  Widget build(BuildContext context) {
    // Just the mark — the "Shifa" wordmark itself lives in the
    // centered [_TitleColumn] layer so it isn't shown twice.
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.xs),
      child: Image.asset(
        'assets/images/shifa_logo.png',
        width: 32,
        height: 32,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _TitleColumn extends StatelessWidget {
  const _TitleColumn({required this.subtitle});

  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.appName,
          style: AppTextStyles.titleLg.copyWith(color: AppColors.textOnPrimary),
        ),
        Text(
          subtitle,
          style: AppTextStyles.labelSm.copyWith(
            color: AppColors.textOnPrimary.withValues(alpha: 0.85),
          ),
        ),
      ],
    );
  }
}

class _NotificationBell extends StatelessWidget {
  const _NotificationBell();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UnreadNotificationsCubit, int>(
      builder: (context, unread) {
        return IconButton(
          onPressed: () => context.goNamed(AppRoutes.notifications),
          tooltip: AppLocalizations.of(context).notificationsTooltip,
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(
                Icons.notifications_outlined,
                color: AppColors.textOnPrimary,
              ),
              if (unread > 0)
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: AppColors.danger,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar();

  @override
  Widget build(BuildContext context) {
    // `read`, not `watch`: the router will redirect us away when the
    // user is cleared, so we don't want a rebuild on that transition.
    final user = context.read<AuthBloc>().state.user;
    final initials = _initialsOf(user?.name ?? '?');
    return PopupMenuButton<String>(
      tooltip: user?.name ?? '',
      offset: const Offset(0, 44),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
      ),
      onSelected: (value) {
        if (value == 'logout') {
          context.read<AuthBloc>().add(const AuthLogoutRequested());
        } else if (value == 'settings') {
          context.pushNamed(AppRoutes.settings);
        }
      },
      itemBuilder: (context) {
        final l10n = AppLocalizations.of(context);
        return [
          PopupMenuItem<String>(
            enabled: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user?.name ?? '', style: AppTextStyles.labelLg),
                Text(user?.email ?? '', style: AppTextStyles.bodySm),
              ],
            ),
          ),
          const PopupMenuDivider(),
          PopupMenuItem<String>(
            value: 'settings',
            child: Row(
              children: [
                const Icon(
                  Icons.settings_outlined,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(l10n.settingsTitle),
              ],
            ),
          ),
          PopupMenuItem<String>(
            value: 'logout',
            child: Row(
              children: [
                const Icon(
                  Icons.logout,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(l10n.logOut),
              ],
            ),
          ),
        ];
      },
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.primaryDeep,
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.textOnPrimary.withValues(alpha: 0.6),
            width: 1.5,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          initials,
          style: AppTextStyles.labelLg.copyWith(
            color: AppColors.textOnPrimary,
          ),
        ),
      ),
    );
  }

  String _initialsOf(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((s) => s.isNotEmpty);
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}
