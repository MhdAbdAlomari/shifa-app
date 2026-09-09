part of 'room_detail_bloc.dart';

sealed class RoomDetailEvent extends Equatable {
  const RoomDetailEvent();

  @override
  List<Object?> get props => const [];
}

class RoomDetailRequested extends RoomDetailEvent {
  const RoomDetailRequested();
}

/// Fired when the coordinator/admin picks a different range chip, or
/// confirms a custom date range from the picker.
class RoomDetailRangeChanged extends RoomDetailEvent {
  const RoomDetailRangeChanged(
    this.filter, {
    this.customFrom,
    this.customTo,
    this.clearCustomRange = false,
  });

  final RoomDetailRangeFilter filter;
  final DateTime? customFrom;
  final DateTime? customTo;

  /// True when switching AWAY from Custom Range to a preset filter —
  /// drops the stale custom bounds so re-opening the date picker later
  /// starts fresh instead of showing the last custom selection.
  final bool clearCustomRange;

  @override
  List<Object?> get props =>
      [filter, customFrom, customTo, clearCustomRange];
}

class RoomDetailRoomUpdated extends RoomDetailEvent {
  const RoomDetailRoomUpdated(this.room);

  final OperatingRoom room;

  @override
  List<Object?> get props => [room];
}
