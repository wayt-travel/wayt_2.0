part of 'auth_repository.dart';

enum AuthenticationStatus {
  authenticated,
  unauthenticated;

  bool get isAuthenticated => this == authenticated;
  bool get isUnauthenticated => this == unauthenticated;
}

class AuthRepositoryState extends Equatable {
  final AuthenticationStatus status;
  final AuthEntity? auth;

  const AuthRepositoryState.authenticated(AuthEntity this.auth)
      : status = AuthenticationStatus.authenticated;

  const AuthRepositoryState.unauthenticated()
      : status = AuthenticationStatus.unauthenticated,
        auth = null;

  @override
  List<Object?> get props => [status, auth];

  @override
  String toString() => '$AuthRepositoryState { $status }';
}
