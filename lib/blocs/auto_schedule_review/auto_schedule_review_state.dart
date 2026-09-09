part of 'auto_schedule_review_bloc.dart';

enum AutoScheduleLoadStatus { initial, loading, loaded, error }

enum AutoScheduleSubmitStatus { idle, submitting, error }

enum AutoSchedulePhase { compose, review }

class AutoScheduleReviewState extends Equatable {
  const AutoScheduleReviewState({
    required this.loadStatus,
    required this.submitStatus,
    required this.phase,
    required this.patients,
    required this.surgeons,
    required this.rooms,
    required this.surgeryTypes,
    required this.pending,
    required this.proposals,
    required this.openProposalIndexes,
    required this.acceptedCount,
    this.acceptingIndex,
    this.errorMessage,
    this.errorCode,
    this.submitErrorMessage,
    this.submitErrorCode,
  });

  const AutoScheduleReviewState.initial()
      : loadStatus = AutoScheduleLoadStatus.initial,
        submitStatus = AutoScheduleSubmitStatus.idle,
        phase = AutoSchedulePhase.compose,
        patients = const [],
        surgeons = const [],
        rooms = const [],
        surgeryTypes = const [],
        pending = const [],
        proposals = const [],
        openProposalIndexes = const {},
        acceptedCount = 0,
        acceptingIndex = null,
        errorMessage = null,
        errorCode = null,
        submitErrorMessage = null,
        submitErrorCode = null;

  final AutoScheduleLoadStatus loadStatus;
  final AutoScheduleSubmitStatus submitStatus;
  final AutoSchedulePhase phase;

  final List<Patient> patients;
  final List<User> surgeons;
  final List<OperatingRoom> rooms;
  final List<SurgeryType> surgeryTypes;

  final List<PendingSurgeryRequest> pending;
  final List<ScheduleProposal> proposals;
  final Set<int> openProposalIndexes;
  final int acceptedCount;
  final int? acceptingIndex;

  final String? errorMessage;

  /// error_code paired with [errorMessage] — see error_code_l10n.dart.
  final String? errorCode;

  final String? submitErrorMessage;

  /// error_code paired with [submitErrorMessage] — see error_code_l10n.dart.
  final String? submitErrorCode;

  AutoScheduleReviewState copyWith({
    AutoScheduleLoadStatus? loadStatus,
    AutoScheduleSubmitStatus? submitStatus,
    AutoSchedulePhase? phase,
    List<Patient>? patients,
    List<User>? surgeons,
    List<OperatingRoom>? rooms,
    List<SurgeryType>? surgeryTypes,
    List<PendingSurgeryRequest>? pending,
    List<ScheduleProposal>? proposals,
    Set<int>? openProposalIndexes,
    int? acceptedCount,
    int? acceptingIndex,
    String? errorMessage,
    String? errorCode,
    String? submitErrorMessage,
    String? submitErrorCode,
    bool clearError = false,
    bool clearSubmitError = false,
    bool clearAcceptingIndex = false,
  }) {
    return AutoScheduleReviewState(
      loadStatus: loadStatus ?? this.loadStatus,
      submitStatus: submitStatus ?? this.submitStatus,
      phase: phase ?? this.phase,
      patients: patients ?? this.patients,
      surgeons: surgeons ?? this.surgeons,
      rooms: rooms ?? this.rooms,
      surgeryTypes: surgeryTypes ?? this.surgeryTypes,
      pending: pending ?? this.pending,
      proposals: proposals ?? this.proposals,
      openProposalIndexes: openProposalIndexes ?? this.openProposalIndexes,
      acceptedCount: acceptedCount ?? this.acceptedCount,
      acceptingIndex: clearAcceptingIndex
          ? null
          : (acceptingIndex ?? this.acceptingIndex),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      errorCode: clearError ? null : (errorCode ?? this.errorCode),
      submitErrorMessage: clearSubmitError
          ? null
          : (submitErrorMessage ?? this.submitErrorMessage),
      submitErrorCode: clearSubmitError
          ? null
          : (submitErrorCode ?? this.submitErrorCode),
    );
  }

  @override
  List<Object?> get props => [
        loadStatus,
        submitStatus,
        phase,
        patients,
        surgeons,
        rooms,
        surgeryTypes,
        pending,
        proposals,
        openProposalIndexes,
        acceptedCount,
        acceptingIndex,
        errorMessage,
        errorCode,
        submitErrorMessage,
        submitErrorCode,
      ];
}
