import '../user_repository.dart';

/// Data source for User entities.
abstract interface class UserDataSource {
  /// Reads a user by its [id].
  Future<UserEntity> read(String id);

  /// Reads the current authenticated user.
  Future<UserEntity> readMe();
}
