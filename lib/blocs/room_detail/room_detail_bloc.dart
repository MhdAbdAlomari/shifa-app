import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/error/exceptions.dart';
import '../../data/models/operating_room.dart';
import '../../data/models/surgery.dart';
import '../../data/services/room_service.dart';

part 'room_detail_event.dart';
part 'room_detail_state.dart';

/// Owns the Room Detail screen: the room itself plus every surgery
/// assigned to it within a date range, driven by `GET
/// /rooms/{room}/surgeries?from=&to=` — a full history/schedule view,
/// unlike Room Timeline's "now" snapshot.
class RoomDetailBloc extends Bloc<RoomDetailEvent, RoomDetailState> {
  RoomDetailBloc({
    required RoomService roomService,
    required int roomId,
  })  : _roomService = roomService,
        _roomId = roomId,
        super(const RoomDetailState.initial()) {
    on<RoomDetailRequested>(_onRequested);
    on<RoomDetailRangeChanged>(_onRangeChanged);
    on<RoomDetailRoomUpdated>(_onRoomUpdated);
  }

  final RoomService _roomService;
  final int _roomId;

  Future<void> _onRequested(
    RoomDetailRequested event,
    Emitter<RoomDetailState> emit,
  ) async {
    emit(state.copyWith(status: RoomDetailStatus.loading));
    await _load(emit, state.rangeFilter, state.customFrom, state.customTo);
  }

  Future<void> _onRangeChanged(
    RoomDetailRangeChanged event,
    Emitter<RoomDetailState> emit,
  ) async {
    emit(state.copyWith(
      status: RoomDetailStatus.loading,
      rangeFilter: event.filter,
      customFrom: event.customFrom,
      customTo: event.customTo,
      clearCustomRange: event.clearCustomRange,
    ));
    await _load(emit, event.filter, event.customFrom, event.customTo);
  }

  /// Fired after the Room Slots sub-screen or an image/edit action
  /// mutates the room out-of-band — keeps the header in sync without a
  /// full reload of the surgeries list.
  void _onRoomUpdated(
    RoomDetailRoomUpdated event,
    Emitter<RoomDetailState> emit,
  ) {
    emit(state.copyWith(room: event.room));
  }

  Future<void> _load(
    Emitter<RoomDetailState> emit,
    RoomDetailRangeFilter filter,
    DateTime? customFrom,
    DateTime? customTo,
  ) async {
    final (from, to) = _resolveRange(filter, customFrom, customTo);
    try {
      final res = await _roomService.surgeries(_roomId, from: from, to: to);
      emit(state.copyWith(
        status: RoomDetailStatus.loaded,
        room: res.room,
        surgeries: res.surgeries,
        clearError: true,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        status: RoomDetailStatus.error,
        errorMessage: e.message,
        errorCode: e.errorCode,
      ));
    }
  }

  (DateTime?, DateTime?) _resolveRange(
    RoomDetailRangeFilter filter,
    DateTime? customFrom,
    DateTime? customTo,
  ) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return switch (filter) {
      // The server has no real "unbounded" mode — omitting both from/to
      // just defaults to today (see the endpoint doc), so "All" sends
      // an explicit wide range instead of nulls.
      RoomDetailRangeFilter.all => (
          DateTime(today.year - 5),
          DateTime(today.year + 5),
        ),
      RoomDetailRangeFilter.today => (today, today),
      RoomDetailRangeFilter.thisWeek => (
          today.subtract(Duration(days: today.weekday % 7)),
          today.add(Duration(days: 6 - (today.weekday % 7))),
        ),
      RoomDetailRangeFilter.lastWeek => (
          today.subtract(Duration(days: today.weekday % 7 + 7)),
          today.subtract(Duration(days: today.weekday % 7 + 1)),
        ),
      RoomDetailRangeFilter.thisMonth => (
          DateTime(today.year, today.month, 1),
          DateTime(today.year, today.month + 1, 0),
        ),
      RoomDetailRangeFilter.custom => (customFrom, customTo),
    };
  }
}
