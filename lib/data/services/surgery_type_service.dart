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
}
