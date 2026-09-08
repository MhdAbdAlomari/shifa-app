part of 'auto_schedule_review_bloc.dart';

sealed class AutoScheduleReviewEvent extends Equatable {
  const AutoScheduleReviewEvent();

  @override
  List<Object?> get props => const [];
}

class AutoScheduleReviewOptionsRequested extends AutoScheduleReviewEvent {
  const AutoScheduleReviewOptionsRequested();
}

class AutoScheduleReviewPendingAdded extends AutoScheduleReviewEvent {
  const AutoScheduleReviewPendingAdded(this.request);

  final PendingSurgeryRequest request;

  @override
  List<Object?> get props => [request];
}

class AutoScheduleReviewPendingRemoved extends AutoScheduleReviewEvent {
  const AutoScheduleReviewPendingRemoved(this.index);

  final int index;

  @override
  List<Object?> get props => [index];
}

class AutoScheduleReviewProposalsRequested extends AutoScheduleReviewEvent {
  const AutoScheduleReviewProposalsRequested();
}

class AutoScheduleReviewProposalRejected extends AutoScheduleReviewEvent {
  const AutoScheduleReviewProposalRejected(this.index);

  final int index;

  @override
  List<Object?> get props => [index];
}

class AutoScheduleReviewProposalAccepted extends AutoScheduleReviewEvent {
  const AutoScheduleReviewProposalAccepted(this.index);

  final int index;

  @override
  List<Object?> get props => [index];
}

class AutoScheduleReviewReset extends AutoScheduleReviewEvent {
  const AutoScheduleReviewReset();
}
