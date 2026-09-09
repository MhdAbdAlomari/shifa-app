import 'package:equatable/equatable.dart';

import 'schedule_suggestion.dart';
import 'surgery.dart';

/// POST /api/surgeries/{surgery}/delay response — the redesigned
/// delay-reporting workflow. Always has `message` and `autoApproved`.
///
///   - Auto-approved: `surgery` is the updated surgery (now `status:
///     delayed`, `scheduledEnd` == the requested `new_expected_end`);
///     `conflictWithSurgeryId` and `suggestions` are null/empty.
///   - Pending review: `surgery` is null (the surgery is untouched —
///     still `in_progress`), `conflictWithSurgeryId` names the
///     downstream surgery that blocked auto-approval, and
///     `suggestions` holds the generated relocation proposals for the
///     coordinator to review.
class DelayResponse extends Equatable {
  final String message;
  final bool autoApproved;
  final Surgery? surgery;
  final int? conflictWithSurgeryId;
  final List<ScheduleSuggestion> suggestions;

  const DelayResponse({
    required this.message,
    required this.autoApproved,
    this.surgery,
    this.conflictWithSurgeryId,
    this.suggestions = const [],
  });

  factory DelayResponse.fromJson(Map<String, dynamic> json) => DelayResponse(
        message: json['message'] as String,
        autoApproved: json['auto_approved'] as bool,
        surgery: json['surgery'] is Map<String, dynamic>
            ? Surgery.fromJson(json['surgery'] as Map<String, dynamic>)
            : null,
        conflictWithSurgeryId: json['conflict_with_surgery_id'] as int?,
        suggestions: json['suggestions'] is List
            ? (json['suggestions'] as List<dynamic>)
                .map((e) =>
                    ScheduleSuggestion.fromJson(e as Map<String, dynamic>))
                .toList()
            : const [],
      );

  @override
  List<Object?> get props =>
      [message, autoApproved, surgery, conflictWithSurgeryId, suggestions];
}
