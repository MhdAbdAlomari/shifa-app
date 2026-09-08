part of 'schedule_suggestions_bloc.dart';

enum ScheduleSuggestionsStatus { initial, loading, loaded, error }

class ScheduleSuggestionsState extends Equatable {
  const ScheduleSuggestionsState({
    required this.status,
    required this.items,
    this.errorMessage,
    this.actionInFlightId,
    this.actionError,
  });

  const ScheduleSuggestionsState.initial()
      : status = ScheduleSuggestionsStatus.initial,
        items = const [],
        errorMessage = null,
        actionInFlightId = null,
        actionError = null;

  final ScheduleSuggestionsStatus status;
  final List<ScheduleSuggestion> items;
  final String? errorMessage;

  /// Non-null while an accept/reject request is in flight for that
  /// specific suggestion. UI reads this to spin only the tapped card.
  final int? actionInFlightId;
  final String? actionError;

  ScheduleSuggestionsState copyWith({
    ScheduleSuggestionsStatus? status,
    List<ScheduleSuggestion>? items,
    String? errorMessage,
    int? actionInFlightId,
    String? actionError,
    bool clearError = false,
    bool clearActionInFlightId = false,
    bool clearActionError = false,
  }) {
    return ScheduleSuggestionsState(
      status: status ?? this.status,
      items: items ?? this.items,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      actionInFlightId: clearActionInFlightId
          ? null
          : (actionInFlightId ?? this.actionInFlightId),
      actionError:
          clearActionError ? null : (actionError ?? this.actionError),
    );
  }

  @override
  List<Object?> get props =>
      [status, items, errorMessage, actionInFlightId, actionError];
}
