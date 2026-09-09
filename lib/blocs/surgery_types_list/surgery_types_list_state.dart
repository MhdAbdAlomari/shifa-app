part of 'surgery_types_list_bloc.dart';

enum SurgeryTypesListStatus { initial, loading, loaded, error }

class SurgeryTypesListState extends Equatable {
  const SurgeryTypesListState({
    required this.status,
    required this.surgeryTypes,
    required this.rooms,
    required this.saving,
    this.errorMessage,
    this.errorCode,
    this.deletingId,
    this.actionMessageCode,
    this.actionErrorMessage,
    this.actionErrorCode,
    this.formErrors = const {},
  });

  const SurgeryTypesListState.initial()
      : status = SurgeryTypesListStatus.initial,
        surgeryTypes = const [],
        rooms = const [],
        saving = false,
        errorMessage = null,
        errorCode = null,
        deletingId = null,
        actionMessageCode = null,
        actionErrorMessage = null,
        actionErrorCode = null,
        formErrors = const {};

  final SurgeryTypesListStatus status;
  final List<SurgeryType> surgeryTypes;

  /// Rooms, loaded alongside surgery types purely to populate the
  /// "default room" dropdown in the add/edit form.
  final List<OperatingRoom> rooms;

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

  /// Field-level validation errors from the last create/update attempt.
  final Map<String, List<String>> formErrors;

  SurgeryTypesListState copyWith({
    SurgeryTypesListStatus? status,
    List<SurgeryType>? surgeryTypes,
    List<OperatingRoom>? rooms,
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
    return SurgeryTypesListState(
      status: status ?? this.status,
      surgeryTypes: surgeryTypes ?? this.surgeryTypes,
      rooms: rooms ?? this.rooms,
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
        surgeryTypes,
        rooms,
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
