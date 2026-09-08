import '../../core/constants/api_constants.dart';
import '../../core/network/dio_client.dart';
import '../models/calendar_response.dart';
import '../models/delay_response.dart';
import '../models/schedule_proposal.dart';
import '../models/surgery.dart';
import '../models/surgery_priority.dart';
import '../models/surgery_status.dart';
import 'date_format.dart';

class SurgeryService {
  final DioClient _client;
  SurgeryService(this._client);

  // GET /api/surgeries  (coordinator)
  Future<List<Surgery>> list() async {
    final res =
        await _client.get<Map<String, dynamic>>(ApiConstants.surgeries);
    return (res.data!['data'] as List<dynamic>)
        .map((e) => Surgery.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // GET /api/surgeries/{surgery}  (coordinator)
  Future<Surgery> show(int id) async {
    final res =
        await _client.get<Map<String, dynamic>>(ApiConstants.surgery(id));
    return Surgery.fromJson(res.data!['data'] as Map<String, dynamic>);
  }

  // GET /api/surgeries/calendar  (coordinator)
  // Both params default server-side (today .. today+7d) when omitted.
  Future<CalendarResponse> calendar({DateTime? from, DateTime? to}) async {
    final res = await _client.get<Map<String, dynamic>>(
      ApiConstants.surgeriesCalendar,
      queryParameters: {
        if (from != null) 'from': formatServerDate(from),
        if (to != null) 'to': formatServerDate(to),
      },
    );
    return CalendarResponse.fromJson(res.data!);
  }

  // POST /api/surgeries  (coordinator)
  Future<Surgery> create({
    required int patientId,
    required int surgeonId,
    required int roomId,
    required int surgeryTypeId,
    required SurgeryPriority priority,
    required DateTime scheduledStart,
    int? estimatedDurationMin,
  }) async {
    final res = await _client.post<Map<String, dynamic>>(
      ApiConstants.surgeries,
      data: {
        'patient_id': patientId,
        'surgeon_id': surgeonId,
        'room_id': roomId,
        'surgery_type_id': surgeryTypeId,
        'priority': priority.value,
        'scheduled_start': formatServerDateTime(scheduledStart),
        if (estimatedDurationMin != null)
          'estimated_duration_min': estimatedDurationMin,
      },
    );
    return Surgery.fromJson(res.data!['data'] as Map<String, dynamic>);
  }

  // PUT/PATCH /api/surgeries/{surgery}  (coordinator)
  Future<Surgery> update(
    int id, {
    int? patientId,
    int? surgeonId,
    int? roomId,
    int? surgeryTypeId,
    SurgeryPriority? priority,
    DateTime? scheduledStart,
    int? estimatedDurationMin,
    SurgeryStatus? status,
  }) async {
    final res = await _client.put<Map<String, dynamic>>(
      ApiConstants.surgery(id),
      data: {
        if (patientId != null) 'patient_id': patientId,
        if (surgeonId != null) 'surgeon_id': surgeonId,
        if (roomId != null) 'room_id': roomId,
        if (surgeryTypeId != null) 'surgery_type_id': surgeryTypeId,
        if (priority != null) 'priority': priority.value,
        if (scheduledStart != null)
          'scheduled_start': formatServerDateTime(scheduledStart),
        if (estimatedDurationMin != null)
          'estimated_duration_min': estimatedDurationMin,
        if (status != null) 'status': status.value,
      },
    );
    return Surgery.fromJson(res.data!['data'] as Map<String, dynamic>);
  }

  // DELETE /api/surgeries/{surgery}  (coordinator)
  // Does not hard-delete — sets status=cancelled server-side.
  Future<String> cancel(int id) async {
    final res =
        await _client.delete<Map<String, dynamic>>(ApiConstants.surgery(id));
    return res.data!['message'] as String;
  }

  // POST /api/surgeries/auto-schedule  (coordinator)
  Future<List<ScheduleProposal>> autoSchedule(
    List<PendingSurgeryRequest> pending,
  ) async {
    final res = await _client.post<Map<String, dynamic>>(
      ApiConstants.surgeriesAutoSchedule,
      data: {'pending': pending.map((p) => p.toJson()).toList()},
    );
    return (res.data!['proposals'] as List<dynamic>)
        .map((e) => ScheduleProposal.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // GET /api/my-surgeries  (surgeon)
  Future<List<Surgery>> mySurgeries() async {
    final res =
        await _client.get<Map<String, dynamic>>(ApiConstants.mySurgeries);
    return (res.data!['data'] as List<dynamic>)
        .map((e) => Surgery.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // POST /api/surgeries/{surgery}/start  (surgeon)
  Future<Surgery> start(int id) async {
    final res = await _client
        .post<Map<String, dynamic>>(ApiConstants.surgeryStart(id));
    return Surgery.fromJson(res.data!['data'] as Map<String, dynamic>);
  }

  // POST /api/surgeries/{surgery}/complete  (surgeon)
  Future<Surgery> complete(int id) async {
    final res = await _client
        .post<Map<String, dynamic>>(ApiConstants.surgeryComplete(id));
    return Surgery.fromJson(res.data!['data'] as Map<String, dynamic>);
  }

  // POST /api/surgeries/{surgery}/delay  (surgeon)
  Future<DelayResponse> delay(int id) async {
    final res = await _client
        .post<Map<String, dynamic>>(ApiConstants.surgeryDelay(id));
    return DelayResponse.fromJson(res.data!);
  }
}
