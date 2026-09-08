part of 'rooms_list_bloc.dart';

enum RoomsListStatus { initial, loading, loaded, error }

/// User-selectable filter across all rooms. `all` shows everything;
/// the four others correspond 1:1 to [RoomStatus]. Restricting the
/// UI to real API values (no invented categories) was an explicit
/// spec requirement.
enum RoomsListFilter { all, free, inUse, preparing, cleaning }

class RoomsListState extends Equatable {
  const RoomsListState({
    required this.status,
    required this.rooms,
    required this.filter,
    required this.creating,
    this.errorMessage,
    this.deletingId,
    this.actionMessage,
  });

  const RoomsListState.initial()
      : status = RoomsListStatus.initial,
        rooms = const [],
        filter = RoomsListFilter.all,
        creating = false,
        errorMessage = null,
        deletingId = null,
        actionMessage = null;

  final RoomsListStatus status;
  final List<OperatingRoom> rooms;
  final RoomsListFilter filter;
  final bool creating;
  final String? errorMessage;
  final int? deletingId;
  final String? actionMessage;

  /// Rooms matching the current [filter]. Not memoized — the list is
  /// small enough that filtering per rebuild costs nothing.
  List<OperatingRoom> get visibleRooms {
    return switch (filter) {
      RoomsListFilter.all => rooms,
      RoomsListFilter.free =>
        rooms.where((r) => r.status == RoomStatus.free).toList(),
      RoomsListFilter.inUse =>
        rooms.where((r) => r.status == RoomStatus.inUse).toList(),
      RoomsListFilter.preparing =>
        rooms.where((r) => r.status == RoomStatus.preparing).toList(),
      RoomsListFilter.cleaning =>
        rooms.where((r) => r.status == RoomStatus.cleaning).toList(),
    };
  }

  int countOf(RoomsListFilter filter) {
    if (filter == RoomsListFilter.all) return rooms.length;
    final needed = switch (filter) {
      RoomsListFilter.free => RoomStatus.free,
      RoomsListFilter.inUse => RoomStatus.inUse,
      RoomsListFilter.preparing => RoomStatus.preparing,
      RoomsListFilter.cleaning => RoomStatus.cleaning,
      RoomsListFilter.all => null,
    };
    return rooms.where((r) => r.status == needed).length;
  }

  RoomsListState copyWith({
    RoomsListStatus? status,
    List<OperatingRoom>? rooms,
    RoomsListFilter? filter,
    bool? creating,
    String? errorMessage,
    int? deletingId,
    String? actionMessage,
    bool clearError = false,
    bool clearDeletingId = false,
  }) {
    return RoomsListState(
      status: status ?? this.status,
      rooms: rooms ?? this.rooms,
      filter: filter ?? this.filter,
      creating: creating ?? this.creating,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      deletingId: clearDeletingId ? null : (deletingId ?? this.deletingId),
      actionMessage: actionMessage ?? this.actionMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        rooms,
        filter,
        creating,
        errorMessage,
        deletingId,
        actionMessage,
      ];
}
