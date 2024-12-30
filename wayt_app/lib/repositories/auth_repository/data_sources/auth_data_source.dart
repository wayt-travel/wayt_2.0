import '../../repositories.dart';

/// Data source for Auth entities.
abstract interface class AuthDataSource {
  Future<AuthEntity> signIn({
    required String email,
    required String password,
  });

  Future<void> signOut();
}
