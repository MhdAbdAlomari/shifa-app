part of 'patients_list_bloc.dart';

enum PatientsListStatus { initial, loading, loaded, error }

class PatientsListState extends Equatable {
  const PatientsListState({
    required this.status,
    required this.patients,
    required this.query,
    required this.saving,
    this.errorMessage,
    this.errorCode,
    this.deletingId,
    this.actionMessageCode,
    this.actionErrorMessage,
    this.actionErrorCode,
    this.formErrors = const {},
  });

  const PatientsListState.initial()
      : status = PatientsListStatus.initial,
        patients = const [],
        query = '',
        saving = false,
        errorMessage = null,
        errorCode = null,
        deletingId = null,
        actionMessageCode = null,
        actionErrorMessage = null,
        actionErrorCode = null,
        formErrors = const {};

  final PatientsListStatus status;
  final List<Patient> patients;
  final String query;
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

  /// Field-level validation errors from the last create/update attempt
  /// (e.g. a duplicate MRN). Cleared automatically on the next attempt.
  final Map<String, List<String>> formErrors;

  PatientsListState copyWith({
    PatientsListStatus? status,
    List<Patient>? patients,
    String? query,
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
    return PatientsListState(
      status: status ?? this.status,
      patients: patients ?? this.patients,
      query: query ?? this.query,
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
        patients,
        query,
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
