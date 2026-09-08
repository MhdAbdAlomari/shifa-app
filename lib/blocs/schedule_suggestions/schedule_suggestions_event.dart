part of 'schedule_suggestions_bloc.dart';

sealed class ScheduleSuggestionsEvent extends Equatable {
  const ScheduleSuggestionsEvent();

  @override
  List<Object?> get props => const [];
}

class ScheduleSuggestionsRequested extends ScheduleSuggestionsEvent {
  const ScheduleSuggestionsRequested();
}

class ScheduleSuggestionsRefreshRequested extends ScheduleSuggestionsEvent {
  const ScheduleSuggestionsRefreshRequested();
}

class ScheduleSuggestionAcceptRequested extends ScheduleSuggestionsEvent {
  const ScheduleSuggestionAcceptRequested(this.id);

  final int id;

  @override
  List<Object?> get props => [id];
}

class ScheduleSuggestionRejectRequested extends ScheduleSuggestionsEvent {
  const ScheduleSuggestionRejectRequested(this.id);

  final int id;

  @override
  List<Object?> get props => [id];
}
