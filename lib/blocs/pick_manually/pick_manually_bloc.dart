import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/error/exceptions.dart';
import '../../data/models/operating_room.dart';
import '../../data/models/surgery.dart';
import '../../data/models/surgery_draft.dart';
import '../../data/services/room_service.dart';
import '../../data/services/surgery_service.dart';

part 'pick_manually_event.dart';
part 'pick_manually_state.dart';

/// Stage 2 of the two-stage scheduling flow: pick a room + start time
/// for the [SurgeryDraft] handed in from stage 1, then POST it.
///
/// The Bloc holds the draft immutably (it was validated on stage 1);
/// it only owns the room list + user-selected room/start + submit state.
class PickManuallyBloc extends Bloc<PickManuallyEvent, PickManuallyState> {
  PickManuallyBloc({
    required RoomService roomService,
    required SurgeryService surgeryService,
    required SurgeryDraft draft,
  })  : _roomService = roomService,
        _surgeryService = surgeryService,
        super(PickManuallyState.initial(draft)) {
    on<PickManuallyRoomsRequested>(_onLoadRooms);
    on<PickManuallyRoomSelected>(_onRoomSelected);
    on<PickManuallyStartSelected>(_onStartSelected);
    on<PickManuallySubmitted>(_onSubmit);
  }

  final RoomService _roomService;
  final SurgeryService _surgeryService;

  Future<void> _onLoadRooms(
    PickManuallyRoomsRequested event,
    Emitter<PickManuallyState> emit,
  ) async {
    emit(state.copyWith(loadStatus: PickManuallyLoadStatus.loading));
    try {
      final rooms = await _roomService.list();
      emit(state.copyWith(
        loadStatus: PickManuallyLoadStatus.loaded,
        rooms: rooms,
        clearError: true,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        loadStatus: PickManuallyLoadStatus.error,
        errorMessage: e.message,
        errorCode: e.errorCode,
      ));
    }
  }

  void _onRoomSelected(
    PickManuallyRoomSelected event,
    Emitter<PickManuallyState> emit,
  ) {
    emit(state.copyWith(roomId: event.roomId));
  }

  void _onStartSelected(
    PickManuallyStartSelected event,
    Emitter<PickManuallyState> emit,
  ) {
    emit(state.copyWith(scheduledStart: event.scheduledStart));
  }

  Future<void> _onSubmit(
    PickManuallySubmitted event,
    Emitter<PickManuallyState> emit,
  ) async {
    if (!state.isReady) return;
    emit(state.copyWith(
      submitStatus: PickManuallySubmitStatus.submitting,
      clearSubmitError: true,
    ));
    try {
      final created = await _surgeryService.create(
        patientId: state.draft.patientId,
        surgeonId: state.draft.surgeonId,
        roomId: state.roomId!,
        surgeryTypeId: state.draft.surgeryTypeId,
        priority: state.draft.priority,
        scheduledStart: state.scheduledStart!,
        estimatedDurationMin: state.draft.estimatedDurationMin,
      );
      emit(state.copyWith(
        submitStatus: PickManuallySubmitStatus.success,
        created: created,
      ));
    } on ValidationException catch (e) {
      emit(state.copyWith(
        submitStatus: PickManuallySubmitStatus.failure,
        submitErrorMessage: e.message,
        submitErrorCode: e.errorCode,
        submitErrors: e.errors,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        submitStatus: PickManuallySubmitStatus.failure,
        submitErrorMessage: e.message,
        submitErrorCode: e.errorCode,
      ));
    }
  }
}
