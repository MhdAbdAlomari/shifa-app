part of 'staff_list_bloc.dart';

enum StaffListStatus { initial, loading, loaded, error }

/// User-selectable role filter. Strictly limited to real API roles
/// (`admin / coordinator / surgeon`) — the reference design's
/// "Anesthesiologist" / "Circulating Nurse" pills were fabricated for
/// visual richness and are omitted per the spec.
enum StaffListFilter { all, coordinator, surgeon }

class StaffListState extends Equatable {
  const StaffListState({
    required this.status,
    required this.users,
    required this.query,
    required this.filter,
    required this.creating,
    this.errorMessage,
    this.deletingId,
    this.actionMessage,
  });

  const StaffListState.initial()
      : status = StaffListStatus.initial,
        users = const [],
        query = '',
        filter = StaffListFilter.all,
        creating = false,
        errorMessage = null,
        deletingId = null,
        actionMessage = null;

  final StaffListStatus status;
  final List<User> users;
  final String query;
  final StaffListFilter filter;
  final bool creating;
  final String? errorMessage;
  final int? deletingId;
  final String? actionMessage;

  List<User> get visibleUsers {
    final byRole = switch (filter) {
      StaffListFilter.all => users,
      StaffListFilter.coordinator =>
        users.where((u) => u.role == UserRole.coordinator).toList(),
      StaffListFilter.surgeon =>
        users.where((u) => u.role == UserRole.surgeon).toList(),
    };
    if (query.trim().isEmpty) return byRole;
    final q = query.toLowerCase();
    return byRole
        .where((u) =>
            u.name.toLowerCase().contains(q) ||
            u.email.toLowerCase().contains(q) ||
            (u.specialty?.toLowerCase().contains(q) ?? false))
        .toList();
  }

  int countOf(StaffListFilter filter) {
    return switch (filter) {
      StaffListFilter.all => users.length,
      StaffListFilter.coordinator =>
        users.where((u) => u.role == UserRole.coordinator).length,
      StaffListFilter.surgeon =>
        users.where((u) => u.role == UserRole.surgeon).length,
    };
  }

  StaffListState copyWith({
    StaffListStatus? status,
    List<User>? users,
    String? query,
    StaffListFilter? filter,
    bool? creating,
    String? errorMessage,
    int? deletingId,
    String? actionMessage,
    bool clearError = false,
    bool clearDeletingId = false,
  }) {
    return StaffListState(
      status: status ?? this.status,
      users: users ?? this.users,
      query: query ?? this.query,
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
        users,
        query,
        filter,
        creating,
        errorMessage,
        deletingId,
        actionMessage,
      ];
}
