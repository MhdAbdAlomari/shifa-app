part of 'surgery_detail_bloc.dart';

enum SurgeryDetailStatus { initial, loading, loaded, error }

enum SurgeryActionStatus { idle, running, error }

class SurgeryDetailState extends Equatable {
  const SurgeryDetailState({
    required this.status,
    required this.actionStatus,
    this.surgery,
    this.errorMessage,
    this.errorCode,
    this.actionMessageCode,
    this.actionErrorMessage,
    this.actionErrorCode,
    this.delayResponse,
    this.delayFormErrors = const {},
  });

  const SurgeryDetailState.initial()
      : status = SurgeryDetailStatus.initial,
        actionStatus = SurgeryActionStatus.idle,
        surgery = null,
        errorMessage = null,
        errorCode = null,
        actionMessageCode = null,
        actionErrorMessage = null,
        actionErrorCode = null,
        delayResponse = null,
        delayFormErrors = const {};

  final SurgeryDetailStatus status;
  final SurgeryActionStatus actionStatus;
  final Surgery? surgery;
  final String? errorMessage;

  /// error_code paired with [errorMessage] — see error_code_l10n.dart.
  final String? errorCode;

  /// One-shot success toast code from the last simple action (start /
  /// complete / cancel). UI maps it to translated text and shows it as
  /// a SnackBar. Delay reporting does NOT use this — its outcome is
  /// richer than a toast (see [delayResponse]) and is surfaced as an
  /// inline banner instead.
  final MessageCode? actionMessageCode;

  /// One-shot server error message (untranslated, from the API) shown
  /// as-is when a start/complete/cancel/delay action fails.
  final String? actionErrorMessage;

  /// error_code paired with [actionErrorMessage] — see error_code_l10n.dart.
  final String? actionErrorCode;

  /// Populated only after a delay report succeeds (auto-approved OR
  /// pending review — both are "success" from the HTTP layer's point
  /// of view; `auto_approved` distinguishes the outcome). The screen
  /// surfaces this in an inline result banner rather than a one-shot
  /// SnackBar, since the surgeon needs to actually read which of the
  /// two outcomes happened.
  final DelayResponse? delayResponse;

  /// Field-level validation errors from the last delay report attempt
  /// (e.g. `new_expected_end` not in the future, `reason` too short).
  final Map<String, List<String>> delayFormErrors;

  SurgeryDetailState copyWith({
    SurgeryDetailStatus? status,
    SurgeryActionStatus? actionStatus,
    Surgery? surgery,
    String? errorMessage,
    String? errorCode,
    MessageCode? actionMessageCode,
    String? actionErrorMessage,
    String? actionErrorCode,
    DelayResponse? delayResponse,
    Map<String, List<String>>? delayFormErrors,
    bool clearError = false,
    bool clearActionMessageCode = false,
    bool clearActionErrorMessage = false,
    bool clearDelayResponse = false,
  }) {
    return SurgeryDetailState(
      status: status ?? this.status,
      actionStatus: actionStatus ?? this.actionStatus,
      surgery: surgery ?? this.surgery,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      errorCode: clearError ? null : (errorCode ?? this.errorCode),
      actionMessageCode: clearActionMessageCode
          ? null
          : (actionMessageCode ?? this.actionMessageCode),
      actionErrorMessage: clearActionErrorMessage
          ? null
          : (actionErrorMessage ?? this.actionErrorMessage),
      actionErrorCode: clearActionErrorMessage
          ? null
          : (actionErrorCode ?? this.actionErrorCode),
      delayResponse:
          clearDelayResponse ? null : (delayResponse ?? this.delayResponse),
      delayFormErrors: delayFormErrors ?? const {},
    );
  }

  @override
  List<Object?> get props => [
        status,
        actionStatus,
        surgery,
        errorMessage,
        errorCode,
        actionMessageCode,
        actionErrorMessage,
        actionErrorCode,
        delayResponse,
        delayFormErrors,
      ];
}
