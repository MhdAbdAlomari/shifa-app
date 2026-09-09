import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../widgets/app_bottom_nav_bar.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_header.dart';

/// Hub screen for admin/coordinator management destinations that don't
/// fit as individual bottom-nav tabs: operating rooms, staff, patients,
/// and surgery types. Reached via the "Manage" tab.
class ManageScreen extends StatelessWidget {
  const ManageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthBloc>().state.user;
    if (user == null) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppHeader(subtitle: l10n.manageTitle),
      bottomNavigationBar: AppBottomNavBar(
        role: user.role,
        currentRouteName: AppRoutes.manage,
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screenEdge),
          children: [
            Text(l10n.manageTitle, style: AppTextStyles.headlineMd),
            const SizedBox(height: AppSpacing.xxs),
            Text(l10n.manageSubtitle, style: AppTextStyles.bodySm),
            const SizedBox(height: AppSpacing.md),
            _ManageTile(
              icon: Icons.meeting_room_outlined,
              title: l10n.roomsListTitle,
              subtitle: l10n.manageRoomsSubtitle,
              onTap: () => context.goNamed(AppRoutes.adminRooms),
            ),
            const SizedBox(height: AppSpacing.sm),
            _ManageTile(
              icon: Icons.people_outline,
              title: l10n.staffListTitle,
              subtitle: l10n.manageStaffSubtitle,
              onTap: () => context.goNamed(AppRoutes.adminStaff),
            ),
            const SizedBox(height: AppSpacing.sm),
            _ManageTile(
              icon: Icons.badge_outlined,
              title: l10n.patientsTitle,
              subtitle: l10n.managePatientsSubtitle,
              onTap: () => context.goNamed(AppRoutes.patients),
            ),
            const SizedBox(height: AppSpacing.sm),
            _ManageTile(
              icon: Icons.medical_services_outlined,
              title: l10n.surgeryTypesTitle,
              subtitle: l10n.manageSurgeryTypesSubtitle,
              onTap: () => context.goNamed(AppRoutes.surgeryTypes),
            ),
            const SizedBox(height: AppSpacing.sm),
            _ManageTile(
              icon: Icons.settings_outlined,
              title: l10n.settingsTitle,
              subtitle: l10n.subtitleSettings,
              onTap: () => context.pushNamed(AppRoutes.settings),
            ),
          ],
        ),
      ),
    );
  }
}

class _ManageTile extends StatelessWidget {
  const _ManageTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.statusFreeBg,
              borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.titleLg),
                Text(subtitle, style: AppTextStyles.bodySm),
              ],
            ),
          ),
          Icon(
            Directionality.of(context) == TextDirection.rtl
                ? Icons.chevron_left
                : Icons.chevron_right,
            color: AppColors.textDisabled,
          ),
        ],
      ),
    );
  }
}
