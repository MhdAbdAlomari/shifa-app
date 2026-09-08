part of 'room_timeline_bloc.dart';

sealed class RoomTimelineEvent extends Equatable {
  const RoomTimelineEvent();

  @override
  List<Object?> get props => const [];
}

/// Fired on initial screen entry.
class RoomTimelineRequested extends RoomTimelineEvent {
  const RoomTimelineRequested();
}

/// Pull-to-refresh — silent reload.
class RoomTimelineRefreshRequested extends RoomTimelineEvent {
  const RoomTimelineRefreshRequested();
}
