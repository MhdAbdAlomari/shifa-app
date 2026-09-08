part of 'pick_manually_bloc.dart';

sealed class PickManuallyEvent extends Equatable {
  const PickManuallyEvent();

  @override
  List<Object?> get props => const [];
}

class PickManuallyRoomsRequested extends PickManuallyEvent {
  const PickManuallyRoomsRequested();
}

class PickManuallyRoomSelected extends PickManuallyEvent {
  const PickManuallyRoomSelected(this.roomId);

  final int roomId;

  @override
  List<Object?> get props => [roomId];
}

class PickManuallyStartSelected extends PickManuallyEvent {
  const PickManuallyStartSelected(this.scheduledStart);

  final DateTime scheduledStart;

  @override
  List<Object?> get props => [scheduledStart];
}

class PickManuallySubmitted extends PickManuallyEvent {
  const PickManuallySubmitted();
}
