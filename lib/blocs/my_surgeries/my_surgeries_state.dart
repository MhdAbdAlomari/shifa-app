part of 'my_surgeries_bloc.dart';

enum MySurgeriesStatus { initial, loading, loaded, error }

class MySurgeriesState extends Equatable {
  const MySurgeriesState({
    required this.status,
    required this.items,
    this.errorMessage,
    this.errorCode,
    this.startingId,
    this.actionMessageCode,
    this.actionErrorMessage,
    this.actionErrorCode,
  });

  const MySurgeriesState.initial()
      : status = MySurgeriesStatus.initial,
        items = const [],
        errorMessage = null,
        errorCode = null,
        startingId = null,
        actionMessageCode = null,
        actionErrorMessage = null,
        actionErrorCode = null;

  final MySurgeriesStatus status;
  final List<Surgery> items;
  final String? errorMessage;

  /// error_code paired with [errorMessage] — see error_code_l10n.dart.
  final String? errorCode;

  /// Non-null while a start request is in flight for that specific
  /// surgery. UI reads this to spin only the tapped card.
  final int? startingId;

  /// One-shot success toast code emitted by the start action. Screens
  /// read it via a `BlocConsumer.listener` and map it to translated text.
  final MessageCode? actionMessageCode;

  /// One-shot server error message (untranslated, from the API) shown
  /// as-is when the start action fails.
  final String? actionErrorMessage;

  /// error_code paired with [actionErrorMessage] — see error_code_l10n.dart.
  final String? actionErrorCode;

  MySurgeriesState copyWith({
    MySurgeriesStatus? status,
    List<Surgery>? items,
    String? errorMessage,
    String? errorCode,
    int? startingId,
    MessageCode? actionMessageCode,
    String? actionErrorMessage,
    String? actionErrorCode,
    bool clearError = false,
    bool clearStartingId = false,
    bool clearActionMessageCode = false,
    bool clearActionErrorMessage = false,
  }) {
    return MySurgeriesState(
      status: status ?? this.status,
      items: items ?? this.items,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      errorCode: clearError ? null : (errorCode ?? this.errorCode),
      startingId: clearStartingId ? null : (startingId ?? this.startingId),
      actionMessageCode: clearActionMessageCode
          ? null
          : (actionMessageCode ?? this.actionMessageCode),
      actionErrorMessage: clearActionErrorMessage
          ? null
          : (actionErrorMessage ?? this.actionErrorMessage),
      actionErrorCode: clearActionErrorMessage
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
        startingId,
        actionMessageCode,
        actionErrorMessage,
        actionErrorCode,
      ];
}
