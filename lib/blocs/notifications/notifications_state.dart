part of 'notifications_bloc.dart';

enum NotificationsStatus { initial, loading, loaded, error }

class NotificationsState extends Equatable {
  const NotificationsState({
    required this.status,
    required this.items,
    this.errorMessage,
  });

  const NotificationsState.initial()
      : status = NotificationsStatus.initial,
        items = const [],
        errorMessage = null;

  final NotificationsStatus status;
  final List<AppNotification> items;
  final String? errorMessage;

  int get unreadCount => items.where((n) => !n.isRead).length;

  NotificationsState copyWith({
    NotificationsStatus? status,
    List<AppNotification>? items,
    String? errorMessage,
    bool clearError = false,
  }) {
    return NotificationsState(
      status: status ?? this.status,
      items: items ?? this.items,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, items, errorMessage];
}
