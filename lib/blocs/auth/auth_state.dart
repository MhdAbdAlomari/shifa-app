part of 'auth_bloc.dart';

/// State of the app-wide authentication session.
///
/// [AuthStatus] is what the router keys off of — its `redirect` callback
/// reads the current status and rewrites navigation accordingly (send
/// unauthenticated users to Login, authenticated users to their
/// role-specific home).
enum AuthStatus { unknown, authenticating, authenticated, unauthenticated }

class AuthState extends Equatable {
  const AuthState({
    required this.status,
    this.user,
    this.errorMessage,
    this.errorCode,
  });

  const AuthState.unknown() : this(status: AuthStatus.unknown);

  final AuthStatus status;
  final User? user;

  /// Populated only when [status] is unauthenticated *after* a failed login
  /// or logout call. The Login screen displays it in a SnackBar.
  final String? errorMessage;

  /// error_code paired with [errorMessage] — see error_code_l10n.dart.
  final String? errorCode;

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
    String? errorCode,
    bool clearUser = false,
    bool clearError = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: clearUser ? null : (user ?? this.user),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      errorCode: clearError ? null : (errorCode ?? this.errorCode),
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage, errorCode];
}
