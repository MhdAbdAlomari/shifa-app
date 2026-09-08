import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../data/models/surgery_draft.dart';
import '../../data/models/user_role.dart';
import '../../screens/admin/rooms_list_screen.dart';
import '../../screens/admin/staff_list_screen.dart';
import '../../screens/coordinator/auto_schedule_review_screen.dart';
import '../../screens/coordinator/pick_manually_screen.dart';
import '../../screens/coordinator/room_timeline_screen.dart';
import '../../screens/coordinator/schedule_suggestions_screen.dart';
import '../../screens/coordinator/schedule_surgery_screen.dart';
import '../../screens/login/login_screen.dart';
import '../../screens/notifications/notifications_screen.dart';
import '../../screens/surgeon/my_surgeries_screen.dart';
import '../../screens/surgeon/surgery_detail_screen.dart';
import '../theme/app_colors.dart';
import 'app_routes.dart';
import 'go_router_refresh_stream.dart';

/// Builds the app-wide [GoRouter].
///
/// Responsibilities:
///
///   1. **Route table** — declarative list of every reachable screen,
///      keyed by name (see [AppRoutes]).
///   2. **Auth-aware redirect** — reads the current [AuthState] and
///      rewrites navigation. Unauthenticated users can only reach
///      Login; authenticated users are bounced from Login to their
///      role's home screen.
///   3. **Role-aware redirect** — every non-shared route is gated to
///      a specific set of roles. If a signed-in user reaches a route
///      not in [_allowedRolesForPath] for their role, we redirect
///      them to their role's home rather than rendering the screen.
///      This is a defense-in-depth measure: the bottom nav already
///      excludes forbidden destinations by role, but stale routes
///      (hot reload, deep links, back-stack from a prior session)
///      can still land a user on the wrong path.
///
/// While the [AuthBloc] is still bootstrapping (`AuthStatus.unknown`)
/// we render an inline loading placeholder on whatever route is
/// active. This replaces the previous dedicated splash screen — one
/// less screen to maintain, and the effect is identical to the user.
GoRouter buildAppRouter(AuthBloc authBloc) {
  return GoRouter(
    initialLocation: '/login',
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) {
      final auth = authBloc.state;
      final loc = state.matchedLocation;

      // While auth is unknown we intentionally return null — the
      // active route's builder will render `_BootstrapPlaceholder`
      // below via a wrap, and once auth resolves the router fires the
      // refresh listenable and we re-evaluate.
      if (auth.status == AuthStatus.unknown) return null;

      final isLoggingIn = loc == '/login';

      if (auth.status == AuthStatus.unauthenticated) {
        return isLoggingIn ? null : '/login';
      }

      if (auth.status == AuthStatus.authenticated) {
        final role = auth.user!.role;
        if (isLoggingIn) return _homeFor(role);

        // Role guard — if the current location isn't reachable by this
        // role, bounce to that role's home. Shared routes (login,
        // notifications, surgery detail) return null from
        // `_allowedRolesForPath` and are always permitted.
        final allowed = _allowedRolesForPath(loc);
        if (allowed != null && !allowed.contains(role)) {
          return _homeFor(role);
        }
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: AppRoutes.login,
        builder: (context, _) =>
            _bootstrap(context, authBloc, const LoginScreen()),
      ),

      // Coordinator
      GoRoute(
        path: '/coordinator/timeline',
        name: AppRoutes.coordinatorTimeline,
        builder: (context, _) =>
            _bootstrap(context, authBloc, const RoomTimelineScreen()),
      ),
      GoRoute(
        path: '/coordinator/schedule',
        name: AppRoutes.coordinatorSchedule,
        builder: (context, _) =>
            _bootstrap(context, authBloc, const ScheduleSurgeryScreen()),
      ),
      GoRoute(
        path: '/coordinator/pick-manually',
        name: AppRoutes.coordinatorPickManually,
        builder: (context, state) {
          final draft = state.extra as SurgeryDraft;
          return _bootstrap(
            context,
            authBloc,
            PickManuallyScreen(draft: draft),
          );
        },
      ),
      GoRoute(
        path: '/coordinator/auto-schedule',
        name: AppRoutes.coordinatorAutoScheduleReview,
        builder: (context, state) {
          final seed = state.extra;
          return _bootstrap(
            context,
            authBloc,
            AutoScheduleReviewScreen(
              seedDraft: seed is SurgeryDraft ? seed : null,
            ),
          );
        },
      ),
      GoRoute(
        path: '/coordinator/suggestions',
        name: AppRoutes.coordinatorSuggestions,
        builder: (context, _) => _bootstrap(
          context,
          authBloc,
          const ScheduleSuggestionsScreen(),
        ),
      ),

      // Surgeon
      GoRoute(
        path: '/surgeon/my-surgeries',
        name: AppRoutes.surgeonMySurgeries,
        builder: (context, _) =>
            _bootstrap(context, authBloc, const MySurgeriesScreen()),
      ),
      GoRoute(
        path: '/surgery/:id',
        name: AppRoutes.surgeryDetail,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return _bootstrap(
            context,
            authBloc,
            SurgeryDetailScreen(surgeryId: id),
          );
        },
      ),

      // Admin
      GoRoute(
        path: '/admin/rooms',
        name: AppRoutes.adminRooms,
        builder: (context, _) =>
            _bootstrap(context, authBloc, const RoomsListScreen()),
      ),
      GoRoute(
        path: '/admin/staff',
        name: AppRoutes.adminStaff,
        builder: (context, _) =>
            _bootstrap(context, authBloc, const StaffListScreen()),
      ),

      // Shared
      GoRoute(
        path: '/notifications',
        name: AppRoutes.notifications,
        builder: (context, _) =>
            _bootstrap(context, authBloc, const NotificationsScreen()),
      ),
    ],
  );
}

/// Wraps a route builder so that while the [AuthBloc] is still
/// resolving the initial `/me` call, we show a plain loading screen
/// instead of the real page (which would try to read `user!` and
/// crash). Once auth resolves, the router refresh triggers a rebuild
/// via the [GoRouterRefreshStream].
Widget _bootstrap(BuildContext context, AuthBloc authBloc, Widget child) {
  if (authBloc.state.status == AuthStatus.unknown) {
    return const _BootstrapPlaceholder();
  }
  return child;
}

class _BootstrapPlaceholder extends StatelessWidget {
  const _BootstrapPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }
}

String _homeFor(UserRole role) {
  return switch (role) {
    UserRole.admin => '/admin/rooms',
    UserRole.coordinator => '/coordinator/timeline',
    UserRole.surgeon => '/surgeon/my-surgeries',
  };
}

/// Returns the set of roles permitted to view [location], or `null` if
/// the location is shared across all roles (in which case the guard
/// doesn't fire). Uses path prefixes so query strings and path
/// parameters don't affect the check.
///
/// Ordering matches the route table above — new routes must be added
/// here as well or the guard will treat them as "shared" by default.
Set<UserRole>? _allowedRolesForPath(String location) {
  if (location.startsWith('/admin/')) {
    return {UserRole.admin};
  }
  if (location.startsWith('/coordinator/')) {
    return {UserRole.coordinator};
  }
  if (location.startsWith('/surgeon/')) {
    return {UserRole.surgeon};
  }
  // Shared or auth-only routes (login, /notifications, /surgery/:id)
  // fall through as null — everyone who's authenticated can see them.
  return null;
}
