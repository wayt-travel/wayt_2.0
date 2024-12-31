import 'package:a2f_sdk/a2f_sdk.dart';

import '../user_repository.dart';

part '_user_repository_impl.dart';
part 'user_repository_state.dart';

abstract interface class UserRepository
    extends Repository<String, UserEntity, UserRepositoryState> {
  /// Creates a new instance of [UserRepository] that uses the provided data
  /// source.
  factory UserRepository(UserDataSource dataSource) =>
      _UserRepositoryImpl(dataSource);

  /// Fetches a user by its [id].
  Future<UserEntity> fetchOne(String id);

  /// Fetches the current authenticated user.
  Future<UserEntity> fetchMe();
}
