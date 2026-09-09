import '../../core/constants/api_constants.dart';
import '../../core/network/dio_client.dart';
import '../models/surgery_type.dart';

class SurgeryTypeService {
  final DioClient _client;
  SurgeryTypeService(this._client);

  // GET /api/surgery-types  (any authenticated role)
  Future<List<SurgeryType>> list() async {
    final res =
        await _client.get<Map<String, dynamic>>(ApiConstants.surgeryTypes);
    return (res.data!['data'] as List<dynamic>)
        .map((e) => SurgeryType.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // GET /api/surgery-types/{surgeryType}  (admin, coordinator)
  Future<SurgeryType> show(int id) async {
    final res = await _client
        .get<Map<String, dynamic>>(ApiConstants.surgeryType(id));
    return SurgeryType.fromJson(res.data!['data'] as Map<String, dynamic>);
  }

  // POST /api/surgery-types  (admin, coordinator)
  Future<SurgeryType> create({
    required String name,
    required int averageDurationMin,
    String? requiredSpecialty,
    int? defaultRoomId,
  }) async {
    final res = await _client.post<Map<String, dynamic>>(
      ApiConstants.surgeryTypes,
      data: {
        'name': name,
        'average_duration_min': averageDurationMin,
        if (requiredSpecialty != null) 'required_specialty': requiredSpecialty,
        if (defaultRoomId != null) 'default_room_id': defaultRoomId,
      },
    );
    return SurgeryType.fromJson(res.data!['data'] as Map<String, dynamic>);
  }

  // PUT/PATCH /api/surgery-types/{surgeryType}  (admin, coordinator)
  // Pass clearDefaultRoomId: true to explicitly set default_room_id to
  // null; omit the field entirely to leave it unchanged.
  Future<SurgeryType> update(
    int id, {
    String? name,
    int? averageDurationMin,
    String? requiredSpecialty,
    int? defaultRoomId,
    bool clearDefaultRoomId = false,
  }) async {
    final res = await _client.put<Map<String, dynamic>>(
      ApiConstants.surgeryType(id),
      data: {
        if (name != null) 'name': name,
        if (averageDurationMin != null)
          'average_duration_min': averageDurationMin,
        if (requiredSpecialty != null) 'required_specialty': requiredSpecialty,
        if (defaultRoomId != null)
          'default_room_id': defaultRoomId
        else if (clearDefaultRoomId)
          'default_room_id': null,
      },
    );
    return SurgeryType.fromJson(res.data!['data'] as Map<String, dynamic>);
  }

  // DELETE /api/surgery-types/{surgeryType}  (admin, coordinator)
  Future<String> delete(int id) async {
    final res = await _client
        .delete<Map<String, dynamic>>(ApiConstants.surgeryType(id));
    return res.data!['message'] as String;
  }
}
