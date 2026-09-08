class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException($statusCode): $message';
}

// HTTP 401 — { "message": "Unauthenticated." }
class UnauthenticatedException extends ApiException {
  const UnauthenticatedException([String message = 'Unauthenticated.'])
      : super(message, statusCode: 401);
}

// HTTP 403 — { "message": "Forbidden. Requires role: <role>" } or { "message": "Forbidden" }
class ForbiddenException extends ApiException {
  const ForbiddenException([String message = 'Forbidden'])
      : super(message, statusCode: 403);
}

// HTTP 422 — { "message": "...", "errors": { "field": ["msg", ...] } }
class ValidationException extends ApiException {
  final Map<String, List<String>> errors;

  const ValidationException(super.message, this.errors)
      : super(statusCode: 422);

  List<String> errorsFor(String field) => errors[field] ?? const [];
  String? firstErrorFor(String field) => errorsFor(field).isEmpty ? null : errorsFor(field).first;

  @override
  String toString() => 'ValidationException: $message $errors';
}

// HTTP 404
class NotFoundException extends ApiException {
  const NotFoundException([String message = 'Not found'])
      : super(message, statusCode: 404);
}

// Network / connectivity failures (no HTTP response)
class NetworkException extends ApiException {
  const NetworkException([String message = 'Network error']) : super(message);
}
