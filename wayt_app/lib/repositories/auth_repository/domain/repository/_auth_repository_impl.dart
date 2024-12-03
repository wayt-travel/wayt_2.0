part of 'auth_repository.dart';

class _AuthRepositoryImpl
    extends SingletonRepository<CredentialsEntity, AuthRepositoryState>
    implements AuthRepository {
  final AuthDataSource dataSource;

  _AuthRepositoryImpl(this.dataSource);

  @override
  Future<void> init() async {
    // TODO:
    await Future<void>.delayed(const Duration(seconds: 1));
    emit(AuthRepositoryState.unauthenticated());
  }
}
