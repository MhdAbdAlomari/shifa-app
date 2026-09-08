enum ScheduleSuggestionStatus {
  pending('pending'),
  accepted('accepted'),
  rejected('rejected');

  final String value;
  const ScheduleSuggestionStatus(this.value);

  static ScheduleSuggestionStatus fromString(String v) =>
      ScheduleSuggestionStatus.values.firstWhere((s) => s.value == v);
}
