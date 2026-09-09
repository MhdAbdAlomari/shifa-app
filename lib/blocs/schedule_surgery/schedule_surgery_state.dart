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
    this.estimatedDurationMin,
    this.errorMessage,
    this.errorCode,
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
        estimatedDurationMin = null,
        errorMessage = null,
        errorCode = null;

  final ScheduleSurgeryLoadStatus loadStatus;

  final List<Patient> patients;
  final List<User> surgeons;
  final List<SurgeryType> surgeryTypes;

  final int? patientId;
  final int? surgeonId;
  final int? surgeryTypeId;
  final SurgeryPriority? priority;

  /// Editable duration, pre-filled from the selected surgery type's
  /// `average_duration_min` when the type changes, but overridable by
  /// the coordinator before submitting.
  final int? estimatedDurationMin;

  final String? errorMessage;

  /// error_code paired with [errorMessage] — see error_code_l10n.dart.
  final String? errorCode;

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
    int? estimatedDurationMin,
    String? errorMessage,
    String? errorCode,
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
      estimatedDurationMin: estimatedDurationMin ?? this.estimatedDurationMin,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      errorCode: clearError ? null : (errorCode ?? this.errorCode),
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
        estimatedDurationMin,
        errorMessage,
        errorCode,
      ];
}
