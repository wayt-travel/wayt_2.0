part of 'user_repository.dart';

class _UserRepositoryImpl
    extends SingletonRepository<UserEntity, UserRepositoryState>
    implements UserRepository {
  final UserDataSource dataSource;

  _UserRepositoryImpl(this.dataSource);

  @override
  Future<void> fetch() {
    // TODO: implement fetch
    throw UnimplementedError();
  }

  @override
  void reset() {
    // TODO: implement reset
  }
}
