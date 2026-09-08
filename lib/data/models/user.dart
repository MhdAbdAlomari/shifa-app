import 'package:equatable/equatable.dart';

import 'user_role.dart';

class User extends Equatable {
  final int id;
  final String name;
  final String email;
  final UserRole role;
  final String? specialty;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.specialty,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as int,
        name: json['name'] as String,
        email: json['email'] as String,
        role: UserRole.fromString(json['role'] as String),
        specialty: json['specialty'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'role': role.value,
        'specialty': specialty,
        'created_at': createdAt.toUtc().toIso8601String(),
      };

  @override
  List<Object?> get props => [id, name, email, role, specialty, createdAt];
}
