import 'package:equatable/equatable.dart';

class Patient extends Equatable {
  final int id;
  final String name;
  final String mrn;
  final String? medicalNotes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Patient({
    required this.id,
    required this.name,
    required this.mrn,
    required this.medicalNotes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Patient.fromJson(Map<String, dynamic> json) => Patient(
        id: json['id'] as int,
        name: json['name'] as String,
        mrn: json['mrn'] as String,
        medicalNotes: json['medical_notes'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: DateTime.parse(json['updated_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'mrn': mrn,
        'medical_notes': medicalNotes,
        'created_at': createdAt.toUtc().toIso8601String(),
        'updated_at': updatedAt.toUtc().toIso8601String(),
      };

  @override
  List<Object?> get props => [id, name, mrn, medicalNotes, createdAt, updatedAt];
}
