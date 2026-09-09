import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/error/exceptions.dart';
import '../../core/l10n/message_code.dart';
import '../../data/models/user.dart';
import '../../data/models/user_role.dart';
import '../../data/services/staff_service.dart';

part 'staff_list_event.dart';
part 'staff_list_state.dart';

/// Owns the admin Staff List screen — loads via `GET /staff`, supports
/// create + delete, and filters client-side by role and free-text
/// search over name + specialty + email.
class StaffListBloc extends Bloc<StaffListEvent, StaffListState> {
  StaffListBloc({required StaffService staffService})
      : _staffService = staffService,
        super(const StaffListState.initial()) {
    on<StaffListRequested>(_onRequested);
    on<StaffListRefreshRequested>(_onRefresh);
    on<StaffListSearchChanged>(_onSearchChanged);
    on<StaffListFilterChanged>(_onFilterChanged);
    on<StaffListDeleteRequested>(_onDelete);
    on<StaffListCreateRequested>(_onCreate);
    on<StaffListUpdateRequested>(_onUpdate);
  }

  final StaffService _staffService;

  Future<void> _onRequested(
    StaffListRequested event,
    Emitter<StaffListState> emit,
  ) async {
    emit(state.copyWith(status: StaffListStatus.loading));
    await _load(emit);
  }

  Future<void> _onRefresh(
    StaffListRefreshRequested event,
    Emitter<StaffListState> emit,
  ) async {
    await _load(emit);
  }

  Future<void> _load(Emitter<StaffListState> emit) async {
    try {
      final users = await _staffService.list();
      emit(state.copyWith(
        status: StaffListStatus.loaded,
        users: users,
        clearError: true,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        status: StaffListStatus.error,
        errorMessage: e.message,
        errorCode: e.errorCode,
      ));
    }
  }

  void _onSearchChanged(
    StaffListSearchChanged event,
    Emitter<StaffListState> emit,
  ) {
    emit(state.copyWith(query: event.query));
  }

  void _onFilterChanged(
    StaffListFilterChanged event,
    Emitter<StaffListState> emit,
  ) {
    emit(state.copyWith(filter: event.filter));
  }

  Future<void> _onDelete(
    StaffListDeleteRequested event,
    Emitter<StaffListState> emit,
  ) async {
    emit(state.copyWith(deletingId: event.id));
    try {
      await _staffService.delete(event.id);
      emit(state.copyWith(
        users: state.users.where((u) => u.id != event.id).toList(),
        clearDeletingId: true,
        actionMessageCode: MessageCode.staffDeleted,
        clearActionErrorMessage: true,
      ));
    } on ApiException catch (e) {
      // FK-referenced deletes surface as a 500 or 422 — we let the
      // server's message reach the admin unchanged so they know why.
      emit(state.copyWith(
        clearDeletingId: true,
        actionErrorMessage: e.message,
        actionErrorCode: e.errorCode,
        clearActionMessageCode: true,
      ));
    }
  }

  Future<void> _onCreate(
    StaffListCreateRequested event,
    Emitter<StaffListState> emit,
  ) async {
    emit(state.copyWith(creating: true));
    try {
      final created = await _staffService.create(
        name: event.name,
        email: event.email,
        password: event.password,
        role: event.role,
        specialty: event.specialty,
      );
      emit(state.copyWith(
        users: [...state.users, created],
        creating: false,
        actionMessageCode: MessageCode.staffAdded,
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
    StaffListUpdateRequested event,
    Emitter<StaffListState> emit,
  ) async {
    emit(state.copyWith(saving: true, formErrors: const {}));
    try {
      final updated = await _staffService.update(
        event.id,
        name: event.name,
        email: event.email,
        password: event.password,
        role: event.role,
        specialty: event.specialty,
        clearSpecialty: event.specialty == null,
      );
      emit(state.copyWith(
        users: [
          for (final u in state.users) u.id == updated.id ? updated : u,
        ],
        saving: false,
        actionMessageCode: MessageCode.staffUpdated,
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
