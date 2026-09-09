import 'package:equatable/equatable.dart';

import 'operating_room.dart';
import 'surgery.dart';

/// GET /api/rooms/{room}/surgeries response — full surgery history/
/// schedule for one room within a date range. Unlike `/api/surgeries`
/// or the calendar endpoint, each surgery here has no nested `room`
/// (it would just repeat the top-level [room]).
class RoomSurgeriesResponse extends Equatable {
  final OperatingRoom room;
  final DateTime from;
  final DateTime to;
  final List<Surgery> surgeries;

  const RoomSurgeriesResponse({
    required this.room,
    required this.from,
    required this.to,
    required this.surgeries,
  });

  factory RoomSurgeriesResponse.fromJson(Map<String, dynamic> json) =>
      RoomSurgeriesResponse(
        room: OperatingRoom.fromJson(json['room'] as Map<String, dynamic>),
        from: DateTime.parse((json['from'] as String).replaceFirst(' ', 'T')),
        to: DateTime.parse((json['to'] as String).replaceFirst(' ', 'T')),
        surgeries: (json['surgeries'] as List<dynamic>)
            .map((e) => Surgery.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  @override
  List<Object?> get props => [room, from, to, surgeries];
}
