import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/error/exceptions.dart';
import '../../data/services/notification_service.dart';

/// App-scoped cubit that tracks the current user's unread notification
/// count. The persistent header's bell uses this to decide whether to
/// paint its red dot on every screen.
///
/// We deliberately keep this stateless-ish (just an int) rather than
/// caching the full list, so the source of truth for individual items
/// remains the screen-scoped [NotificationsBloc]. The Notifications
/// screen calls [refresh] whenever it mutates read state so the bell
/// stays in sync.
class UnreadNotificationsCubit extends Cubit<int> {
  UnreadNotificationsCubit(this._service) : super(0);

  final NotificationService _service;

  Future<void> refresh() async {
    try {
      final items = await _service.list();
      emit(items.where((n) => !n.isRead).length);
    } on ApiException {
      // Swallow — a header decoration failure shouldn't disrupt UX.
    }
  }

  /// Direct-set the count. Used by the Notifications screen when it
  /// mutates read state locally — cheaper than re-fetching the list.
  void setCount(int value) => emit(value);

  void reset() => emit(0);
}
