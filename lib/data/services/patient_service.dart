import '../../core/constants/api_constants.dart';
import '../../core/network/dio_client.dart';
import '../models/patient.dart';

class PatientService {
  final DioClient _client;
  PatientService(this._client);

  // GET /api/patients
  Future<List<Patient>> list() async {
    final res = await _client.get<Map<String, dynamic>>(ApiConstants.patients);
    return (res.data!['data'] as List<dynamic>)
        .map((e) => Patient.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // GET /api/patients/{patient}
  Future<Patient> show(int id) async {
    final res =
        await _client.get<Map<String, dynamic>>(ApiConstants.patient(id));
    return Patient.fromJson(res.data!['data'] as Map<String, dynamic>);
  }

  // POST /api/patients
  Future<Patient> create({
    required String name,
    required String mrn,
    String? medicalNotes,
  }) async {
    final res = await _client.post<Map<String, dynamic>>(
      ApiConstants.patients,
      data: {
        'name': name,
        'mrn': mrn,
        if (medicalNotes != null) 'medical_notes': medicalNotes,
      },
    );
    return Patient.fromJson(res.data!['data'] as Map<String, dynamic>);
  }

  // PUT/PATCH /api/patients/{patient}
  // Pass clearMedicalNotes: true to explicitly set medical_notes to null;
  // omit the field entirely to leave it unchanged.
  Future<Patient> update(
    int id, {
    String? name,
    String? mrn,
    String? medicalNotes,
    bool clearMedicalNotes = false,
  }) async {
    final res = await _client.put<Map<String, dynamic>>(
      ApiConstants.patient(id),
      data: {
        if (name != null) 'name': name,
        if (mrn != null) 'mrn': mrn,
        if (medicalNotes != null)
          'medical_notes': medicalNotes
        else if (clearMedicalNotes)
          'medical_notes': null,
      },
    );
    return Patient.fromJson(res.data!['data'] as Map<String, dynamic>);
  }

  // DELETE /api/patients/{patient}
  Future<String> delete(int id) async {
    final res =
        await _client.delete<Map<String, dynamic>>(ApiConstants.patient(id));
    return res.data!['message'] as String;
  }
}
