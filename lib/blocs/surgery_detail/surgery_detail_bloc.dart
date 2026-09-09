import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/error/exceptions.dart';
import '../../core/l10n/message_code.dart';
import '../../data/models/delay_response.dart';
import '../../data/models/surgery.dart';
import '../../data/services/surgery_service.dart';

part 'surgery_detail_event.dart';
part 'surgery_detail_state.dart';

/// Owns the Surgery Detail screen — loads a single surgery and drives
/// the surgeon's state-transition actions: start, complete, delay
/// (coordinators instead get a Cancel action; both share this Bloc,
/// see the screen's role-branching).
///
/// The detail load hits `GET /surgeries/{id}` (which eager-loads the
/// `creator`), while the action endpoints return an updated surgery —
/// except delay, whose response shape now depends on the outcome (see
/// [DelayResponse]).
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
        errorCode: e.errorCode,
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
        actionMessageCode: MessageCode.surgeryCancelled,
        clearActionErrorMessage: true,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        actionStatus: SurgeryActionStatus.error,
        actionErrorMessage: e.message,
        actionErrorCode: e.errorCode,
        clearActionMessageCode: true,
      ));
    }
  }

  Future<void> _onDelay(
    SurgeryDetailDelayRequested event,
    Emitter<SurgeryDetailState> emit,
  ) async {
    emit(state.copyWith(
      actionStatus: SurgeryActionStatus.running,
      delayFormErrors: const {},
      clearDelayResponse: true,
    ));
    try {
      final result = await _surgeryService.delay(
        _surgeryId,
        newExpectedEnd: event.newExpectedEnd,
        reason: event.reason,
      );
      // Auto-approved: the response already carries the updated
      // surgery, no need to reload. Pending review: the surgery is
      // untouched server-side (still in_progress), so keep the copy
      // we already have rather than firing a redundant GET.
      emit(state.copyWith(
        surgery: result.surgery ?? state.surgery,
        delayResponse: result,
        actionStatus: SurgeryActionStatus.idle,
        clearActionMessageCode: true,
        clearActionErrorMessage: true,
      ));
    } on ValidationException catch (e) {
      emit(state.copyWith(
        actionStatus: SurgeryActionStatus.error,
        delayFormErrors: e.errors,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        actionStatus: SurgeryActionStatus.error,
        actionErrorMessage: e.message,
        actionErrorCode: e.errorCode,
        clearActionMessageCode: true,
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
        actionErrorMessage: e.message,
        actionErrorCode: e.errorCode,
        clearActionMessageCode: true,
      ));
    }
  }
}
