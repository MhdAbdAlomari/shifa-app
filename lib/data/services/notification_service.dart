import '../../core/constants/api_constants.dart';
import '../../core/network/dio_client.dart';
import '../models/app_notification.dart';

class NotificationService {
  final DioClient _client;
  NotificationService(this._client);

  // GET /api/notifications  (any authenticated role)
  Future<List<AppNotification>> list() async {
    final res =
        await _client.get<Map<String, dynamic>>(ApiConstants.notifications);
    return (res.data!['data'] as List<dynamic>)
        .map((e) => AppNotification.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // POST /api/notifications/{notification}/read  (any authenticated role)
  Future<AppNotification> markRead(int id) async {
    final res = await _client
        .post<Map<String, dynamic>>(ApiConstants.notificationRead(id));
    return AppNotification.fromJson(res.data!['data'] as Map<String, dynamic>);
  }
}
