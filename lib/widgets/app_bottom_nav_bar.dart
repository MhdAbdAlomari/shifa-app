import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_colors.dart';
import '../data/models/user_role.dart';

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

  static const _adminDestinations = <NavDestination>[
    NavDestination(
      routeName: 'admin.rooms',
      icon: Icons.meeting_room_outlined,
      label: 'Rooms',
    ),
    NavDestination(
      routeName: 'admin.staff',
      icon: Icons.people_outline,
      label: 'Staff',
    ),
    NavDestination(
      routeName: 'notifications',
      icon: Icons.notifications_outlined,
      label: 'Alerts',
    ),
  ];

  static const _coordinatorDestinations = <NavDestination>[
    NavDestination(
      routeName: 'coordinator.timeline',
      icon: Icons.meeting_room_outlined,
      label: 'Rooms',
    ),
    NavDestination(
      routeName: 'coordinator.suggestions',
      icon: Icons.auto_awesome_outlined,
      label: 'Suggestions',
    ),
    NavDestination(
      routeName: 'coordinator.schedule',
      icon: Icons.add_circle_outline,
      label: 'Schedule',
    ),
    NavDestination(
      routeName: 'notifications',
      icon: Icons.notifications_outlined,
      label: 'Alerts',
    ),
  ];

  static const _surgeonDestinations = <NavDestination>[
    NavDestination(
      routeName: 'surgeon.mySurgeries',
      icon: Icons.medical_services_outlined,
      label: 'Surgeries',
    ),
    NavDestination(
      routeName: 'notifications',
      icon: Icons.notifications_outlined,
      label: 'Alerts',
    ),
  ];

  List<NavDestination> _destinationsFor(UserRole role) {
    return switch (role) {
      UserRole.admin => _adminDestinations,
      UserRole.coordinator => _coordinatorDestinations,
      UserRole.surgeon => _surgeonDestinations,
    };
  }

  @override
  Widget build(BuildContext context) {
    final destinations = _destinationsFor(role);
    final currentIndex = destinations.indexWhere(
      (d) => d.routeName == currentRouteName,
    );

    return NavigationBar(
      selectedIndex: currentIndex < 0 ? 0 : currentIndex,
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
