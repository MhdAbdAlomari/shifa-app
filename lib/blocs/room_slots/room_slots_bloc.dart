import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/error/exceptions.dart';
import '../../core/l10n/message_code.dart';
import '../../data/models/room_slot.dart';
import '../../data/services/room_slot_service.dart';

part 'room_slots_event.dart';
part 'room_slots_state.dart';

/// Owns the Room Availability Slots sub-screen for one room.
class RoomSlotsBloc extends Bloc<RoomSlotsEvent, RoomSlotsState> {
  RoomSlotsBloc({
    required RoomSlotService roomSlotService,
    required int roomId,
  })  : _roomSlotService = roomSlotService,
        _roomId = roomId,
        super(const RoomSlotsState.initial()) {
    on<RoomSlotsRequested>(_onRequested);
    on<RoomSlotsCreateRequested>(_onCreate);
    on<RoomSlotsDeleteRequested>(_onDelete);
  }

  final RoomSlotService _roomSlotService;
  final int _roomId;

  Future<void> _onRequested(
    RoomSlotsRequested event,
    Emitter<RoomSlotsState> emit,
  ) async {
    emit(state.copyWith(status: RoomSlotsStatus.loading));
    try {
      final slots = await _roomSlotService.list(_roomId);
      emit(state.copyWith(
        status: RoomSlotsStatus.loaded,
        slots: slots,
        clearError: true,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        status: RoomSlotsStatus.error,
        errorMessage: e.message,
        errorCode: e.errorCode,
      ));
    }
  }

  Future<void> _onCreate(
    RoomSlotsCreateRequested event,
    Emitter<RoomSlotsState> emit,
  ) async {
    emit(state.copyWith(saving: true, formErrors: const {}));
    try {
      final created = await _roomSlotService.create(
        _roomId,
        dayOfWeek: event.dayOfWeek,
        startTime: event.startTime,
        endTime: event.endTime,
      );
      emit(state.copyWith(
        slots: [...state.slots, created],
        saving: false,
        actionMessageCode: MessageCode.slotAdded,
        clearActionErrorMessage: true,
      ));
    } on ValidationException catch (e) {
      emit(state.copyWith(saving: false, formErrors: e.errors));
    } on ApiException catch (e) {
      emit(state.copyWith(
        saving: false,
        actionErrorMessage: e.message,
        actionErrorCode: e.errorCode,
        clearActionMessageCode: true,
      ));
    }
  }

  Future<void> _onDelete(
    RoomSlotsDeleteRequested event,
    Emitter<RoomSlotsState> emit,
  ) async {
    emit(state.copyWith(deletingId: event.id));
    try {
      await _roomSlotService.delete(_roomId, event.id);
      emit(state.copyWith(
        slots: state.slots.where((s) => s.id != event.id).toList(),
        clearDeletingId: true,
        actionMessageCode: MessageCode.slotDeleted,
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
}
