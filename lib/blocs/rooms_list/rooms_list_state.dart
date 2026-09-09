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
    this.errorCode,
    this.deletingId,
    this.actionMessageCode,
    this.actionErrorMessage,
    this.actionErrorCode,
    this.saving = false,
  });

  const RoomsListState.initial()
      : status = RoomsListStatus.initial,
        rooms = const [],
        filter = RoomsListFilter.all,
        creating = false,
        errorMessage = null,
        errorCode = null,
        deletingId = null,
        actionMessageCode = null,
        actionErrorMessage = null,
        actionErrorCode = null,
        saving = false;

  final RoomsListStatus status;
  final List<OperatingRoom> rooms;
  final RoomsListFilter filter;
  final bool creating;
  final String? errorMessage;

  /// error_code paired with [errorMessage] — see error_code_l10n.dart.
  final String? errorCode;

  final int? deletingId;

  /// One-shot success toast code. UI maps it to translated text.
  final MessageCode? actionMessageCode;

  /// One-shot server error message (untranslated, from the API) shown
  /// as-is when a mutation fails.
  final String? actionErrorMessage;

  /// error_code paired with [actionErrorMessage] — see error_code_l10n.dart.
  final String? actionErrorCode;

  /// True while an edit-sheet update request is in flight.
  final bool saving;

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
    String? errorCode,
    int? deletingId,
    MessageCode? actionMessageCode,
    String? actionErrorMessage,
    String? actionErrorCode,
    bool? saving,
    bool clearError = false,
    bool clearDeletingId = false,
    bool clearActionMessageCode = false,
    bool clearActionErrorMessage = false,
  }) {
    return RoomsListState(
      status: status ?? this.status,
      rooms: rooms ?? this.rooms,
      filter: filter ?? this.filter,
      creating: creating ?? this.creating,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      errorCode: clearError ? null : (errorCode ?? this.errorCode),
      deletingId: clearDeletingId ? null : (deletingId ?? this.deletingId),
      actionMessageCode: clearActionMessageCode
          ? null
          : (actionMessageCode ?? this.actionMessageCode),
      actionErrorMessage: clearActionErrorMessage
          ? null
          : (actionErrorMessage ?? this.actionErrorMessage),
      actionErrorCode: clearActionErrorMessage
          ? null
          : (actionErrorCode ?? this.actionErrorCode),
      saving: saving ?? this.saving,
    );
  }

  @override
  List<Object?> get props => [
        status,
        rooms,
        filter,
        creating,
        errorMessage,
        errorCode,
        deletingId,
        actionMessageCode,
        actionErrorMessage,
        actionErrorCode,
        saving,
      ];
}
