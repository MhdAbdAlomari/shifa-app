part of 'auth_bloc.dart';

/// Events that can drive the [AuthBloc].
///
/// All authentication actions — from app startup to logout — flow through
/// this sealed class, giving us exhaustiveness checking on the `switch`
/// inside the Bloc.
sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => const [];
}

/// Fired once at app startup. The Bloc checks the secure store for a
/// persisted token and calls `GET /api/me` to hydrate the current user.
class AuthStartupRequested extends AuthEvent {
  const AuthStartupRequested();
}

/// Emitted by the Login screen with the credentials the user typed in.
class AuthLoginRequested extends AuthEvent {
  const AuthLoginRequested({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

/// Fired when the user taps "Log out" — revokes the token server-side
/// and drops the local session.
class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}
