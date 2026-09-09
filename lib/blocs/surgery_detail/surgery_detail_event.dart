part of 'surgery_detail_bloc.dart';

sealed class SurgeryDetailEvent extends Equatable {
  const SurgeryDetailEvent();

  @override
  List<Object?> get props => const [];
}

class SurgeryDetailRequested extends SurgeryDetailEvent {
  const SurgeryDetailRequested();
}

class SurgeryDetailStartRequested extends SurgeryDetailEvent {
  const SurgeryDetailStartRequested();
}

class SurgeryDetailCompleteRequested extends SurgeryDetailEvent {
  const SurgeryDetailCompleteRequested();
}

class SurgeryDetailDelayRequested extends SurgeryDetailEvent {
  const SurgeryDetailDelayRequested({
    required this.newExpectedEnd,
    required this.reason,
  });

  final DateTime newExpectedEnd;
  final String reason;

  @override
  List<Object?> get props => [newExpectedEnd, reason];
}

class SurgeryDetailCancelRequested extends SurgeryDetailEvent {
  const SurgeryDetailCancelRequested();
}
