import 'package:equatable/equatable.dart';

import 'surgery_priority.dart';

/// A partially-filled schedule request, passed between stage 1
/// (Schedule Surgery form — patient / surgeon / type / priority) and
/// stage 2 (Manual room/time picker — room + start).
///
/// Not a wire type — the app-side only. Once stage 2 completes we
/// assemble the full POST body from this + the picked room/time.
class SurgeryDraft extends Equatable {
  const SurgeryDraft({
    required this.patientId,
    required this.surgeonId,
    required this.surgeryTypeId,
    required this.priority,
    this.estimatedDurationMin,
  });

  final int patientId;
  final int surgeonId;
  final int surgeryTypeId;
  final SurgeryPriority priority;

  /// Coordinator-editable override of the surgery type's average
  /// duration. Null means "let the server default it."
  final int? estimatedDurationMin;

  @override
  List<Object?> get props =>
      [patientId, surgeonId, surgeryTypeId, priority, estimatedDurationMin];
}
