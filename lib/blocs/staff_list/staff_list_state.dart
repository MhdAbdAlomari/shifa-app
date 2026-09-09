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
    this.errorCode,
    this.deletingId,
    this.actionMessageCode,
    this.actionErrorMessage,
    this.actionErrorCode,
    this.saving = false,
    this.formErrors = const {},
  });

  const StaffListState.initial()
      : status = StaffListStatus.initial,
        users = const [],
        query = '',
        filter = StaffListFilter.all,
        creating = false,
        errorMessage = null,
        errorCode = null,
        deletingId = null,
        actionMessageCode = null,
        actionErrorMessage = null,
        actionErrorCode = null,
        saving = false,
        formErrors = const {};

  final StaffListStatus status;
  final List<User> users;
  final String query;
  final StaffListFilter filter;
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

  /// Field-level validation errors from the last create/update attempt.
  final Map<String, List<String>> formErrors;

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
    String? errorCode,
    int? deletingId,
    MessageCode? actionMessageCode,
    String? actionErrorMessage,
    String? actionErrorCode,
    bool? saving,
    Map<String, List<String>>? formErrors,
    bool clearError = false,
    bool clearDeletingId = false,
    bool clearActionMessageCode = false,
    bool clearActionErrorMessage = false,
  }) {
    return StaffListState(
      status: status ?? this.status,
      users: users ?? this.users,
      query: query ?? this.query,
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
      formErrors: formErrors ?? const {},
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
        errorCode,
        deletingId,
        actionMessageCode,
        actionErrorMessage,
        actionErrorCode,
        saving,
        formErrors,
      ];
}
