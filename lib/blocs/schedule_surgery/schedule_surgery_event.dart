part of 'schedule_surgery_bloc.dart';

sealed class ScheduleSurgeryEvent extends Equatable {
  const ScheduleSurgeryEvent();

  @override
  List<Object?> get props => const [];
}

class ScheduleSurgeryOptionsRequested extends ScheduleSurgeryEvent {
  const ScheduleSurgeryOptionsRequested();
}

/// Single event for every field. Fields not present in the event keep
/// their current value (see the `?? state.x` chain in the Bloc).
class ScheduleSurgeryFieldChanged extends ScheduleSurgeryEvent {
  const ScheduleSurgeryFieldChanged({
    this.patientId,
    this.surgeonId,
    this.surgeryTypeId,
    this.priority,
    this.estimatedDurationMin,
  });

  final int? patientId;
  final int? surgeonId;
  final int? surgeryTypeId;
  final SurgeryPriority? priority;
  final int? estimatedDurationMin;

  @override
  List<Object?> get props =>
      [patientId, surgeonId, surgeryTypeId, priority, estimatedDurationMin];
}
