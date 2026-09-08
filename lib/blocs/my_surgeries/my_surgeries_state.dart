part of 'my_surgeries_bloc.dart';

enum MySurgeriesStatus { initial, loading, loaded, error }

class MySurgeriesState extends Equatable {
  const MySurgeriesState({
    required this.status,
    required this.items,
    this.errorMessage,
    this.startingId,
    this.actionMessage,
  });

  const MySurgeriesState.initial()
      : status = MySurgeriesStatus.initial,
        items = const [],
        errorMessage = null,
        startingId = null,
        actionMessage = null;

  final MySurgeriesStatus status;
  final List<Surgery> items;
  final String? errorMessage;

  /// Non-null while a start request is in flight for that specific
  /// surgery. UI reads this to spin only the tapped card.
  final int? startingId;

  /// One-shot toast text emitted by the start action. Screens read it
  /// via a `BlocConsumer.listener`.
  final String? actionMessage;

  MySurgeriesState copyWith({
    MySurgeriesStatus? status,
    List<Surgery>? items,
    String? errorMessage,
    int? startingId,
    String? actionMessage,
    bool clearError = false,
    bool clearStartingId = false,
  }) {
    return MySurgeriesState(
      status: status ?? this.status,
      items: items ?? this.items,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      startingId: clearStartingId ? null : (startingId ?? this.startingId),
      actionMessage: actionMessage ?? this.actionMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, items, errorMessage, startingId, actionMessage];
}
