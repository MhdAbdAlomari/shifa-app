import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/error/exceptions.dart';
import '../../data/models/patient.dart';
import '../../data/models/surgery_priority.dart';
import '../../data/models/surgery_type.dart';
import '../../data/models/user.dart';
import '../../data/models/user_role.dart';
import '../../data/services/patient_service.dart';
import '../../data/services/staff_service.dart';
import '../../data/services/surgery_type_service.dart';

part 'schedule_surgery_event.dart';
part 'schedule_surgery_state.dart';

/// Owns Schedule Surgery — **stage 1** of the two-stage scheduling flow.
///
/// Stage 1 collects patient / surgeon / surgery type / priority. It
/// does NOT submit or pick a room+time; instead it hands off to either:
///
///   - Auto-schedule (`POST /surgeries/auto-schedule` with this one
///     pending item — the screen navigates to the Auto-Schedule review
///     screen, seeded with this draft).
///   - Pick manually — navigates to [PickManuallyScreen] with the
///     draft, where the coordinator chooses a room and start time and
///     the actual `POST /surgeries` happens.
class ScheduleSurgeryBloc
    extends Bloc<ScheduleSurgeryEvent, ScheduleSurgeryState> {
  ScheduleSurgeryBloc({
    required PatientService patientService,
    required StaffService staffService,
    required SurgeryTypeService surgeryTypeService,
  })  : _patientService = patientService,
        _staffService = staffService,
        _surgeryTypeService = surgeryTypeService,
        super(const ScheduleSurgeryState.initial()) {
    on<ScheduleSurgeryOptionsRequested>(_onLoadOptions);
    on<ScheduleSurgeryFieldChanged>(_onFieldChanged);
  }

  final PatientService _patientService;
  final StaffService _staffService;
  final SurgeryTypeService _surgeryTypeService;

  Future<void> _onLoadOptions(
    ScheduleSurgeryOptionsRequested event,
    Emitter<ScheduleSurgeryState> emit,
  ) async {
    emit(state.copyWith(loadStatus: ScheduleSurgeryLoadStatus.loading));
    try {
      // Load pickers in parallel — the three endpoints are independent.
      final results = await Future.wait<Object>([
        _patientService.list(),
        _staffService.list(),
        _surgeryTypeService.list(),
      ]);
      emit(state.copyWith(
        loadStatus: ScheduleSurgeryLoadStatus.loaded,
        patients: results[0] as List<Patient>,
        surgeons: (results[1] as List<User>)
            .where((u) => u.role == UserRole.surgeon)
            .toList(),
        surgeryTypes: results[2] as List<SurgeryType>,
        clearError: true,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        loadStatus: ScheduleSurgeryLoadStatus.error,
        errorMessage: e.message,
      ));
    }
  }

  void _onFieldChanged(
    ScheduleSurgeryFieldChanged event,
    Emitter<ScheduleSurgeryState> emit,
  ) {
    emit(state.copyWith(
      patientId: event.patientId ?? state.patientId,
      surgeonId: event.surgeonId ?? state.surgeonId,
      surgeryTypeId: event.surgeryTypeId ?? state.surgeryTypeId,
      priority: event.priority ?? state.priority,
    ));
  }
}
