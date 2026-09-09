import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/error/exceptions.dart';
import '../../core/l10n/message_code.dart';
import '../../data/models/operating_room.dart';
import '../../data/models/surgery_type.dart';
import '../../data/services/room_service.dart';
import '../../data/services/surgery_type_service.dart';

part 'surgery_types_list_event.dart';
part 'surgery_types_list_state.dart';

/// Owns the Surgery Types list — admin + coordinator. Loads surgery
/// types via `GET /surgery-types` and rooms via `GET /rooms` (needed
/// to resolve/pick a `default_room_id`), in parallel. Supports create,
/// update, delete.
class SurgeryTypesListBloc
    extends Bloc<SurgeryTypesListEvent, SurgeryTypesListState> {
  SurgeryTypesListBloc({
    required SurgeryTypeService surgeryTypeService,
    required RoomService roomService,
  })  : _surgeryTypeService = surgeryTypeService,
        _roomService = roomService,
        super(const SurgeryTypesListState.initial()) {
    on<SurgeryTypesListRequested>(_onRequested);
    on<SurgeryTypesListRefreshRequested>(_onRefresh);
    on<SurgeryTypesListDeleteRequested>(_onDelete);
    on<SurgeryTypesListCreateRequested>(_onCreate);
    on<SurgeryTypesListUpdateRequested>(_onUpdate);
  }

  final SurgeryTypeService _surgeryTypeService;
  final RoomService _roomService;

  Future<void> _onRequested(
    SurgeryTypesListRequested event,
    Emitter<SurgeryTypesListState> emit,
  ) async {
    emit(state.copyWith(status: SurgeryTypesListStatus.loading));
    await _load(emit);
  }

  Future<void> _onRefresh(
    SurgeryTypesListRefreshRequested event,
    Emitter<SurgeryTypesListState> emit,
  ) async {
    await _load(emit);
  }

  Future<void> _load(Emitter<SurgeryTypesListState> emit) async {
    try {
      final results = await Future.wait<Object>([
        _surgeryTypeService.list(),
        _roomService.list(),
      ]);
      emit(state.copyWith(
        status: SurgeryTypesListStatus.loaded,
        surgeryTypes: results[0] as List<SurgeryType>,
        rooms: results[1] as List<OperatingRoom>,
        clearError: true,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        status: SurgeryTypesListStatus.error,
        errorMessage: e.message,
        errorCode: e.errorCode,
      ));
    }
  }

  Future<void> _onDelete(
    SurgeryTypesListDeleteRequested event,
    Emitter<SurgeryTypesListState> emit,
  ) async {
    emit(state.copyWith(deletingId: event.id));
    try {
      await _surgeryTypeService.delete(event.id);
      emit(state.copyWith(
        surgeryTypes:
            state.surgeryTypes.where((t) => t.id != event.id).toList(),
        clearDeletingId: true,
        actionMessageCode: MessageCode.surgeryTypeDeleted,
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
    SurgeryTypesListCreateRequested event,
    Emitter<SurgeryTypesListState> emit,
  ) async {
    emit(state.copyWith(saving: true));
    try {
      final created = await _surgeryTypeService.create(
        name: event.name,
        averageDurationMin: event.averageDurationMin,
        requiredSpecialty: event.requiredSpecialty,
        defaultRoomId: event.defaultRoomId,
      );
      emit(state.copyWith(
        surgeryTypes: [...state.surgeryTypes, created],
        saving: false,
        actionMessageCode: MessageCode.surgeryTypeAdded,
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

  Future<void> _onUpdate(
    SurgeryTypesListUpdateRequested event,
    Emitter<SurgeryTypesListState> emit,
  ) async {
    emit(state.copyWith(saving: true));
    try {
      final updated = await _surgeryTypeService.update(
        event.id,
        name: event.name,
        averageDurationMin: event.averageDurationMin,
        requiredSpecialty: event.requiredSpecialty,
        defaultRoomId: event.defaultRoomId,
        clearDefaultRoomId: event.defaultRoomId == null,
      );
      emit(state.copyWith(
        surgeryTypes: [
          for (final t in state.surgeryTypes)
            t.id == updated.id ? updated : t,
        ],
        saving: false,
        actionMessageCode: MessageCode.surgeryTypeUpdated,
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
}
