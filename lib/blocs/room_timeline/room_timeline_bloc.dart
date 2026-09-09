import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/error/exceptions.dart';
import '../../data/models/calendar_response.dart';
import '../../data/models/operating_room.dart';
import '../../data/models/surgery.dart';
import '../../data/models/surgery_status.dart';
import '../../data/services/room_service.dart';
import '../../data/services/surgery_service.dart';

part 'room_timeline_event.dart';
part 'room_timeline_state.dart';

/// Owns the coordinator's Room Timeline screen — a "now" snapshot of
/// every operating room.
///
/// Each room is shown once. If a surgery is currently in progress in
/// that room, we render its patient + surgery type + end estimate.
/// Otherwise we surface the room's own status (Free / Preparing /
/// Cleaning). The Bloc loads the two lists in parallel (`GET /rooms`
/// and today's calendar via `GET /surgeries/calendar?from=today&to=today`)
/// and correlates them locally.
class RoomTimelineBloc extends Bloc<RoomTimelineEvent, RoomTimelineState> {
  RoomTimelineBloc({
    required RoomService roomService,
    required SurgeryService surgeryService,
  })  : _roomService = roomService,
        _surgeryService = surgeryService,
        super(const RoomTimelineState.initial()) {
    on<RoomTimelineRequested>(_onRequested);
    on<RoomTimelineRefreshRequested>(_onRefresh);
  }

  final RoomService _roomService;
  final SurgeryService _surgeryService;

  Future<void> _onRequested(
    RoomTimelineRequested event,
    Emitter<RoomTimelineState> emit,
  ) async {
    emit(state.copyWith(status: RoomTimelineStatus.loading));
    await _load(emit);
  }

  Future<void> _onRefresh(
    RoomTimelineRefreshRequested event,
    Emitter<RoomTimelineState> emit,
  ) async {
    // Silent refresh — keep the current snapshot on screen while the
    // network call is in flight so pull-to-refresh is the only signal.
    await _load(emit);
  }

  Future<void> _load(Emitter<RoomTimelineState> emit) async {
    try {
      final today = _startOfToday();
      final results = await Future.wait<Object>([
        _roomService.list(),
        _surgeryService.calendar(from: today, to: today),
      ]);
      final rooms = results[0] as List<OperatingRoom>;
      final calendar = results[1] as CalendarResponse;

      // Flatten today's surgeries out of the room-grouped calendar
      // structure and bucket them by room_id for O(1) lookup.
      final byRoom = <int, List<Surgery>>{};
      for (final group in calendar.rooms) {
        byRoom[group.roomId] = List<Surgery>.of(group.surgeries)
          ..sort((a, b) => a.scheduledStart.compareTo(b.scheduledStart));
      }

      final snapshots = [
        for (final room in rooms) _snapshotFor(room, byRoom[room.id] ?? const []),
      ];

      emit(state.copyWith(
        status: RoomTimelineStatus.loaded,
        snapshots: snapshots,
        clearError: true,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        status: RoomTimelineStatus.error,
        errorMessage: e.message,
        errorCode: e.errorCode,
      ));
    }
  }

  RoomSnapshot _snapshotFor(OperatingRoom room, List<Surgery> todaySurgeries) {
    // "Current surgery" = the first in-progress case in this room, if
    // any. Otherwise we surface the next scheduled case as a preview
    // (the header still shows the room's own status).
    Surgery? current;
    Surgery? nextScheduled;
    for (final s in todaySurgeries) {
      if (s.status == SurgeryStatus.inProgress && current == null) {
        current = s;
      }
      if (s.status == SurgeryStatus.scheduled && nextScheduled == null) {
        nextScheduled = s;
      }
    }
    return RoomSnapshot(
      room: room,
      currentSurgery: current,
      nextScheduled: nextScheduled,
    );
  }

  DateTime _startOfToday() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }
}
