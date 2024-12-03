part of 'auth_repository.dart';

enum AuthenticationStatus {
  authenticated,
  unauthenticated;

  bool get isAuthenticated => this == authenticated;
  bool get isUnauthenticated => this == unauthenticated;
}

class AuthRepositoryState {
  AuthRepositoryState.authenticated(
    CredentialsEntity this.credentialsEntity,
  ) : status = AuthenticationStatus.authenticated;

  AuthRepositoryState.unauthenticated()
      : status = AuthenticationStatus.unauthenticated,
        credentialsEntity = null;

  final AuthenticationStatus status;
  final CredentialsEntity? credentialsEntity;
}
