import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/error/exceptions.dart';
import '../../core/l10n/message_code.dart';
import '../../data/models/patient.dart';
import '../../data/services/patient_service.dart';

part 'patients_list_event.dart';
part 'patients_list_state.dart';

/// Owns the Patients list — admin + coordinator. Loads via `GET
/// /patients`, supports server-side search (debounced), create,
/// update, and delete.
class PatientsListBloc extends Bloc<PatientsListEvent, PatientsListState> {
  PatientsListBloc({required PatientService patientService})
      : _patientService = patientService,
        super(const PatientsListState.initial()) {
    on<PatientsListRequested>(_onRequested);
    on<PatientsListRefreshRequested>(_onRefresh);
    on<PatientsListSearchChanged>(
      _onSearchChanged,
      transformer: _debounceRestartable(const Duration(milliseconds: 350)),
    );
    on<PatientsListDeleteRequested>(_onDelete);
    on<PatientsListCreateRequested>(_onCreate);
    on<PatientsListUpdateRequested>(_onUpdate);
  }

  final PatientService _patientService;

  Future<void> _onRequested(
    PatientsListRequested event,
    Emitter<PatientsListState> emit,
  ) async {
    emit(state.copyWith(status: PatientsListStatus.loading));
    await _load(emit, state.query);
  }

  Future<void> _onRefresh(
    PatientsListRefreshRequested event,
    Emitter<PatientsListState> emit,
  ) async {
    await _load(emit, state.query);
  }

  Future<void> _onSearchChanged(
    PatientsListSearchChanged event,
    Emitter<PatientsListState> emit,
  ) async {
    emit(state.copyWith(query: event.query));
    await _load(emit, event.query);
  }

  Future<void> _load(Emitter<PatientsListState> emit, String query) async {
    try {
      final patients = await _patientService.list(search: query);
      emit(state.copyWith(
        status: PatientsListStatus.loaded,
        patients: patients,
        clearError: true,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        status: PatientsListStatus.error,
        errorMessage: e.message,
        errorCode: e.errorCode,
      ));
    }
  }

  Future<void> _onDelete(
    PatientsListDeleteRequested event,
    Emitter<PatientsListState> emit,
  ) async {
    emit(state.copyWith(deletingId: event.id));
    try {
      await _patientService.delete(event.id);
      emit(state.copyWith(
        patients: state.patients.where((p) => p.id != event.id).toList(),
        clearDeletingId: true,
        actionMessageCode: MessageCode.patientDeleted,
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
    PatientsListCreateRequested event,
    Emitter<PatientsListState> emit,
  ) async {
    emit(state.copyWith(saving: true));
    try {
      final created = await _patientService.create(
        name: event.name,
        mrn: event.mrn,
        medicalNotes: event.medicalNotes,
      );
      emit(state.copyWith(
        patients: [...state.patients, created],
        saving: false,
        actionMessageCode: MessageCode.patientAdded,
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
    PatientsListUpdateRequested event,
    Emitter<PatientsListState> emit,
  ) async {
    emit(state.copyWith(saving: true));
    try {
      final updated = await _patientService.update(
        event.id,
        name: event.name,
        mrn: event.mrn,
        medicalNotes: event.medicalNotes,
        clearMedicalNotes: event.medicalNotes == null,
      );
      emit(state.copyWith(
        patients: [
          for (final p in state.patients) p.id == updated.id ? updated : p,
        ],
        saving: false,
        actionMessageCode: MessageCode.patientUpdated,
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

/// Cancels any in-flight debounce timer when a newer search event
/// arrives, so only the last keystroke's query actually hits the API.
EventTransformer<E> _debounceRestartable<E>(Duration duration) {
  return (events, mapper) => events
      .transform(_Debounce<E>(duration))
      .asyncExpand(mapper);
}

class _Debounce<E> extends StreamTransformerBase<E, E> {
  _Debounce(this.duration);
  final Duration duration;

  @override
  Stream<E> bind(Stream<E> stream) {
    StreamController<E>? controller;
    Timer? timer;
    controller = StreamController<E>(
      onListen: () {
        stream.listen(
          (event) {
            timer?.cancel();
            timer = Timer(duration, () => controller!.add(event));
          },
          onError: controller!.addError,
          onDone: () {
            timer?.cancel();
            controller!.close();
          },
        );
      },
    );
    return controller.stream;
  }
}
