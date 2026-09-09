import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_colors.dart';
import '../data/models/user_role.dart';
import '../l10n/generated/app_localizations.dart';

/// A single navigation destination — a route name and the icon/label
/// that represents it in the bottom bar.
class NavDestination {
  const NavDestination({
    required this.routeName,
    required this.icon,
    required this.label,
  });

  final String routeName;
  final IconData icon;
  final String label;
}

/// Role-aware bottom navigation. Each role sees only screens they can
/// actually reach; the reference's uniform 3-tab bar was explicitly
/// rejected in the spec because it would expose forbidden screens.
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.role,
    required this.currentRouteName,
  });

  final UserRole role;
  final String currentRouteName;

  List<NavDestination> _destinationsFor(UserRole role, AppLocalizations l10n) {
    final settings = NavDestination(
      routeName: 'settings',
      icon: Icons.settings_outlined,
      label: l10n.navSettings,
    );
    final alerts = NavDestination(
      routeName: 'notifications',
      icon: Icons.notifications_outlined,
      label: l10n.navAlerts,
    );
    return switch (role) {
      UserRole.admin => [
          NavDestination(
            routeName: 'admin.rooms',
            icon: Icons.meeting_room_outlined,
            label: l10n.navRooms,
          ),
          NavDestination(
            routeName: 'manage',
            icon: Icons.dashboard_customize_outlined,
            label: l10n.navManage,
          ),
          alerts,
          settings,
        ],
      // Coordinator has no dedicated Settings tab — a 6th tab would
      // overcrowd the bar. Settings is reachable as a tile inside
      // Manage instead (see ManageScreen), one tap away.
      UserRole.coordinator => [
          NavDestination(
            routeName: 'coordinator.timeline',
            icon: Icons.meeting_room_outlined,
            label: l10n.navRooms,
          ),
          NavDestination(
            routeName: 'coordinator.suggestions',
            icon: Icons.auto_awesome_outlined,
            label: l10n.navSuggestions,
          ),
          NavDestination(
            routeName: 'coordinator.schedule',
            icon: Icons.add_circle_outline,
            label: l10n.navSchedule,
          ),
          NavDestination(
            routeName: 'manage',
            icon: Icons.dashboard_customize_outlined,
            label: l10n.navManage,
          ),
          alerts,
        ],
      UserRole.surgeon => [
          NavDestination(
            routeName: 'surgeon.mySurgeries',
            icon: Icons.medical_services_outlined,
            label: l10n.navSurgeries,
          ),
          alerts,
          settings,
        ],
    };
  }

  @override
  Widget build(BuildContext context) {
    final destinations = _destinationsFor(role, AppLocalizations.of(context));
    final currentIndex = destinations.indexWhere(
      (d) => d.routeName == currentRouteName,
    );
    // currentRouteName may not be a member of this role's destination set
    // (e.g. coordinators reach Settings via a tile inside Manage rather
    // than a dedicated tab) — fall back to highlighting Manage in that
    // case instead of silently defaulting to the first tab.
    final manageIndex = destinations.indexWhere((d) => d.routeName == 'manage');
    final selectedIndex = currentIndex >= 0
        ? currentIndex
        : (manageIndex >= 0 ? manageIndex : 0);

    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) {
        final target = destinations[index];
        if (target.routeName != currentRouteName) {
          context.goNamed(target.routeName);
        }
      },
      backgroundColor: AppColors.surface,
      indicatorColor: AppColors.statusFreeBg,
      surfaceTintColor: Colors.transparent,
      destinations: [
        for (final d in destinations)
          NavigationDestination(
            icon: Icon(d.icon, color: AppColors.textSecondary),
            selectedIcon: Icon(d.icon, color: AppColors.primary),
            label: d.label,
          ),
      ],
    );
  }
}
