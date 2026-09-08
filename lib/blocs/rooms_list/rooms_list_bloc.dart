import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/error/exceptions.dart';
import '../../data/models/operating_room.dart';
import '../../data/models/room_status.dart';
import '../../data/services/room_service.dart';

part 'rooms_list_event.dart';
part 'rooms_list_state.dart';

/// Owns the admin Rooms List screen.
///
/// Loads via `GET /rooms`, supports create + delete, and tracks the
/// active status filter (`All / Free / In use / Preparing / Cleaning`).
/// Filtering happens client-side: the API has no filter query parameter,
/// and the total room count is small enough that in-memory filtering is
/// both simpler and instantly responsive.
class RoomsListBloc extends Bloc<RoomsListEvent, RoomsListState> {
  RoomsListBloc({required RoomService roomService})
      : _roomService = roomService,
        super(const RoomsListState.initial()) {
    on<RoomsListRequested>(_onRequested);
    on<RoomsListRefreshRequested>(_onRefresh);
    on<RoomsListFilterChanged>(_onFilterChanged);
    on<RoomsListDeleteRequested>(_onDelete);
    on<RoomsListCreateRequested>(_onCreate);
  }

  final RoomService _roomService;

  Future<void> _onRequested(
    RoomsListRequested event,
    Emitter<RoomsListState> emit,
  ) async {
    emit(state.copyWith(status: RoomsListStatus.loading));
    await _load(emit);
  }

  Future<void> _onRefresh(
    RoomsListRefreshRequested event,
    Emitter<RoomsListState> emit,
  ) async {
    await _load(emit);
  }

  Future<void> _load(Emitter<RoomsListState> emit) async {
    try {
      final rooms = await _roomService.list();
      emit(state.copyWith(
        status: RoomsListStatus.loaded,
        rooms: rooms,
        clearError: true,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        status: RoomsListStatus.error,
        errorMessage: e.message,
      ));
    }
  }

  void _onFilterChanged(
    RoomsListFilterChanged event,
    Emitter<RoomsListState> emit,
  ) {
    emit(state.copyWith(filter: event.filter));
  }

  Future<void> _onDelete(
    RoomsListDeleteRequested event,
    Emitter<RoomsListState> emit,
  ) async {
    emit(state.copyWith(deletingId: event.id));
    try {
      await _roomService.delete(event.id);
      emit(state.copyWith(
        rooms: state.rooms.where((r) => r.id != event.id).toList(),
        clearDeletingId: true,
        actionMessage: 'Room deleted',
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        clearDeletingId: true,
        actionMessage: e.message,
      ));
    }
  }

  Future<void> _onCreate(
    RoomsListCreateRequested event,
    Emitter<RoomsListState> emit,
  ) async {
    emit(state.copyWith(creating: true));
    try {
      final created = await _roomService.create(
        name: event.name,
        status: event.status,
        supportedSpecialty: event.supportedSpecialty,
      );
      emit(state.copyWith(
        rooms: [...state.rooms, created],
        creating: false,
        actionMessage: 'Room added',
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        creating: false,
        actionMessage: e.message,
      ));
    }
  }
}
