import 'dart:async';

import 'package:flutter/foundation.dart';

/// Adapts a Bloc's Stream into a [Listenable] that go_router can subscribe
/// to for `refreshListenable`. Whenever the source stream emits, we call
/// [notifyListeners] and go_router re-evaluates its redirect rules.
///
/// This is the recommended pattern for making a Bloc-driven auth state
/// participate in go_router's declarative navigation.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
