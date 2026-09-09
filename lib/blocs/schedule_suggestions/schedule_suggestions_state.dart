part of 'schedule_suggestions_bloc.dart';

enum ScheduleSuggestionsStatus { initial, loading, loaded, error }

class ScheduleSuggestionsState extends Equatable {
  const ScheduleSuggestionsState({
    required this.status,
    required this.items,
    this.errorMessage,
    this.errorCode,
    this.actionInFlightId,
    this.actionError,
    this.actionErrorCode,
  });

  const ScheduleSuggestionsState.initial()
      : status = ScheduleSuggestionsStatus.initial,
        items = const [],
        errorMessage = null,
        errorCode = null,
        actionInFlightId = null,
        actionError = null,
        actionErrorCode = null;

  final ScheduleSuggestionsStatus status;
  final List<ScheduleSuggestion> items;
  final String? errorMessage;

  /// error_code paired with [errorMessage] — see error_code_l10n.dart.
  final String? errorCode;

  /// Non-null while an accept/reject request is in flight for that
  /// specific suggestion. UI reads this to spin only the tapped card.
  final int? actionInFlightId;
  final String? actionError;

  /// error_code paired with [actionError] — see error_code_l10n.dart.
  final String? actionErrorCode;

  ScheduleSuggestionsState copyWith({
    ScheduleSuggestionsStatus? status,
    List<ScheduleSuggestion>? items,
    String? errorMessage,
    String? errorCode,
    int? actionInFlightId,
    String? actionError,
    String? actionErrorCode,
    bool clearError = false,
    bool clearActionInFlightId = false,
    bool clearActionError = false,
  }) {
    return ScheduleSuggestionsState(
      status: status ?? this.status,
      items: items ?? this.items,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      errorCode: clearError ? null : (errorCode ?? this.errorCode),
      actionInFlightId: clearActionInFlightId
          ? null
          : (actionInFlightId ?? this.actionInFlightId),
      actionError:
          clearActionError ? null : (actionError ?? this.actionError),
      actionErrorCode: clearActionError
          ? null
          : (actionErrorCode ?? this.actionErrorCode),
    );
  }

  @override
  List<Object?> get props => [
        status,
        items,
        errorMessage,
        errorCode,
        actionInFlightId,
        actionError,
        actionErrorCode,
      ];
}
