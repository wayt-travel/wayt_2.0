import '../../repositories.dart';

/// Data source for Auth entities.
abstract interface class AuthDataSource {
  /// Sign in with the given [email] and [password].
  ///
  /// Returns the authenticated [AuthEntity].
  Future<AuthEntity> signIn({
    required String email,
    required String password,
  });

  /// Sign out the current user.
  Future<void> signOut();
}
