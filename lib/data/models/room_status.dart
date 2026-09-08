enum RoomStatus {
  free('free'),
  preparing('preparing'),
  inUse('in_use'),
  cleaning('cleaning');

  final String value;
  const RoomStatus(this.value);

  static RoomStatus fromString(String v) =>
      RoomStatus.values.firstWhere((s) => s.value == v);
}
