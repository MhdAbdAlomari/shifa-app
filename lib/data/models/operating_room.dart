import 'package:equatable/equatable.dart';

import '../../core/constants/api_constants.dart';
import 'room_status.dart';

class OperatingRoom extends Equatable {
  final int id;
  final String name;
  // Nullable: POST /rooms without status returns null (documented quirk).
  final RoomStatus? status;
  final String? supportedSpecialty;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const OperatingRoom({
    required this.id,
    required this.name,
    required this.status,
    required this.supportedSpecialty,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OperatingRoom.fromJson(Map<String, dynamic> json) => OperatingRoom(
        id: json['id'] as int,
        name: json['name'] as String,
        status: json['status'] == null
            ? null
            : RoomStatus.fromString(json['status'] as String),
        supportedSpecialty: json['supported_specialty'] as String?,
        imageUrl: ApiConstants.resolveMediaUrl(json['image_url'] as String?),
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: DateTime.parse(json['updated_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'status': status?.value,
        'supported_specialty': supportedSpecialty,
        'image_url': imageUrl,
        'created_at': createdAt.toUtc().toIso8601String(),
        'updated_at': updatedAt.toUtc().toIso8601String(),
      };

  @override
  List<Object?> get props =>
      [id, name, status, supportedSpecialty, imageUrl, createdAt, updatedAt];
}
