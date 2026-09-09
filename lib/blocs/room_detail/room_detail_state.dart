part of 'room_detail_bloc.dart';

enum RoomDetailStatus { initial, loading, loaded, error }

enum RoomDetailRangeFilter { all, today, thisWeek, lastWeek, thisMonth, custom }

class RoomDetailState extends Equatable {
  const RoomDetailState({
    required this.status,
    required this.surgeries,
    required this.rangeFilter,
    this.room,
    this.customFrom,
    this.customTo,
    this.errorMessage,
    this.errorCode,
  });

  const RoomDetailState.initial()
      : status = RoomDetailStatus.initial,
        surgeries = const [],
        rangeFilter = RoomDetailRangeFilter.today,
        room = null,
        customFrom = null,
        customTo = null,
        errorMessage = null,
        errorCode = null;

  final RoomDetailStatus status;
  final OperatingRoom? room;
  final List<Surgery> surgeries;
  final RoomDetailRangeFilter rangeFilter;
  final DateTime? customFrom;
  final DateTime? customTo;
  final String? errorMessage;

  /// error_code paired with [errorMessage] — see error_code_l10n.dart.
  final String? errorCode;

  RoomDetailState copyWith({
    RoomDetailStatus? status,
    OperatingRoom? room,
    List<Surgery>? surgeries,
    RoomDetailRangeFilter? rangeFilter,
    DateTime? customFrom,
    DateTime? customTo,
    String? errorMessage,
    String? errorCode,
    bool clearError = false,
    // Without this, switching from Custom Range to any other filter
    // left the old customFrom/customTo sitting in state — harmless
    // for other filters (they don't read those fields), but confusing
    // if the coordinator re-opens the custom range picker afterward
    // and sees a stale range instead of a fresh one.
    bool clearCustomRange = false,
  }) {
    return RoomDetailState(
      status: status ?? this.status,
      room: room ?? this.room,
      surgeries: surgeries ?? this.surgeries,
      rangeFilter: rangeFilter ?? this.rangeFilter,
      customFrom: clearCustomRange ? null : (customFrom ?? this.customFrom),
      customTo: clearCustomRange ? null : (customTo ?? this.customTo),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      errorCode: clearError ? null : (errorCode ?? this.errorCode),
    );
  }

  @override
  List<Object?> get props => [
        status,
        room,
        surgeries,
        rangeFilter,
        customFrom,
        customTo,
        errorMessage,
        errorCode,
      ];
}
