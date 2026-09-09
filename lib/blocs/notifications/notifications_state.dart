part of 'notifications_bloc.dart';

enum NotificationsStatus { initial, loading, loaded, error }

class NotificationsState extends Equatable {
  const NotificationsState({
    required this.status,
    required this.items,
    this.errorMessage,
    this.errorCode,
  });

  const NotificationsState.initial()
      : status = NotificationsStatus.initial,
        items = const [],
        errorMessage = null,
        errorCode = null;

  final NotificationsStatus status;
  final List<AppNotification> items;
  final String? errorMessage;

  /// error_code paired with [errorMessage] — see error_code_l10n.dart.
  final String? errorCode;

  int get unreadCount => items.where((n) => !n.isRead).length;

  NotificationsState copyWith({
    NotificationsStatus? status,
    List<AppNotification>? items,
    String? errorMessage,
    String? errorCode,
    bool clearError = false,
  }) {
    return NotificationsState(
      status: status ?? this.status,
      items: items ?? this.items,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      errorCode: clearError ? null : (errorCode ?? this.errorCode),
    );
  }

  @override
  List<Object?> get props => [status, items, errorMessage, errorCode];
}
