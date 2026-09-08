import 'package:equatable/equatable.dart';

import 'surgery_priority.dart';

// Item inside POST /api/surgeries/auto-schedule response `proposals` array.
// scheduled_start is returned as "YYYY-MM-DD HH:mm:ss" (space-separated), not ISO-8601.
class ScheduleProposal extends Equatable {
  final int patientId;
  final int surgeonId;
  final int surgeryTypeId;
  final SurgeryPriority priority;
  final int roomId;
  final DateTime scheduledStart;
  final int estimatedDurationMin;
  final String reason;

  const ScheduleProposal({
    required this.patientId,
    required this.surgeonId,
    required this.surgeryTypeId,
    required this.priority,
    required this.roomId,
    required this.scheduledStart,
    required this.estimatedDurationMin,
    required this.reason,
  });

  factory ScheduleProposal.fromJson(Map<String, dynamic> json) =>
      ScheduleProposal(
        patientId: json['patient_id'] as int,
        surgeonId: json['surgeon_id'] as int,
        surgeryTypeId: json['surgery_type_id'] as int,
        priority: SurgeryPriority.fromString(json['priority'] as String),
        roomId: json['room_id'] as int,
        scheduledStart: DateTime.parse(
            (json['scheduled_start'] as String).replaceFirst(' ', 'T')),
        estimatedDurationMin: json['estimated_duration_min'] as int,
        reason: json['reason'] as String,
      );

  @override
  List<Object?> get props => [
        patientId,
        surgeonId,
        surgeryTypeId,
        priority,
        roomId,
        scheduledStart,
        estimatedDurationMin,
        reason,
      ];
}

// Input item for POST /api/surgeries/auto-schedule.
class PendingSurgeryRequest extends Equatable {
  final int patientId;
  final int surgeonId;
  final int surgeryTypeId;
  final SurgeryPriority priority;

  const PendingSurgeryRequest({
    required this.patientId,
    required this.surgeonId,
    required this.surgeryTypeId,
    required this.priority,
  });

  Map<String, dynamic> toJson() => {
        'patient_id': patientId,
        'surgeon_id': surgeonId,
        'surgery_type_id': surgeryTypeId,
        'priority': priority.value,
      };

  @override
  List<Object?> get props => [patientId, surgeonId, surgeryTypeId, priority];
}
