import '../../core/constants/api_constants.dart';
import '../../core/network/dio_client.dart';
import '../models/room_slot.dart';

class RoomSlotService {
  final DioClient _client;
  RoomSlotService(this._client);

  // GET /api/rooms/{room}/slots  (admin, coordinator)
  Future<List<RoomSlot>> list(int roomId) async {
    final res = await _client
        .get<Map<String, dynamic>>(ApiConstants.roomSlots(roomId));
    return (res.data!['data'] as List<dynamic>)
        .map((e) => RoomSlot.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // POST /api/rooms/{room}/slots  (admin, coordinator)
  Future<RoomSlot> create(
    int roomId, {
    required int dayOfWeek,
    required String startTime,
    required String endTime,
  }) async {
    final res = await _client.post<Map<String, dynamic>>(
      ApiConstants.roomSlots(roomId),
      data: {
        'day_of_week': dayOfWeek,
        'start_time': startTime,
        'end_time': endTime,
      },
    );
    return RoomSlot.fromJson(res.data!['data'] as Map<String, dynamic>);
  }

  // PUT/PATCH /api/rooms/{room}/slots/{slot}  (admin, coordinator)
  Future<RoomSlot> update(
    int roomId,
    int slotId, {
    int? dayOfWeek,
    String? startTime,
    String? endTime,
  }) async {
    final res = await _client.put<Map<String, dynamic>>(
      ApiConstants.roomSlot(roomId, slotId),
      data: {
        if (dayOfWeek != null) 'day_of_week': dayOfWeek,
        if (startTime != null) 'start_time': startTime,
        if (endTime != null) 'end_time': endTime,
      },
    );
    return RoomSlot.fromJson(res.data!['data'] as Map<String, dynamic>);
  }

  // DELETE /api/rooms/{room}/slots/{slot}  (admin, coordinator)
  Future<String> delete(int roomId, int slotId) async {
    final res = await _client
        .delete<Map<String, dynamic>>(ApiConstants.roomSlot(roomId, slotId));
    return res.data!['message'] as String;
  }
}
