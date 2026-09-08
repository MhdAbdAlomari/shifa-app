import '../../core/constants/api_constants.dart';
import '../../core/network/dio_client.dart';
import '../models/dashboard_stats.dart';

class DashboardService {
  final DioClient _client;
  DashboardService(this._client);

  // GET /api/dashboard/stats  (admin)
  Future<DashboardStats> stats() async {
    final res =
        await _client.get<Map<String, dynamic>>(ApiConstants.dashboardStats);
    return DashboardStats.fromJson(res.data!);
  }
}
