class ApiException implements Exception {
  final String message;
  final int? statusCode;

  /// Stable snake_case code from the backend's `error_code` field (e.g.
  /// `role_forbidden`, `surgery_time_conflict`). Null for responses that
  /// predate the error_code contract or weren't shaped as JSON (e.g. a
  /// raw network failure). Screens should look up a localized string by
  /// this code and only fall back to [message] when it's null or
  /// unrecognized — see `lib/core/l10n/error_code_l10n.dart`.
  final String? errorCode;

  /// Structured context from the backend's optional `meta` object (e.g.
  /// `{"required_role": "admin"}`, `{"current_status": "completed"}`).
  final Map<String, dynamic>? meta;

  const ApiException(this.message, {this.statusCode, this.errorCode, this.meta});

  @override
  String toString() => 'ApiException($statusCode/$errorCode): $message';
}

// HTTP 401 — { "message": "Unauthenticated.", "error_code": "unauthenticated" }
class UnauthenticatedException extends ApiException {
  const UnauthenticatedException({
    String message = 'Unauthenticated.',
    String? errorCode,
    Map<String, dynamic>? meta,
  }) : super(message, statusCode: 401, errorCode: errorCode, meta: meta);
}

// HTTP 403 — { "message": "Forbidden...", "error_code": "role_forbidden"|"surgery_not_owned"|... }
class ForbiddenException extends ApiException {
  const ForbiddenException({
    String message = 'Forbidden',
    String? errorCode,
    Map<String, dynamic>? meta,
  }) : super(message, statusCode: 403, errorCode: errorCode, meta: meta);
}

// HTTP 422 — { "message": "...", "error_code": "validation_failed"|..., "errors": { "field": ["msg", ...] } }
class ValidationException extends ApiException {
  final Map<String, List<String>> errors;

  const ValidationException(
    super.message,
    this.errors, {
    super.errorCode,
    super.meta,
  }) : super(statusCode: 422);

  List<String> errorsFor(String field) => errors[field] ?? const [];
  String? firstErrorFor(String field) => errorsFor(field).isEmpty ? null : errorsFor(field).first;

  @override
  String toString() => 'ValidationException: $message $errors';
}

// HTTP 404 — { "message": "...", "error_code": "not_found", "meta": {"model": "..."} }
class NotFoundException extends ApiException {
  const NotFoundException({
    String message = 'Not found',
    String? errorCode,
    Map<String, dynamic>? meta,
  }) : super(message, statusCode: 404, errorCode: errorCode, meta: meta);
}

// Network / connectivity failures (no HTTP response) — never carries an
// error_code, since there was no server response to read one from.
class NetworkException extends ApiException {
  const NetworkException([String message = 'Network error']) : super(message);
}
