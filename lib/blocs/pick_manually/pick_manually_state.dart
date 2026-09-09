part of 'pick_manually_bloc.dart';

enum PickManuallyLoadStatus { initial, loading, loaded, error }

enum PickManuallySubmitStatus { idle, submitting, success, failure }

class PickManuallyState extends Equatable {
  const PickManuallyState({
    required this.draft,
    required this.loadStatus,
    required this.submitStatus,
    required this.rooms,
    this.roomId,
    this.scheduledStart,
    this.errorMessage,
    this.errorCode,
    this.submitErrorMessage,
    this.submitErrorCode,
    this.submitErrors = const {},
    this.created,
  });

  factory PickManuallyState.initial(SurgeryDraft draft) => PickManuallyState(
        draft: draft,
        loadStatus: PickManuallyLoadStatus.initial,
        submitStatus: PickManuallySubmitStatus.idle,
        rooms: const [],
      );

  final SurgeryDraft draft;
  final PickManuallyLoadStatus loadStatus;
  final PickManuallySubmitStatus submitStatus;
  final List<OperatingRoom> rooms;

  final int? roomId;
  final DateTime? scheduledStart;

  final String? errorMessage;

  /// error_code paired with [errorMessage] — see error_code_l10n.dart.
  final String? errorCode;

  final String? submitErrorMessage;

  /// error_code paired with [submitErrorMessage] — see error_code_l10n.dart.
  final String? submitErrorCode;

  final Map<String, List<String>> submitErrors;

  final Surgery? created;

  bool get isReady => roomId != null && scheduledStart != null;

  PickManuallyState copyWith({
    PickManuallyLoadStatus? loadStatus,
    PickManuallySubmitStatus? submitStatus,
    List<OperatingRoom>? rooms,
    int? roomId,
    DateTime? scheduledStart,
    String? errorMessage,
    String? errorCode,
    String? submitErrorMessage,
    String? submitErrorCode,
    Map<String, List<String>>? submitErrors,
    Surgery? created,
    bool clearError = false,
    bool clearSubmitError = false,
  }) {
    return PickManuallyState(
      draft: draft,
      loadStatus: loadStatus ?? this.loadStatus,
      submitStatus: submitStatus ?? this.submitStatus,
      rooms: rooms ?? this.rooms,
      roomId: roomId ?? this.roomId,
      scheduledStart: scheduledStart ?? this.scheduledStart,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      errorCode: clearError ? null : (errorCode ?? this.errorCode),
      submitErrorMessage: clearSubmitError
          ? null
          : (submitErrorMessage ?? this.submitErrorMessage),
      submitErrorCode: clearSubmitError
          ? null
          : (submitErrorCode ?? this.submitErrorCode),
      submitErrors: submitErrors ?? this.submitErrors,
      created: created ?? this.created,
    );
  }

  @override
  List<Object?> get props => [
        draft,
        loadStatus,
        submitStatus,
        rooms,
        roomId,
        scheduledStart,
        errorMessage,
        errorCode,
        submitErrorMessage,
        submitErrorCode,
        submitErrors,
        created,
      ];
}
