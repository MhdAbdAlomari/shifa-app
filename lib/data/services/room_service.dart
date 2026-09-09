import 'package:dio/dio.dart';

import '../../core/constants/api_constants.dart';
import '../../core/network/dio_client.dart';
import '../models/operating_room.dart';
import '../models/room_status.dart';
import '../models/room_surgeries_response.dart';
import 'date_format.dart';

class RoomService {
  final DioClient _client;
  RoomService(this._client);

  // GET /api/rooms  (admin, coordinator)
  Future<List<OperatingRoom>> list() async {
    final res = await _client.get<Map<String, dynamic>>(ApiConstants.rooms);
    return (res.data!['data'] as List<dynamic>)
        .map((e) => OperatingRoom.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // GET /api/rooms/{room}  (admin, coordinator)
  Future<OperatingRoom> show(int id) async {
    final res = await _client.get<Map<String, dynamic>>(ApiConstants.room(id));
    return OperatingRoom.fromJson(res.data!['data'] as Map<String, dynamic>);
  }

  // GET /api/rooms/{room}/surgeries  (admin, coordinator)
  // Both params default server-side to "today" when omitted.
  Future<RoomSurgeriesResponse> surgeries(
    int roomId, {
    DateTime? from,
    DateTime? to,
  }) async {
    final res = await _client.get<Map<String, dynamic>>(
      ApiConstants.roomSurgeries(roomId),
      queryParameters: {
        if (from != null) 'from': formatServerDate(from),
        if (to != null) 'to': formatServerDate(to),
      },
    );
    return RoomSurgeriesResponse.fromJson(res.data!);
  }

  // POST /api/rooms  (admin, coordinator)
  // Pass [imageBytes] + [imageFilename] to upload via multipart; omit both
  // to send a plain JSON body (no image change).
  Future<OperatingRoom> create({
    required String name,
    RoomStatus? status,
    String? supportedSpecialty,
    List<int>? imageBytes,
    String? imageFilename,
  }) async {
    final data = imageBytes == null
        ? {
            'name': name,
            if (status != null) 'status': status.value,
            if (supportedSpecialty != null)
              'supported_specialty': supportedSpecialty,
          }
        : FormData.fromMap({
            'name': name,
            if (status != null) 'status': status.value,
            if (supportedSpecialty != null)
              'supported_specialty': supportedSpecialty,
            'image': MultipartFile.fromBytes(imageBytes,
                filename: imageFilename ?? 'room.png'),
          });
    final res = await _client.post<Map<String, dynamic>>(
      ApiConstants.rooms,
      data: data,
    );
    return OperatingRoom.fromJson(res.data!['data'] as Map<String, dynamic>);
  }

  // PUT/PATCH /api/rooms/{room}  (admin, coordinator)
  // Pass clearSupportedSpecialty: true to explicitly set supported_specialty to null;
  // omit the field entirely to leave it unchanged. Pass [imageBytes] to
  // upload a new image — this is sent as `POST` with `_method=PUT` since
  // PHP cannot parse multipart bodies on a real PUT request.
  Future<OperatingRoom> update(
    int id, {
    String? name,
    RoomStatus? status,
    String? supportedSpecialty,
    bool clearSupportedSpecialty = false,
    List<int>? imageBytes,
    String? imageFilename,
  }) async {
    if (imageBytes != null) {
      final res = await _client.post<Map<String, dynamic>>(
        ApiConstants.room(id),
        data: FormData.fromMap({
          '_method': 'PUT',
          if (name != null) 'name': name,
          if (status != null) 'status': status.value,
          if (supportedSpecialty != null)
            'supported_specialty': supportedSpecialty,
          'image': MultipartFile.fromBytes(imageBytes,
              filename: imageFilename ?? 'room.png'),
        }),
      );
      return OperatingRoom.fromJson(res.data!['data'] as Map<String, dynamic>);
    }
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

  // DELETE /api/rooms/{room}  (admin, coordinator)
  Future<String> delete(int id) async {
    final res =
        await _client.delete<Map<String, dynamic>>(ApiConstants.room(id));
    return res.data!['message'] as String;
  }
}
