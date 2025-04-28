part of 'auth_repository.dart';

/// Status of the authentication process.
enum AuthenticationStatus {
  /// The user is authenticated.
  authenticated,

  /// The user is unauthenticated.
  unauthenticated;

  /// Whether the status is authenticated.
  bool get isAuthenticated => this == authenticated;

  /// Whether the status is unauthenticated.
  bool get isUnauthenticated => this == unauthenticated;
}

/// State of the authentication repository.
class AuthRepositoryState extends Equatable {
  /// The status of the authentication process.
  final AuthenticationStatus status;

  /// The authenticated entity. 
  /// 
  /// This is null when the user is unauthenticated.
  final AuthEntity? auth;

  /// Creates a new instance of [AuthRepositoryState] for the authenticated
  /// entity [auth].
  const AuthRepositoryState.authenticated(AuthEntity this.auth)
      : status = AuthenticationStatus.authenticated;

  /// Creates a new instance of [AuthRepositoryState] for the unauthenticated
  /// entity.
  const AuthRepositoryState.unauthenticated()
      : status = AuthenticationStatus.unauthenticated,
        auth = null;

  @override
  List<Object?> get props => [status, auth];

  @override
  String toString() => '$AuthRepositoryState { $status }';
}
