import 'package:a2f_sdk/a2f_sdk.dart';

import '../../auth_repository.dart';

part '_auth_repository_impl.dart';
part 'auth_repository_state.dart';

abstract interface class AuthRepository
    extends SingletonRepository<CredentialsEntity, AuthRepositoryState> {
  /// Creates a new instance of [AuthRepository] that uses the provided data
  /// source.
  factory AuthRepository(AuthDataSource dataSource) =>
      _AuthRepositoryImpl(dataSource);

  Future<void> init();
}
