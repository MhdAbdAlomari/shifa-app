part of 'room_slots_bloc.dart';

sealed class RoomSlotsEvent extends Equatable {
  const RoomSlotsEvent();

  @override
  List<Object?> get props => const [];
}

class RoomSlotsRequested extends RoomSlotsEvent {
  const RoomSlotsRequested();
}

class RoomSlotsCreateRequested extends RoomSlotsEvent {
  const RoomSlotsCreateRequested({
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
  });

  final int dayOfWeek;
  final String startTime;
  final String endTime;

  @override
  List<Object?> get props => [dayOfWeek, startTime, endTime];
}

class RoomSlotsDeleteRequested extends RoomSlotsEvent {
  const RoomSlotsDeleteRequested(this.id);

  final int id;

  @override
  List<Object?> get props => [id];
}
