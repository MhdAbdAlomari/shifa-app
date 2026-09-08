part of 'surgery_detail_bloc.dart';

enum SurgeryDetailStatus { initial, loading, loaded, error }

enum SurgeryActionStatus { idle, running, error }

class SurgeryDetailState extends Equatable {
  const SurgeryDetailState({
    required this.status,
    required this.actionStatus,
    this.surgery,
    this.errorMessage,
    this.actionMessage,
    this.delayResponse,
  });

  const SurgeryDetailState.initial()
      : status = SurgeryDetailStatus.initial,
        actionStatus = SurgeryActionStatus.idle,
        surgery = null,
        errorMessage = null,
        actionMessage = null,
        delayResponse = null;

  final SurgeryDetailStatus status;
  final SurgeryActionStatus actionStatus;
  final Surgery? surgery;
  final String? errorMessage;

  /// One-shot message from the last action. UI shows it as a SnackBar
  /// (success or failure — the [actionStatus] field disambiguates).
  final String? actionMessage;

  /// Populated only after a successful delay; the screen surfaces it
  /// in an info banner directing the coordinator to the suggestions inbox.
  final DelayResponse? delayResponse;

  SurgeryDetailState copyWith({
    SurgeryDetailStatus? status,
    SurgeryActionStatus? actionStatus,
    Surgery? surgery,
    String? errorMessage,
    String? actionMessage,
    DelayResponse? delayResponse,
    bool clearError = false,
  }) {
    return SurgeryDetailState(
      status: status ?? this.status,
      actionStatus: actionStatus ?? this.actionStatus,
      surgery: surgery ?? this.surgery,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      actionMessage: actionMessage ?? this.actionMessage,
      delayResponse: delayResponse ?? this.delayResponse,
    );
  }

  @override
  List<Object?> get props => [
        status,
        actionStatus,
        surgery,
        errorMessage,
        actionMessage,
        delayResponse,
      ];
}
