class ApiConstants {
  ApiConstants._();

  // Localhost (iOS simulator, desktop, web). For the Android emulator, swap
  // 127.0.0.1 for 10.0.2.2 — the emulator maps that to the host machine.
  static const String baseUrl = 'http://192.168.1.104:8000/api';

  /// Scheme+host+port the API is actually reachable at (derived from
  /// [baseUrl], minus the `/api` path) — used to rewrite `image_url`
  /// values that come back pointing at a DIFFERENT host (e.g. the
  /// backend's `APP_URL` is `http://localhost:8000`, which resolves to
  /// nothing on a physical device or any machine other than the
  /// server itself). Without this, uploaded room photos silently fail
  /// to load everywhere except on the exact machine running the
  /// backend.
  static final Uri _apiOrigin = Uri.parse(baseUrl).replace(
    path: '',
    query: '',
  );

  /// Rewrites [url]'s scheme/host/port to match [_apiOrigin] while
  /// preserving its path — returns null unchanged if [url] is null.
  static String? resolveMediaUrl(String? url) {
    if (url == null || url.isEmpty) return url;
    final parsed = Uri.tryParse(url);
    if (parsed == null || !parsed.hasAuthority) return url;
    return parsed
        .replace(
          scheme: _apiOrigin.scheme,
          host: _apiOrigin.host,
          port: _apiOrigin.port,
        )
        .toString();
  }

  // Auth
  static const String register = '/register';
  static const String login = '/login';
  static const String logout = '/logout';
  static const String me = '/me';

  // Admin / coordinator
  static const String rooms = '/rooms';
  static String room(int id) => '/rooms/$id';
  static String roomSurgeries(int id) => '/rooms/$id/surgeries';
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
