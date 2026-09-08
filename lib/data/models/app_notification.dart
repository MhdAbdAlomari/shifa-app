import 'package:equatable/equatable.dart';

// Named AppNotification to avoid collision with Flutter's Notification widget class.
class AppNotification extends Equatable {
  final int id;
  final int userId;
  final String title;
  final String body;
  // Only 'schedule_suggestion' is observed in the doc, but the field is a free
  // string server-side, so we keep it as String rather than a closed enum.
  final String type;
  final DateTime? readAt;
  final DateTime createdAt;

  const AppNotification({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    required this.readAt,
    required this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      AppNotification(
        id: json['id'] as int,
        userId: json['user_id'] as int,
        title: json['title'] as String,
        body: json['body'] as String,
        type: json['type'] as String,
        readAt: json['read_at'] == null
            ? null
            : DateTime.parse(json['read_at'] as String),
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'title': title,
        'body': body,
        'type': type,
        'read_at': readAt?.toUtc().toIso8601String(),
        'created_at': createdAt.toUtc().toIso8601String(),
      };

  bool get isRead => readAt != null;

  @override
  List<Object?> get props =>
      [id, userId, title, body, type, readAt, createdAt];
}
