import 'package:equatable/equatable.dart';

import 'operating_room.dart';
import 'schedule_suggestion_status.dart';
import 'surgery.dart';

class ScheduleSuggestion extends Equatable {
  final int id;
  final int surgeryId;
  final int suggestedRoomId;
  final DateTime suggestedStart;
  final String reason;
  final ScheduleSuggestionStatus status;
  final DateTime createdAt;

  // Eager-loaded on GET /schedule-suggestions and POST /accept.
  // Absent on POST /reject and on delay-generated suggestions.
  final Surgery? surgery;
  final OperatingRoom? suggestedRoom;

  const ScheduleSuggestion({
    required this.id,
    required this.surgeryId,
    required this.suggestedRoomId,
    required this.suggestedStart,
    required this.reason,
    required this.status,
    required this.createdAt,
    this.surgery,
    this.suggestedRoom,
  });

  factory ScheduleSuggestion.fromJson(Map<String, dynamic> json) =>
      ScheduleSuggestion(
        id: json['id'] as int,
        surgeryId: json['surgery_id'] as int,
        suggestedRoomId: json['suggested_room_id'] as int,
        suggestedStart: DateTime.parse(json['suggested_start'] as String),
        reason: json['reason'] as String,
        status: ScheduleSuggestionStatus.fromString(json['status'] as String),
        createdAt: DateTime.parse(json['created_at'] as String),
        surgery: json['surgery'] is Map<String, dynamic>
            ? Surgery.fromJson(json['surgery'] as Map<String, dynamic>)
            : null,
        suggestedRoom: json['suggested_room'] is Map<String, dynamic>
            ? OperatingRoom.fromJson(
                json['suggested_room'] as Map<String, dynamic>)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'surgery_id': surgeryId,
        'suggested_room_id': suggestedRoomId,
        'suggested_start': suggestedStart.toUtc().toIso8601String(),
        'reason': reason,
        'status': status.value,
        'created_at': createdAt.toUtc().toIso8601String(),
        if (surgery != null) 'surgery': surgery!.toJson(),
        if (suggestedRoom != null) 'suggested_room': suggestedRoom!.toJson(),
      };

  @override
  List<Object?> get props => [
        id,
        surgeryId,
        suggestedRoomId,
        suggestedStart,
        reason,
        status,
        createdAt,
        surgery,
        suggestedRoom,
      ];
}
