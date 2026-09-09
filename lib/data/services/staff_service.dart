import '../../core/constants/api_constants.dart';
import '../../core/network/dio_client.dart';
import '../models/user.dart';
import '../models/user_role.dart';

class StaffService {
  final DioClient _client;
  StaffService(this._client);

  // GET /api/staff  (admin, coordinator)
  // [search] does a case-insensitive partial match against name, server-side.
  Future<List<User>> list({String? search}) async {
    final res = await _client.get<Map<String, dynamic>>(
      ApiConstants.staff,
      queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,
      },
    );
    return (res.data!['data'] as List<dynamic>)
        .map((e) => User.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // GET /api/staff/{staff}
  Future<User> show(int id) async {
    final res =
        await _client.get<Map<String, dynamic>>(ApiConstants.staffMember(id));
    return User.fromJson(res.data!['data'] as Map<String, dynamic>);
  }

  // POST /api/staff
  // Role must be coordinator or surgeon (admin cannot be created here).
  Future<User> create({
    required String name,
    required String email,
    required String password,
    required UserRole role,
    String? specialty,
  }) async {
    assert(role != UserRole.admin, 'POST /api/staff cannot create admin users');
    final res = await _client.post<Map<String, dynamic>>(
      ApiConstants.staff,
      data: {
        'name': name,
        'email': email,
        'password': password,
        'role': role.value,
        if (specialty != null) 'specialty': specialty,
      },
    );
    return User.fromJson(res.data!['data'] as Map<String, dynamic>);
  }

  // PUT/PATCH /api/staff/{staff}
  // Pass clearSpecialty: true to explicitly set specialty to null;
  // omit the field entirely to leave it unchanged.
  Future<User> update(
    int id, {
    String? name,
    String? email,
    String? password,
    UserRole? role,
    String? specialty,
    bool clearSpecialty = false,
  }) async {
    final res = await _client.put<Map<String, dynamic>>(
      ApiConstants.staffMember(id),
      data: {
        if (name != null) 'name': name,
        if (email != null) 'email': email,
        if (password != null) 'password': password,
        if (role != null) 'role': role.value,
        if (specialty != null)
          'specialty': specialty
        else if (clearSpecialty)
          'specialty': null,
      },
    );
    return User.fromJson(res.data!['data'] as Map<String, dynamic>);
  }

  // DELETE /api/staff/{staff}
  Future<String> delete(int id) async {
    final res = await _client
        .delete<Map<String, dynamic>>(ApiConstants.staffMember(id));
    return res.data!['message'] as String;
  }
}
