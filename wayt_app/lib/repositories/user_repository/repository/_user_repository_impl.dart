part of 'user_repository.dart';

class _UserRepositoryImpl
    extends Repository<String, UserEntity, UserRepositoryState>
    implements UserRepository {
  final UserDataSource _dataSource;

  _UserRepositoryImpl(this._dataSource);

  @override
  Future<UserEntity> fetchOne(String id) async {
    final item = await _dataSource.read(id);
    cache.save(item.id, item);
    emit(UserRepositoryUserFetched(item));
    return item;
  }

  @override
  Future<UserEntity> fetchMe() async {
    final item = await _dataSource.readMe();
    cache.save(item.id, item);
    emit(UserRepositoryUserFetched(item));
    return item;
  }
}
