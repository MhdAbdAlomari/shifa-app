import '../../core/constants/api_constants.dart';
import '../../core/network/dio_client.dart';
import '../models/schedule_suggestion.dart';

class ScheduleSuggestionService {
  final DioClient _client;
  ScheduleSuggestionService(this._client);

  // GET /api/schedule-suggestions  (coordinator)
  Future<List<ScheduleSuggestion>> list() async {
    final res = await _client
        .get<Map<String, dynamic>>(ApiConstants.scheduleSuggestions);
    return (res.data!['data'] as List<dynamic>)
        .map((e) => ScheduleSuggestion.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // POST /api/schedule-suggestions/{suggestion}/accept  (coordinator)
  Future<ScheduleSuggestion> accept(int id) async {
    final res = await _client.post<Map<String, dynamic>>(
      ApiConstants.scheduleSuggestionAccept(id),
    );
    return ScheduleSuggestion.fromJson(
        res.data!['data'] as Map<String, dynamic>);
  }

  // POST /api/schedule-suggestions/{suggestion}/reject  (coordinator)
  Future<ScheduleSuggestion> reject(int id) async {
    final res = await _client.post<Map<String, dynamic>>(
      ApiConstants.scheduleSuggestionReject(id),
    );
    return ScheduleSuggestion.fromJson(
        res.data!['data'] as Map<String, dynamic>);
  }
}
