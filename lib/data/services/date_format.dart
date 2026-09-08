// Serialize a DateTime to "yyyy-MM-dd HH:mm:ss" (local, no TZ), the format
// the backend accepts for scheduled_start on POST/PUT /api/surgeries.
String formatServerDateTime(DateTime dt) {
  String pad(int v) => v.toString().padLeft(2, '0');
  return '${dt.year}-${pad(dt.month)}-${pad(dt.day)} '
      '${pad(dt.hour)}:${pad(dt.minute)}:${pad(dt.second)}';
}

// Serialize a DateTime to "yyyy-MM-dd" for calendar from/to query params.
String formatServerDate(DateTime dt) {
  String pad(int v) => v.toString().padLeft(2, '0');
  return '${dt.year}-${pad(dt.month)}-${pad(dt.day)}';
}
