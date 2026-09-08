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
  const SurgeryDetailDelayRequested();
}

class SurgeryDetailCancelRequested extends SurgeryDetailEvent {
  const SurgeryDetailCancelRequested();
}
