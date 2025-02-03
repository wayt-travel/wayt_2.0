import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:equatable/equatable.dart';

import '../auth_repository.dart';

part '_auth_repository_impl.dart';
part 'auth_repository_state.dart';

/// The repository for authentication.
abstract interface class AuthRepository
    extends SingletonRepository<AuthEntity, AuthRepositoryState> {
  /// Creates a new instance of [AuthRepository] that uses the provided data
  /// source.
  factory AuthRepository(AuthDataSource dataSource) =>
      _AuthRepositoryImpl(dataSource);

  /// Initializes the repository with an auth user.
  Future<void> init();

  /// Signs in the user with the provided [email] and [password].
  ///
  /// It emits an [AuthRepositoryState], so it is void.
  Future<void> signIn({
    required String email,
    required String password,
  });

  /// Signs out the current user.
  Future<void> signOut();
}
