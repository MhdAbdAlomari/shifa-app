import 'package:equatable/equatable.dart';

class SurgeryType extends Equatable {
  final int id;
  final String name;
  final int averageDurationMin;
  final String? requiredSpecialty;
  final int? defaultRoomId;

  const SurgeryType({
    required this.id,
    required this.name,
    required this.averageDurationMin,
    required this.requiredSpecialty,
    required this.defaultRoomId,
  });

  factory SurgeryType.fromJson(Map<String, dynamic> json) => SurgeryType(
        id: json['id'] as int,
        name: json['name'] as String,
        averageDurationMin: json['average_duration_min'] as int,
        requiredSpecialty: json['required_specialty'] as String?,
        defaultRoomId: json['default_room_id'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'average_duration_min': averageDurationMin,
        'required_specialty': requiredSpecialty,
        'default_room_id': defaultRoomId,
      };

  @override
  List<Object?> get props =>
      [id, name, averageDurationMin, requiredSpecialty, defaultRoomId];
}
