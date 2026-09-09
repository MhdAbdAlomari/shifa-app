// Serialize a DateTime to "yyyy-MM-dd HH:mm:ss" in UTC, the format the
// backend accepts for scheduled_start on POST/PUT /api/surgeries.
//
// The API always returns timestamps as UTC (Z-suffixed ISO-8601), and
// every display site converts back with .toLocal(). To round-trip a
// wall-clock time the user actually picked without drift, we must
// convert to UTC here before formatting — sending naive local digits
// would get relabeled as UTC by the round trip and reappear shifted by
// the device's UTC offset.
String formatServerDateTime(DateTime dt) {
  final utc = dt.toUtc();
  String pad(int v) => v.toString().padLeft(2, '0');
  return '${utc.year}-${pad(utc.month)}-${pad(utc.day)} '
      '${pad(utc.hour)}:${pad(utc.minute)}:${pad(utc.second)}';
}

// Serialize a DateTime to "yyyy-MM-dd" for calendar from/to query params.
String formatServerDate(DateTime dt) {
  String pad(int v) => v.toString().padLeft(2, '0');
  return '${dt.year}-${pad(dt.month)}-${pad(dt.day)}';
}
