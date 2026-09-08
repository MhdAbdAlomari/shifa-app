import 'package:equatable/equatable.dart';

import 'schedule_suggestion.dart';

// POST /api/surgeries/{surgery}/delay response shape.
// The suggestions in this response do NOT include eager-loaded surgery/suggested_room.
class DelayResponse extends Equatable {
  final String message;
  final List<ScheduleSuggestion> suggestions;

  const DelayResponse({required this.message, required this.suggestions});

  factory DelayResponse.fromJson(Map<String, dynamic> json) => DelayResponse(
        message: json['message'] as String,
        suggestions: (json['suggestions'] as List<dynamic>)
            .map((e) =>
                ScheduleSuggestion.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  @override
  List<Object?> get props => [message, suggestions];
}
