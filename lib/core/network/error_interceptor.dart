import 'package:dio/dio.dart';

import '../error/exceptions.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final response = err.response;

    if (response == null) {
      return handler.reject(
        err.copyWith(error: NetworkException(err.message ?? 'Network error')),
      );
    }

    final status = response.statusCode;
    final data = response.data;
    final message = _extractMessage(data) ?? 'Request failed';

    ApiException mapped;
    switch (status) {
      case 401:
        mapped = UnauthenticatedException(message);
        break;
      case 403:
        mapped = ForbiddenException(message);
        break;
      case 404:
        mapped = NotFoundException(message);
        break;
      case 422:
        mapped = ValidationException(message, _extractErrors(data));
        break;
      default:
        mapped = ApiException(message, statusCode: status);
    }

    handler.reject(err.copyWith(error: mapped));
  }

  static String? _extractMessage(dynamic data) {
    if (data is Map && data['message'] is String) {
      return data['message'] as String;
    }
    return null;
  }

  static Map<String, List<String>> _extractErrors(dynamic data) {
    if (data is! Map || data['errors'] is! Map) return const {};
    final raw = data['errors'] as Map;
    return raw.map((key, value) {
      final list = value is List
          ? value.map((e) => e.toString()).toList()
          : <String>[value.toString()];
      return MapEntry(key.toString(), list);
    });
  }
}
