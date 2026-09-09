import 'package:equatable/equatable.dart';

/// A room's recurring weekly availability window (e.g. "Wednesdays
/// 08:00-16:00"). `dayOfWeek` follows the Carbon/PHP convention used by
/// the backend: 0 = Sunday .. 6 = Saturday.
class RoomSlot extends Equatable {
  final int id;
  final int roomId;
  final int dayOfWeek;
  final String startTime;
  final String endTime;

  const RoomSlot({
    required this.id,
    required this.roomId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
  });

  factory RoomSlot.fromJson(Map<String, dynamic> json) => RoomSlot(
        id: json['id'] as int,
        roomId: json['room_id'] as int,
        dayOfWeek: json['day_of_week'] as int,
        startTime: json['start_time'] as String,
        endTime: json['end_time'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'room_id': roomId,
        'day_of_week': dayOfWeek,
        'start_time': startTime,
        'end_time': endTime,
      };

  @override
  List<Object?> get props => [id, roomId, dayOfWeek, startTime, endTime];
}
