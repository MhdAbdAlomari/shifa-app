enum SurgeryStatus {
  scheduled('scheduled'),
  inProgress('in_progress'),
  completed('completed'),
  cancelled('cancelled'),
  delayed('delayed');

  final String value;
  const SurgeryStatus(this.value);

  static SurgeryStatus fromString(String v) =>
      SurgeryStatus.values.firstWhere((s) => s.value == v);
}
