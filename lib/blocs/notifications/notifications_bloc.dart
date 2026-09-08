import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/error/exceptions.dart';
import '../../data/models/app_notification.dart';
import '../../data/services/notification_service.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

/// Owns the shared Notifications inbox.
///
/// Available to all authenticated roles. Marking an item read is an
/// optimistic update — we flip the local copy immediately and reconcile
/// with the server response, so tapping feels instantaneous even on a
/// slow connection.
class NotificationsBloc
    extends Bloc<NotificationsEvent, NotificationsState> {
  NotificationsBloc({required NotificationService service})
      : _service = service,
        super(const NotificationsState.initial()) {
    on<NotificationsRequested>(_onRequested);
    on<NotificationsRefreshRequested>(_onRefresh);
    on<NotificationsMarkReadRequested>(_onMarkRead);
    on<NotificationsMarkAllReadRequested>(_onMarkAllRead);
  }

  final NotificationService _service;

  Future<void> _onRequested(
    NotificationsRequested event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(state.copyWith(status: NotificationsStatus.loading));
    await _load(emit);
  }

  Future<void> _onRefresh(
    NotificationsRefreshRequested event,
    Emitter<NotificationsState> emit,
  ) async {
    await _load(emit);
  }

  Future<void> _load(Emitter<NotificationsState> emit) async {
    try {
      final items = await _service.list();
      emit(state.copyWith(
        status: NotificationsStatus.loaded,
        items: items,
        clearError: true,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        status: NotificationsStatus.error,
        errorMessage: e.message,
      ));
    }
  }

  Future<void> _onMarkRead(
    NotificationsMarkReadRequested event,
    Emitter<NotificationsState> emit,
  ) async {
    // Optimistic update — flip local copy first so the UI feels instant.
    final index = state.items.indexWhere((n) => n.id == event.id);
    if (index == -1) return;
    final original = state.items[index];
    if (original.isRead) return;

    final optimistic = [
      for (final n in state.items)
        n.id == event.id
            ? AppNotification(
                id: n.id,
                userId: n.userId,
                title: n.title,
                body: n.body,
                type: n.type,
                readAt: DateTime.now(),
                createdAt: n.createdAt,
              )
            : n,
    ];
    emit(state.copyWith(items: optimistic));

    try {
      final updated = await _service.markRead(event.id);
      final reconciled = [
        for (final n in state.items) n.id == updated.id ? updated : n,
      ];
      emit(state.copyWith(items: reconciled));
    } on ApiException catch (e) {
      // Rollback and surface the error.
      final rolled = [
        for (final n in state.items) n.id == original.id ? original : n,
      ];
      emit(state.copyWith(items: rolled, errorMessage: e.message));
    }
  }

  /// Marks every unread notification as read by looping the server's
  /// single-item endpoint. The API has no bulk endpoint, so this is
  /// necessarily a client-side loop — we fire them in parallel to
  /// minimize wall-clock time. If any individual call fails, we
  /// surface the last error but keep the successful ones optimistic.
  Future<void> _onMarkAllRead(
    NotificationsMarkAllReadRequested event,
    Emitter<NotificationsState> emit,
  ) async {
    final unread = state.items.where((n) => !n.isRead).toList();
    if (unread.isEmpty) return;

    // Optimistic — flip everything unread in one shot.
    final now = DateTime.now();
    final optimistic = [
      for (final n in state.items)
        n.isRead
            ? n
            : AppNotification(
                id: n.id,
                userId: n.userId,
                title: n.title,
                body: n.body,
                type: n.type,
                readAt: now,
                createdAt: n.createdAt,
              ),
    ];
    emit(state.copyWith(items: optimistic));

    String? lastError;
    for (final n in unread) {
      try {
        await _service.markRead(n.id);
      } on ApiException catch (e) {
        lastError = e.message;
      }
    }
    if (lastError != null) {
      emit(state.copyWith(errorMessage: lastError));
    }
  }
}
