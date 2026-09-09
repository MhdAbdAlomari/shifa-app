/// Canonical list of route names.
///
/// Every `context.goNamed(...)` and `GoRoute(name: ...)` in the app
/// reads from here — string literals in call sites become compile-time
/// errors when a route is renamed.
class AppRoutes {
  const AppRoutes._();

  static const String login = 'login';

  // Coordinator
  static const String coordinatorTimeline = 'coordinator.timeline';
  static const String coordinatorSchedule = 'coordinator.schedule';
  static const String coordinatorPickManually = 'coordinator.pickManually';
  static const String coordinatorAutoScheduleReview =
      'coordinator.autoScheduleReview';
  static const String coordinatorSuggestions = 'coordinator.suggestions';

  // Surgeon
  static const String surgeonMySurgeries = 'surgeon.mySurgeries';
  static const String surgeryDetail = 'surgery.detail';

  // Admin
  static const String adminRooms = 'admin.rooms';
  static const String adminStaff = 'admin.staff';

  // Shared (admin + coordinator)
  static const String manage = 'manage';
  static const String patients = 'patients';
  static const String surgeryTypes = 'surgeryTypes';
  static const String roomDetail = 'room.detail';
  static const String roomSlots = 'room.slots';

  // Shared (all roles)
  static const String notifications = 'notifications';
  static const String settings = 'settings';
  static const String settingsAbout = 'settings.about';
  static const String settingsPrivacy = 'settings.privacy';
  static const String settingsTerms = 'settings.terms';
}
