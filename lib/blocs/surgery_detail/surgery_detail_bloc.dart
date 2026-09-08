import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/error/exceptions.dart';
import '../../data/models/delay_response.dart';
import '../../data/models/surgery.dart';
import '../../data/services/surgery_service.dart';

part 'surgery_detail_event.dart';
part 'surgery_detail_state.dart';

/// Owns the Surgery Detail screen — loads a single surgery and drives
/// the surgeon's three state-transition actions: start, complete, delay.
///
/// The detail load hits `GET /surgeries/{id}` (which eager-loads the
/// `creator`), while the action endpoints return an updated surgery
/// (or, for delay, a wrapper with generated suggestions).
class SurgeryDetailBloc
    extends Bloc<SurgeryDetailEvent, SurgeryDetailState> {
  SurgeryDetailBloc({
    required SurgeryService surgeryService,
    required int surgeryId,
  })  : _surgeryService = surgeryService,
        _surgeryId = surgeryId,
        super(const SurgeryDetailState.initial()) {
    on<SurgeryDetailRequested>(_onRequested);
    on<SurgeryDetailStartRequested>(_onStart);
    on<SurgeryDetailCompleteRequested>(_onComplete);
    on<SurgeryDetailDelayRequested>(_onDelay);
    on<SurgeryDetailCancelRequested>(_onCancel);
  }

  final SurgeryService _surgeryService;
  final int _surgeryId;

  Future<void> _onRequested(
    SurgeryDetailRequested event,
    Emitter<SurgeryDetailState> emit,
  ) async {
    emit(state.copyWith(status: SurgeryDetailStatus.loading));
    try {
      final s = await _surgeryService.show(_surgeryId);
      emit(state.copyWith(
        status: SurgeryDetailStatus.loaded,
        surgery: s,
        clearError: true,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        status: SurgeryDetailStatus.error,
        errorMessage: e.message,
      ));
    }
  }

  Future<void> _onStart(
    SurgeryDetailStartRequested event,
    Emitter<SurgeryDetailState> emit,
  ) =>
      _runAction(emit, () => _surgeryService.start(_surgeryId));

  Future<void> _onComplete(
    SurgeryDetailCompleteRequested event,
    Emitter<SurgeryDetailState> emit,
  ) =>
      _runAction(emit, () => _surgeryService.complete(_surgeryId));

  Future<void> _onCancel(
    SurgeryDetailCancelRequested event,
    Emitter<SurgeryDetailState> emit,
  ) async {
    emit(state.copyWith(actionStatus: SurgeryActionStatus.running));
    try {
      await _surgeryService.cancel(_surgeryId);
      // Cancel returns just a message, so we reload to reflect the
      // server-side status transition.
      final s = await _surgeryService.show(_surgeryId);
      emit(state.copyWith(
        surgery: s,
        actionStatus: SurgeryActionStatus.idle,
        actionMessage: 'Surgery cancelled',
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        actionStatus: SurgeryActionStatus.error,
        actionMessage: e.message,
      ));
    }
  }

  Future<void> _onDelay(
    SurgeryDetailDelayRequested event,
    Emitter<SurgeryDetailState> emit,
  ) async {
    emit(state.copyWith(actionStatus: SurgeryActionStatus.running));
    try {
      final result = await _surgeryService.delay(_surgeryId);
      // Refresh to pick up the updated status; the DelayResponse doesn't
      // return the surgery itself.
      final s = await _surgeryService.show(_surgeryId);
      emit(state.copyWith(
        surgery: s,
        delayResponse: result,
        actionStatus: SurgeryActionStatus.idle,
        actionMessage: result.message,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        actionStatus: SurgeryActionStatus.error,
        actionMessage: e.message,
      ));
    }
  }

  Future<void> _runAction(
    Emitter<SurgeryDetailState> emit,
    Future<Surgery> Function() call,
  ) async {
    emit(state.copyWith(actionStatus: SurgeryActionStatus.running));
    try {
      final s = await call();
      emit(state.copyWith(
        surgery: s,
        actionStatus: SurgeryActionStatus.idle,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        actionStatus: SurgeryActionStatus.error,
        actionMessage: e.message,
      ));
    }
  }
}
