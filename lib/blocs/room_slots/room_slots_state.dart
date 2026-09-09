part of 'room_slots_bloc.dart';

enum RoomSlotsStatus { initial, loading, loaded, error }

class RoomSlotsState extends Equatable {
  const RoomSlotsState({
    required this.status,
    required this.slots,
    required this.saving,
    this.errorMessage,
    this.errorCode,
    this.deletingId,
    this.actionMessageCode,
    this.actionErrorMessage,
    this.actionErrorCode,
    this.formErrors = const {},
  });

  const RoomSlotsState.initial()
      : status = RoomSlotsStatus.initial,
        slots = const [],
        saving = false,
        errorMessage = null,
        errorCode = null,
        deletingId = null,
        actionMessageCode = null,
        actionErrorMessage = null,
        actionErrorCode = null,
        formErrors = const {};

  final RoomSlotsStatus status;
  final List<RoomSlot> slots;
  final bool saving;
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

  /// Field-level validation errors from the last create attempt (e.g.
  /// end_time before start_time).
  final Map<String, List<String>> formErrors;

  RoomSlotsState copyWith({
    RoomSlotsStatus? status,
    List<RoomSlot>? slots,
    bool? saving,
    String? errorMessage,
    String? errorCode,
    int? deletingId,
    MessageCode? actionMessageCode,
    String? actionErrorMessage,
    String? actionErrorCode,
    Map<String, List<String>>? formErrors,
    bool clearError = false,
    bool clearDeletingId = false,
    bool clearActionMessageCode = false,
    bool clearActionErrorMessage = false,
  }) {
    return RoomSlotsState(
      status: status ?? this.status,
      slots: slots ?? this.slots,
      saving: saving ?? this.saving,
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
      formErrors: formErrors ?? const {},
    );
  }

  @override
  List<Object?> get props => [
        status,
        slots,
        saving,
        errorMessage,
        errorCode,
        deletingId,
        actionMessageCode,
        actionErrorMessage,
        actionErrorCode,
        formErrors,
      ];
}
