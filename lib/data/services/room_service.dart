import '../../core/constants/api_constants.dart';
import '../../core/network/dio_client.dart';
import '../models/operating_room.dart';
import '../models/room_status.dart';

class RoomService {
  final DioClient _client;
  RoomService(this._client);

  // GET /api/rooms
  Future<List<OperatingRoom>> list() async {
    final res = await _client.get<Map<String, dynamic>>(ApiConstants.rooms);
    return (res.data!['data'] as List<dynamic>)
        .map((e) => OperatingRoom.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // GET /api/rooms/{room}
  Future<OperatingRoom> show(int id) async {
    final res = await _client.get<Map<String, dynamic>>(ApiConstants.room(id));
    return OperatingRoom.fromJson(res.data!['data'] as Map<String, dynamic>);
  }

  // POST /api/rooms
  Future<OperatingRoom> create({
    required String name,
    RoomStatus? status,
    String? supportedSpecialty,
  }) async {
    final res = await _client.post<Map<String, dynamic>>(
      ApiConstants.rooms,
      data: {
        'name': name,
        if (status != null) 'status': status.value,
        if (supportedSpecialty != null) 'supported_specialty': supportedSpecialty,
      },
    );
    return OperatingRoom.fromJson(res.data!['data'] as Map<String, dynamic>);
  }

  // PUT/PATCH /api/rooms/{room}
  // Pass clearSupportedSpecialty: true to explicitly set supported_specialty to null;
  // omit the field entirely to leave it unchanged.
  Future<OperatingRoom> update(
    int id, {
    String? name,
    RoomStatus? status,
    String? supportedSpecialty,
    bool clearSupportedSpecialty = false,
  }) async {
    final res = await _client.put<Map<String, dynamic>>(
      ApiConstants.room(id),
      data: {
        if (name != null) 'name': name,
        if (status != null) 'status': status.value,
        if (supportedSpecialty != null)
          'supported_specialty': supportedSpecialty
        else if (clearSupportedSpecialty)
          'supported_specialty': null,
      },
    );
    return OperatingRoom.fromJson(res.data!['data'] as Map<String, dynamic>);
  }

  // DELETE /api/rooms/{room}
  Future<String> delete(int id) async {
    final res =
        await _client.delete<Map<String, dynamic>>(ApiConstants.room(id));
    return res.data!['message'] as String;
  }
}
