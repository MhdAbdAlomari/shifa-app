enum SurgeryPriority {
  normal('normal'),
  emergency('emergency');

  final String value;
  const SurgeryPriority(this.value);

  static SurgeryPriority fromString(String v) =>
      SurgeryPriority.values.firstWhere((p) => p.value == v);
}
