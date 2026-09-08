import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/error/exceptions.dart';
import '../../core/network/auth_token_storage.dart';
import '../../data/models/user.dart';
import '../../data/services/auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// Owns the app-wide authentication session.
///
/// Everything auth-related lives here: bootstrapping from a persisted
/// token on cold start, exchanging credentials for a token during login,
/// and revoking it during logout. Every other Bloc in the app assumes an
/// authenticated user exists — this one is what guarantees that.
///
/// Kept intentionally UI-agnostic: it holds no BuildContext, no
/// navigation, no widgets. The router listens to its stream and
/// redirects; screens listen to it and update their UI.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required AuthService authService,
    required AuthTokenStorage tokenStorage,
  })  : _authService = authService,
        _tokenStorage = tokenStorage,
        super(const AuthState.unknown()) {
    on<AuthStartupRequested>(_onStartup);
    on<AuthLoginRequested>(_onLogin);
    on<AuthLogoutRequested>(_onLogout);
  }

  final AuthService _authService;
  final AuthTokenStorage _tokenStorage;

  /// On startup we optimistically probe `/api/me` if a token exists in
  /// secure storage. Why not trust the token blindly? Because tokens can
  /// be revoked server-side (logout on another device, admin deletion) —
  /// probing gives us an authoritative answer before we route the user
  /// into an authenticated area they'll immediately get 401'd out of.
  Future<void> _onStartup(
    AuthStartupRequested event,
    Emitter<AuthState> emit,
  ) async {
    final token = await _tokenStorage.read();
    if (token == null || token.isEmpty) {
      emit(state.copyWith(status: AuthStatus.unauthenticated, clearUser: true));
      return;
    }
    try {
      final user = await _authService.me();
      emit(state.copyWith(status: AuthStatus.authenticated, user: user));
    } on UnauthenticatedException {
      await _tokenStorage.clear();
      emit(state.copyWith(status: AuthStatus.unauthenticated, clearUser: true));
    } on ApiException {
      // Network or server errors on startup shouldn't wipe the token —
      // the user may just be offline. Fall back to unauthenticated so
      // the router shows Login, but leave the token in place.
      emit(state.copyWith(status: AuthStatus.unauthenticated, clearUser: true));
    }
  }

  Future<void> _onLogin(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.authenticating, clearError: true));
    try {
      final response = await _authService.login(
        email: event.email,
        password: event.password,
      );
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: response.user,
      ));
    } on ValidationException catch (e) {
      // 422 is the primary "bad credentials" path in this API — the
      // server returns errors keyed on `email` even when the fault is
      // the password. Show the top message rather than a per-field one.
      emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: e.message,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: e.message,
      ));
    }
  }

  Future<void> _onLogout(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    // Best-effort server logout — even if it fails (offline, revoked
    // token), we still drop the local session so the user can't be
    // stranded on an authenticated screen with no way back to login.
    try {
      await _authService.logout();
    } on ApiException {
      // swallow — local logout below is the source of truth
    }
    await _tokenStorage.clear();
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }
}
