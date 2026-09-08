part of 'notifications_bloc.dart';

sealed class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object?> get props => const [];
}

class NotificationsRequested extends NotificationsEvent {
  const NotificationsRequested();
}

class NotificationsRefreshRequested extends NotificationsEvent {
  const NotificationsRefreshRequested();
}

class NotificationsMarkReadRequested extends NotificationsEvent {
  const NotificationsMarkReadRequested(this.id);

  final int id;

  @override
  List<Object?> get props => [id];
}

/// Fires when the user taps "Mark all read" in the header — sweeps
/// every unread notification through the single-item endpoint.
class NotificationsMarkAllReadRequested extends NotificationsEvent {
  const NotificationsMarkAllReadRequested();
}
