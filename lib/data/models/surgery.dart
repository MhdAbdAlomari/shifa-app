import 'package:equatable/equatable.dart';

import 'operating_room.dart';
import 'patient.dart';
import 'surgery_priority.dart';
import 'surgery_status.dart';
import 'surgery_type.dart';
import 'user.dart';

class Surgery extends Equatable {
  final int id;
  final int patientId;
  final int surgeonId;
  final int roomId;
  final int surgeryTypeId;
  final int createdBy;
  final SurgeryPriority priority;
  final DateTime scheduledStart;
  // Computed server-side (scheduled_start + estimated_duration_min); not
  // present on every endpoint (e.g. /my-surgeries omits it) — null there.
  final DateTime? scheduledEnd;
  final int estimatedDurationMin;
  final DateTime? actualStart;
  final DateTime? actualEnd;
  final SurgeryStatus status;

  // Eager-loaded relations. May be absent depending on endpoint:
  //   - /api/surgeries and /api/surgeries/{surgery} include patient/surgeon/room/surgery_type
  //   - /api/surgeries/{surgery} additionally includes creator
  //   - /api/my-surgeries omits surgeon (implicit)
  //   - schedule-suggestion.surgery is a bare surgery with none of these
  final Patient? patient;
  final User? surgeon;
  final OperatingRoom? room;
  final SurgeryType? surgeryType;
  final User? creator;

  const Surgery({
    required this.id,
    required this.patientId,
    required this.surgeonId,
    required this.roomId,
    required this.surgeryTypeId,
    required this.createdBy,
    required this.priority,
    required this.scheduledStart,
    this.scheduledEnd,
    required this.estimatedDurationMin,
    required this.actualStart,
    required this.actualEnd,
    required this.status,
    this.patient,
    this.surgeon,
    this.room,
    this.surgeryType,
    this.creator,
  });

  factory Surgery.fromJson(Map<String, dynamic> json) => Surgery(
        id: json['id'] as int,
        patientId: json['patient_id'] as int,
        surgeonId: json['surgeon_id'] as int,
        roomId: json['room_id'] as int,
        surgeryTypeId: json['surgery_type_id'] as int,
        createdBy: json['created_by'] as int,
        priority: SurgeryPriority.fromString(json['priority'] as String),
        scheduledStart: DateTime.parse(json['scheduled_start'] as String),
        scheduledEnd: json['scheduled_end'] == null
            ? null
            : DateTime.parse(json['scheduled_end'] as String),
        estimatedDurationMin: json['estimated_duration_min'] as int,
        actualStart: json['actual_start'] == null
            ? null
            : DateTime.parse(json['actual_start'] as String),
        actualEnd: json['actual_end'] == null
            ? null
            : DateTime.parse(json['actual_end'] as String),
        status: SurgeryStatus.fromString(json['status'] as String),
        patient: json['patient'] is Map<String, dynamic>
            ? Patient.fromJson(json['patient'] as Map<String, dynamic>)
            : null,
        surgeon: json['surgeon'] is Map<String, dynamic>
            ? User.fromJson(json['surgeon'] as Map<String, dynamic>)
            : null,
        room: json['room'] is Map<String, dynamic>
            ? OperatingRoom.fromJson(json['room'] as Map<String, dynamic>)
            : null,
        surgeryType: json['surgery_type'] is Map<String, dynamic>
            ? SurgeryType.fromJson(
                json['surgery_type'] as Map<String, dynamic>)
            : null,
        creator: json['creator'] is Map<String, dynamic>
            ? User.fromJson(json['creator'] as Map<String, dynamic>)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'patient_id': patientId,
        'surgeon_id': surgeonId,
        'room_id': roomId,
        'surgery_type_id': surgeryTypeId,
        'created_by': createdBy,
        'priority': priority.value,
        'scheduled_start': scheduledStart.toUtc().toIso8601String(),
        if (scheduledEnd != null)
          'scheduled_end': scheduledEnd!.toUtc().toIso8601String(),
        'estimated_duration_min': estimatedDurationMin,
        'actual_start': actualStart?.toUtc().toIso8601String(),
        'actual_end': actualEnd?.toUtc().toIso8601String(),
        'status': status.value,
        if (patient != null) 'patient': patient!.toJson(),
        if (surgeon != null) 'surgeon': surgeon!.toJson(),
        if (room != null) 'room': room!.toJson(),
        if (surgeryType != null) 'surgery_type': surgeryType!.toJson(),
        if (creator != null) 'creator': creator!.toJson(),
      };

  @override
  List<Object?> get props => [
        id,
        patientId,
        surgeonId,
        roomId,
        surgeryTypeId,
        createdBy,
        priority,
        scheduledStart,
        scheduledEnd,
        estimatedDurationMin,
        actualStart,
        actualEnd,
        status,
        patient,
        surgeon,
        room,
        surgeryType,
        creator,
      ];
}
