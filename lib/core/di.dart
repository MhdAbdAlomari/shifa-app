import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth/auth_bloc.dart';
import '../data/services/auth_service.dart';
import '../data/services/dashboard_service.dart';
import '../data/services/notification_service.dart';
import '../data/services/patient_service.dart';
import '../data/services/room_service.dart';
import '../data/services/schedule_suggestion_service.dart';
import '../data/services/staff_service.dart';
import '../data/services/surgery_service.dart';
import '../data/services/surgery_type_service.dart';
import 'network/auth_token_storage.dart';
import 'network/dio_client.dart';

/// Composition root for the app.
///
/// A tiny hand-rolled DI container — no `get_it`, no `injectable`. For a
/// project of this size the extra machinery pays for itself only in tests,
/// and we can inject fakes into these constructors just as easily.
///
/// The container is built once in `main`, then handed to `MultiRepositoryProvider`
/// / `MultiBlocProvider` at the top of the widget tree.
class AppContainer {
  AppContainer._({
    required this.tokenStorage,
    required this.dioClient,
    required this.authService,
    required this.roomService,
    required this.staffService,
    required this.dashboardService,
    required this.patientService,
    required this.surgeryService,
    required this.scheduleSuggestionService,
    required this.surgeryTypeService,
    required this.notificationService,
  });

  factory AppContainer.production() {
    final tokenStorage = AuthTokenStorage();
    final dioClient = DioClient(tokenStorage: tokenStorage);
    return AppContainer._(
      tokenStorage: tokenStorage,
      dioClient: dioClient,
      authService: AuthService(dioClient, tokenStorage: tokenStorage),
      roomService: RoomService(dioClient),
      staffService: StaffService(dioClient),
      dashboardService: DashboardService(dioClient),
      patientService: PatientService(dioClient),
      surgeryService: SurgeryService(dioClient),
      scheduleSuggestionService: ScheduleSuggestionService(dioClient),
      surgeryTypeService: SurgeryTypeService(dioClient),
      notificationService: NotificationService(dioClient),
    );
  }

  final AuthTokenStorage tokenStorage;
  final DioClient dioClient;

  final AuthService authService;
  final RoomService roomService;
  final StaffService staffService;
  final DashboardService dashboardService;
  final PatientService patientService;
  final SurgeryService surgeryService;
  final ScheduleSuggestionService scheduleSuggestionService;
  final SurgeryTypeService surgeryTypeService;
  final NotificationService notificationService;

  /// The app-wide [AuthBloc]. Exposed as a factory so the widget tree
  /// takes ownership of its lifecycle via [BlocProvider].
  AuthBloc buildAuthBloc() =>
      AuthBloc(authService: authService, tokenStorage: tokenStorage)
        ..add(const AuthStartupRequested());
}
