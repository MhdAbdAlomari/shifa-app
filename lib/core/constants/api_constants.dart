class ApiConstants {
  ApiConstants._();

  // Localhost (iOS simulator, desktop, web). For the Android emulator, swap
  // 127.0.0.1 for 10.0.2.2 — the emulator maps that to the host machine.
  static const String baseUrl = 'http://192.168.1.104:8000/api';

  // Auth
  static const String register = '/register';
  static const String login = '/login';
  static const String logout = '/logout';
  static const String me = '/me';

  // Admin
  static const String rooms = '/rooms';
  static String room(int id) => '/rooms/$id';
  static const String staff = '/staff';
  static String staffMember(int id) => '/staff/$id';
  static const String dashboardStats = '/dashboard/stats';

  // Coordinator
  static const String patients = '/patients';
  static String patient(int id) => '/patients/$id';
  static const String surgeries = '/surgeries';
  static String surgery(int id) => '/surgeries/$id';
  static const String surgeriesCalendar = '/surgeries/calendar';
  static const String surgeriesAutoSchedule = '/surgeries/auto-schedule';
  static const String scheduleSuggestions = '/schedule-suggestions';
  static String scheduleSuggestionAccept(int id) =>
      '/schedule-suggestions/$id/accept';
  static String scheduleSuggestionReject(int id) =>
      '/schedule-suggestions/$id/reject';

  // Surgeon
  static const String mySurgeries = '/my-surgeries';
  static String surgeryStart(int id) => '/surgeries/$id/start';
  static String surgeryComplete(int id) => '/surgeries/$id/complete';
  static String surgeryDelay(int id) => '/surgeries/$id/delay';

  // Shared
  static const String surgeryTypes = '/surgery-types';
  static const String notifications = '/notifications';
  static String notificationRead(int id) => '/notifications/$id/read';
}
