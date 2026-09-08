part of 'schedule_surgery_bloc.dart';

enum ScheduleSurgeryLoadStatus { initial, loading, loaded, error }

class ScheduleSurgeryState extends Equatable {
  const ScheduleSurgeryState({
    required this.loadStatus,
    required this.patients,
    required this.surgeons,
    required this.surgeryTypes,
    this.patientId,
    this.surgeonId,
    this.surgeryTypeId,
    this.priority,
    this.errorMessage,
  });

  const ScheduleSurgeryState.initial()
      : loadStatus = ScheduleSurgeryLoadStatus.initial,
        patients = const [],
        surgeons = const [],
        surgeryTypes = const [],
        patientId = null,
        surgeonId = null,
        surgeryTypeId = null,
        priority = null,
        errorMessage = null;

  final ScheduleSurgeryLoadStatus loadStatus;

  final List<Patient> patients;
  final List<User> surgeons;
  final List<SurgeryType> surgeryTypes;

  final int? patientId;
  final int? surgeonId;
  final int? surgeryTypeId;
  final SurgeryPriority? priority;

  final String? errorMessage;

  /// Screen enables both CTAs (Auto-schedule / Pick manually) only when
  /// all four required fields are filled.
  bool get isReady =>
      patientId != null &&
      surgeonId != null &&
      surgeryTypeId != null &&
      priority != null;

  ScheduleSurgeryState copyWith({
    ScheduleSurgeryLoadStatus? loadStatus,
    List<Patient>? patients,
    List<User>? surgeons,
    List<SurgeryType>? surgeryTypes,
    int? patientId,
    int? surgeonId,
    int? surgeryTypeId,
    SurgeryPriority? priority,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ScheduleSurgeryState(
      loadStatus: loadStatus ?? this.loadStatus,
      patients: patients ?? this.patients,
      surgeons: surgeons ?? this.surgeons,
      surgeryTypes: surgeryTypes ?? this.surgeryTypes,
      patientId: patientId ?? this.patientId,
      surgeonId: surgeonId ?? this.surgeonId,
      surgeryTypeId: surgeryTypeId ?? this.surgeryTypeId,
      priority: priority ?? this.priority,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        loadStatus,
        patients,
        surgeons,
        surgeryTypes,
        patientId,
        surgeonId,
        surgeryTypeId,
        priority,
        errorMessage,
      ];
}
