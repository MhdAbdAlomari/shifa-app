import '../../core/constants/api_constants.dart';
import '../../core/network/auth_token_storage.dart';
import '../../core/network/dio_client.dart';
import '../models/auth_response.dart';
import '../models/user.dart';
import '../models/user_role.dart';

class AuthService {
  final DioClient _client;
  final AuthTokenStorage _tokenStorage;

  AuthService(this._client, {AuthTokenStorage? tokenStorage})
      : _tokenStorage = tokenStorage ?? _client.tokenStorage;

  // POST /api/register
  Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required UserRole role,
    String? specialty,
  }) async {
    final res = await _client.post<Map<String, dynamic>>(
      ApiConstants.register,
      data: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'role': role.value,
        if (specialty != null) 'specialty': specialty,
      },
    );
    final auth = AuthResponse.fromJson(res.data!);
    await _tokenStorage.write(auth.token);
    return auth;
  }

  // POST /api/login
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final res = await _client.post<Map<String, dynamic>>(
      ApiConstants.login,
      data: {'email': email, 'password': password},
    );
    final auth = AuthResponse.fromJson(res.data!);
    await _tokenStorage.write(auth.token);
    return auth;
  }

  // POST /api/logout
  Future<String> logout() async {
    final res = await _client.post<Map<String, dynamic>>(ApiConstants.logout);
    await _tokenStorage.clear();
    return res.data!['message'] as String;
  }

  // GET /api/me
  Future<User> me() async {
    final res = await _client.get<Map<String, dynamic>>(ApiConstants.me);
    return User.fromJson(res.data!['user'] as Map<String, dynamic>);
  }
}
