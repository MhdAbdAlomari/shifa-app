import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/error/exceptions.dart';
import '../../data/models/operating_room.dart';
import '../../data/models/patient.dart';
import '../../data/models/schedule_proposal.dart';
import '../../data/models/surgery_draft.dart';
import '../../data/models/surgery_type.dart';
import '../../data/models/user.dart';
import '../../data/models/user_role.dart';
import '../../data/services/patient_service.dart';
import '../../data/services/room_service.dart';
import '../../data/services/staff_service.dart';
import '../../data/services/surgery_service.dart';
import '../../data/services/surgery_type_service.dart';

part 'auto_schedule_review_event.dart';
part 'auto_schedule_review_state.dart';

/// Owns the Auto-Schedule flow.
///
/// The flow has three phases the UI walks the user through:
///
///   1. **Compose** — build a list of pending requests (patient, surgeon,
///      type, priority) with no scheduling info.
///   2. **Review** — send that list to `POST /surgeries/auto-schedule` and
///      display the server's proposals (room + start time picked for each).
///   3. **Confirm** — for every proposal the user accepts, call
///      `POST /surgeries` to persist it. Rejected proposals are simply
///      dropped from local state.
///
/// The Bloc holds phase in [AutoScheduleReviewState.phase] so the screen
/// can switch between compose and review UIs with a single BlocBuilder.
class AutoScheduleReviewBloc
    extends Bloc<AutoScheduleReviewEvent, AutoScheduleReviewState> {
  AutoScheduleReviewBloc({
    required PatientService patientService,
    required StaffService staffService,
    required RoomService roomService,
    required SurgeryTypeService surgeryTypeService,
    required SurgeryService surgeryService,
    this.seedDraft,
  })  : _patientService = patientService,
        _staffService = staffService,
        _roomService = roomService,
        _surgeryTypeService = surgeryTypeService,
        _surgeryService = surgeryService,
        super(const AutoScheduleReviewState.initial()) {
    on<AutoScheduleReviewOptionsRequested>(_onLoadOptions);
    on<AutoScheduleReviewPendingAdded>(_onPendingAdded);
    on<AutoScheduleReviewPendingRemoved>(_onPendingRemoved);
    on<AutoScheduleReviewProposalsRequested>(_onProposalsRequested);
    on<AutoScheduleReviewProposalRejected>(_onProposalRejected);
    on<AutoScheduleReviewProposalAccepted>(_onProposalAccepted);
    on<AutoScheduleReviewReset>(_onReset);
  }

  final PatientService _patientService;
  final StaffService _staffService;
  final RoomService _roomService;
  final SurgeryTypeService _surgeryTypeService;
  final SurgeryService _surgeryService;

  /// Optional handoff from Schedule Surgery's Auto-schedule CTA. When
  /// present, the Bloc pre-loads the pending list with this single item
  /// and immediately requests proposals — the user only sees the review
  /// UI, not the compose UI.
  final SurgeryDraft? seedDraft;

  Future<void> _onLoadOptions(
    AutoScheduleReviewOptionsRequested event,
    Emitter<AutoScheduleReviewState> emit,
  ) async {
    emit(state.copyWith(loadStatus: AutoScheduleLoadStatus.loading));
    try {
      final results = await Future.wait([
        _patientService.list(),
        _staffService.list(),
        _roomService.list(),
        _surgeryTypeService.list(),
      ]);
      emit(state.copyWith(
        loadStatus: AutoScheduleLoadStatus.loaded,
        patients: results[0] as List<Patient>,
        surgeons: (results[1] as List<User>)
            .where((u) => u.role == UserRole.surgeon)
            .toList(),
        rooms: results[2] as List<OperatingRoom>,
        surgeryTypes: results[3] as List<SurgeryType>,
        pending: seedDraft == null
            ? state.pending
            : [
                PendingSurgeryRequest(
                  patientId: seedDraft!.patientId,
                  surgeonId: seedDraft!.surgeonId,
                  surgeryTypeId: seedDraft!.surgeryTypeId,
                  priority: seedDraft!.priority,
                ),
              ],
      ));
      // Seeded flows skip the compose UI and go straight to review.
      if (seedDraft != null) {
        add(const AutoScheduleReviewProposalsRequested());
      }
    } on ApiException catch (e) {
      emit(state.copyWith(
        loadStatus: AutoScheduleLoadStatus.error,
        errorMessage: e.message,
        errorCode: e.errorCode,
      ));
    }
  }

  void _onPendingAdded(
    AutoScheduleReviewPendingAdded event,
    Emitter<AutoScheduleReviewState> emit,
  ) {
    emit(state.copyWith(
      pending: [...state.pending, event.request],
    ));
  }

  void _onPendingRemoved(
    AutoScheduleReviewPendingRemoved event,
    Emitter<AutoScheduleReviewState> emit,
  ) {
    final next = [...state.pending]..removeAt(event.index);
    emit(state.copyWith(pending: next));
  }

  Future<void> _onProposalsRequested(
    AutoScheduleReviewProposalsRequested event,
    Emitter<AutoScheduleReviewState> emit,
  ) async {
    if (state.pending.isEmpty) return;
    emit(state.copyWith(
      submitStatus: AutoScheduleSubmitStatus.submitting,
      clearError: true,
    ));
    try {
      final proposals = await _surgeryService.autoSchedule(state.pending);
      emit(state.copyWith(
        submitStatus: AutoScheduleSubmitStatus.idle,
        proposals: proposals,
        // Track "which proposals are still awaiting a decision" as a
        // parallel index set — cheaper than mutating the [proposals]
        // list every time the user accepts/rejects one.
        openProposalIndexes: {for (var i = 0; i < proposals.length; i++) i},
        phase: AutoSchedulePhase.review,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        submitStatus: AutoScheduleSubmitStatus.error,
        submitErrorMessage: e.message,
        submitErrorCode: e.errorCode,
      ));
    }
  }

  void _onProposalRejected(
    AutoScheduleReviewProposalRejected event,
    Emitter<AutoScheduleReviewState> emit,
  ) {
    final next = {...state.openProposalIndexes}..remove(event.index);
    emit(state.copyWith(openProposalIndexes: next));
  }

  Future<void> _onProposalAccepted(
    AutoScheduleReviewProposalAccepted event,
    Emitter<AutoScheduleReviewState> emit,
  ) async {
    final proposal = state.proposals[event.index];
    emit(state.copyWith(acceptingIndex: event.index));
    try {
      await _surgeryService.create(
        patientId: proposal.patientId,
        surgeonId: proposal.surgeonId,
        roomId: proposal.roomId,
        surgeryTypeId: proposal.surgeryTypeId,
        priority: proposal.priority,
        scheduledStart: proposal.scheduledStart,
        estimatedDurationMin: proposal.estimatedDurationMin,
      );
      final next = {...state.openProposalIndexes}..remove(event.index);
      emit(state.copyWith(
        openProposalIndexes: next,
        acceptedCount: state.acceptedCount + 1,
        clearAcceptingIndex: true,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        submitErrorMessage: e.message,
        submitErrorCode: e.errorCode,
        clearAcceptingIndex: true,
      ));
    }
  }

  void _onReset(
    AutoScheduleReviewReset event,
    Emitter<AutoScheduleReviewState> emit,
  ) {
    emit(state.copyWith(
      phase: AutoSchedulePhase.compose,
      pending: const [],
      proposals: const [],
      openProposalIndexes: const {},
      acceptedCount: 0,
      clearError: true,
      clearSubmitError: true,
    ));
  }
}
