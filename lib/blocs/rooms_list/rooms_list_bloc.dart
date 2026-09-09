import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/error/exceptions.dart';
import '../../core/l10n/message_code.dart';
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
    on<RoomsListUpdateRequested>(_onUpdate);
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
        errorCode: e.errorCode,
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
        actionMessageCode: MessageCode.roomDeleted,
        clearActionErrorMessage: true,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        clearDeletingId: true,
        actionErrorMessage: e.message,
        actionErrorCode: e.errorCode,
        clearActionMessageCode: true,
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
        imageBytes: event.imageBytes,
        imageFilename: event.imageFilename,
      );
      emit(state.copyWith(
        rooms: [...state.rooms, created],
        creating: false,
        actionMessageCode: MessageCode.roomAdded,
        clearActionErrorMessage: true,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        creating: false,
        actionErrorMessage: e.message,
        actionErrorCode: e.errorCode,
        clearActionMessageCode: true,
      ));
    }
  }

  Future<void> _onUpdate(
    RoomsListUpdateRequested event,
    Emitter<RoomsListState> emit,
  ) async {
    emit(state.copyWith(saving: true));
    try {
      final updated = await _roomService.update(
        event.id,
        name: event.name,
        status: event.status,
        supportedSpecialty: event.supportedSpecialty,
        imageBytes: event.imageBytes,
        imageFilename: event.imageFilename,
      );
      emit(state.copyWith(
        rooms: [
          for (final r in state.rooms) r.id == updated.id ? updated : r,
        ],
        saving: false,
        actionMessageCode: MessageCode.roomUpdated,
        clearActionErrorMessage: true,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        saving: false,
        actionErrorMessage: e.message,
        actionErrorCode: e.errorCode,
        clearActionMessageCode: true,
      ));
    }
  }
}
