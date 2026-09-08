import 'package:equatable/equatable.dart';

import 'surgery.dart';

// GET /api/surgeries/calendar shape:
// { "from": "YYYY-MM-DD HH:mm:ss", "to": "YYYY-MM-DD HH:mm:ss",
//   "rooms": [ { "room_id": .., "room_name": "..", "surgeries": [ ... ] } ] }
//
// The from/to values are returned as "YYYY-MM-DD HH:mm:ss" (space-separated),
// NOT ISO-8601 — we parse them tolerantly.

class CalendarRoomGroup extends Equatable {
  final int roomId;
  final String roomName;
  final List<Surgery> surgeries;

  const CalendarRoomGroup({
    required this.roomId,
    required this.roomName,
    required this.surgeries,
  });

  factory CalendarRoomGroup.fromJson(Map<String, dynamic> json) =>
      CalendarRoomGroup(
        roomId: json['room_id'] as int,
        roomName: json['room_name'] as String,
        surgeries: (json['surgeries'] as List<dynamic>)
            .map((e) => Surgery.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  @override
  List<Object?> get props => [roomId, roomName, surgeries];
}

class CalendarResponse extends Equatable {
  final DateTime from;
  final DateTime to;
  final List<CalendarRoomGroup> rooms;

  const CalendarResponse({
    required this.from,
    required this.to,
    required this.rooms,
  });

  factory CalendarResponse.fromJson(Map<String, dynamic> json) =>
      CalendarResponse(
        from: DateTime.parse((json['from'] as String).replaceFirst(' ', 'T')),
        to: DateTime.parse((json['to'] as String).replaceFirst(' ', 'T')),
        rooms: (json['rooms'] as List<dynamic>)
            .map((e) => CalendarRoomGroup.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  @override
  List<Object?> get props => [from, to, rooms];
}
