part of 'room_timeline_bloc.dart';

enum RoomTimelineStatus { initial, loading, loaded, error }

/// One card's worth of data: the room itself, plus (optionally) the
/// case currently running in it, plus (optionally) the next scheduled
/// case. Screens decide which of the two to surface — current takes
/// precedence.
class RoomSnapshot extends Equatable {
  const RoomSnapshot({
    required this.room,
    required this.currentSurgery,
    required this.nextScheduled,
  });

  final OperatingRoom room;
  final Surgery? currentSurgery;
  final Surgery? nextScheduled;

  @override
  List<Object?> get props => [room, currentSurgery, nextScheduled];
}

class RoomTimelineState extends Equatable {
  const RoomTimelineState({
    required this.status,
    required this.snapshots,
    this.errorMessage,
  });

  const RoomTimelineState.initial()
      : status = RoomTimelineStatus.initial,
        snapshots = const [],
        errorMessage = null;

  final RoomTimelineStatus status;
  final List<RoomSnapshot> snapshots;
  final String? errorMessage;

  RoomTimelineState copyWith({
    RoomTimelineStatus? status,
    List<RoomSnapshot>? snapshots,
    String? errorMessage,
    bool clearError = false,
  }) {
    return RoomTimelineState(
      status: status ?? this.status,
      snapshots: snapshots ?? this.snapshots,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, snapshots, errorMessage];
}
