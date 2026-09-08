import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../blocs/auth/auth_bloc.dart';
import '../blocs/unread_notifications/unread_notifications_cubit.dart';
import '../core/router/app_routes.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

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
    return SafeArea(
      bottom: false,
      child: Container(
        height: _height,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenEdge,
          vertical: AppSpacing.xs,
        ),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(
            bottom: BorderSide(color: AppColors.divider),
          ),
        ),
        child: Row(
          children: [
            const _Brand(),
            const Spacer(),
            _WordmarkColumn(subtitle: subtitle),
            const Spacer(),
            const _NotificationBell(),
            const SizedBox(width: AppSpacing.xs),
            const _UserAvatar(),
          ],
        ),
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppSpacing.xs),
          ),
          child: const Icon(
            Icons.add,
            color: AppColors.textOnPrimary,
            size: 20,
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          'Shifa',
          style: AppTextStyles.titleLg.copyWith(color: AppColors.primary),
        ),
        const SizedBox(width: 2),
        Text(
          'OR',
          style: AppTextStyles.labelSm.copyWith(color: AppColors.secondary),
        ),
      ],
    );
  }
}

class _WordmarkColumn extends StatelessWidget {
  const _WordmarkColumn({required this.subtitle});

  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Shifa', style: AppTextStyles.titleLg),
        Text(subtitle, style: AppTextStyles.labelSm),
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
          tooltip: 'Notifications',
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(
                Icons.notifications_outlined,
                color: AppColors.textSecondary,
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
                        color: AppColors.surface,
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
        }
      },
      itemBuilder: (context) => [
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
        const PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout, size: 18, color: AppColors.textSecondary),
              SizedBox(width: AppSpacing.xs),
              Text('Log out'),
            ],
          ),
        ),
      ],
      child: Container(
        width: 36,
        height: 36,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
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
