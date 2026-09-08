import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import '../error/exceptions.dart';
import 'auth_interceptor.dart';
import 'auth_token_storage.dart';
import 'error_interceptor.dart';

class DioClient {
  final Dio dio;
  final AuthTokenStorage tokenStorage;

  DioClient._(this.dio, this.tokenStorage);

  factory DioClient({
    AuthTokenStorage? tokenStorage,
    String? baseUrl,
  }) {
    final storage = tokenStorage ?? AuthTokenStorage();
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 20),
        headers: {'Accept': 'application/json'},
        responseType: ResponseType.json,
      ),
    );

    dio.interceptors.addAll([
      AuthInterceptor(storage),
      ErrorInterceptor(),
    ]);

    return DioClient._(dio, storage);
  }

  Future<Response<T>> get<T>(String path,
          {Map<String, dynamic>? queryParameters}) =>
      _run(() => dio.get<T>(path, queryParameters: queryParameters));

  Future<Response<T>> post<T>(String path, {dynamic data}) =>
      _run(() => dio.post<T>(path, data: data));

  Future<Response<T>> put<T>(String path, {dynamic data}) =>
      _run(() => dio.put<T>(path, data: data));

  Future<Response<T>> patch<T>(String path, {dynamic data}) =>
      _run(() => dio.patch<T>(path, data: data));

  Future<Response<T>> delete<T>(String path, {dynamic data}) =>
      _run(() => dio.delete<T>(path, data: data));

  Future<Response<T>> _run<T>(Future<Response<T>> Function() call) async {
    try {
      return await call();
    } on DioException catch (e) {
      final err = e.error;
      if (err is ApiException) throw err;
      throw ApiException(e.message ?? 'Request failed',
          statusCode: e.response?.statusCode);
    }
  }
}
