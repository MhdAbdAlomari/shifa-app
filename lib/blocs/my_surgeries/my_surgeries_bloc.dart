import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/error/exceptions.dart';
import '../../core/l10n/message_code.dart';
import '../../data/models/surgery.dart';
import '../../data/services/surgery_service.dart';

part 'my_surgeries_event.dart';
part 'my_surgeries_state.dart';

/// Owns the surgeon's "My Surgeries" screen.
///
/// Loads via `GET /api/my-surgeries` and supports pull-to-refresh.
/// Also exposes an inline "Start" action for the Next-Up card — the
/// surgeon can start a scheduled case straight from the list without
/// navigating to Surgery Detail. A per-id `startingId` field lets the
/// UI spin only the tapped card.
class MySurgeriesBloc extends Bloc<MySurgeriesEvent, MySurgeriesState> {
  MySurgeriesBloc({required SurgeryService surgeryService})
      : _surgeryService = surgeryService,
        super(const MySurgeriesState.initial()) {
    on<MySurgeriesRequested>(_onRequested);
    on<MySurgeriesRefreshRequested>(_onRefresh);
    on<MySurgeryStartRequested>(_onStart);
  }

  final SurgeryService _surgeryService;

  Future<void> _onRequested(
    MySurgeriesRequested event,
    Emitter<MySurgeriesState> emit,
  ) async {
    emit(state.copyWith(status: MySurgeriesStatus.loading));
    await _load(emit);
  }

  Future<void> _onRefresh(
    MySurgeriesRefreshRequested event,
    Emitter<MySurgeriesState> emit,
  ) async {
    await _load(emit);
  }

  Future<void> _load(Emitter<MySurgeriesState> emit) async {
    try {
      final items = await _surgeryService.mySurgeries();
      emit(state.copyWith(
        status: MySurgeriesStatus.loaded,
        items: items,
        clearError: true,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        status: MySurgeriesStatus.error,
        errorMessage: e.message,
        errorCode: e.errorCode,
      ));
    }
  }

  Future<void> _onStart(
    MySurgeryStartRequested event,
    Emitter<MySurgeriesState> emit,
  ) async {
    emit(state.copyWith(startingId: event.id));
    try {
      final updated = await _surgeryService.start(event.id);
      // Replace in-place — cheaper than reloading the whole list, and
      // keeps the surgeon on the same scroll position.
      final next = [
        for (final s in state.items) s.id == updated.id ? updated : s,
      ];
      emit(state.copyWith(
        items: next,
        clearStartingId: true,
        actionMessageCode: MessageCode.surgeryStarted,
        clearActionErrorMessage: true,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        clearStartingId: true,
        actionErrorMessage: e.message,
        actionErrorCode: e.errorCode,
        clearActionMessageCode: true,
      ));
    }
  }
}
