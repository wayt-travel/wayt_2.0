part of 'auth_repository.dart';

class _AuthRepositoryImpl
    extends SingletonRepository<AuthEntity, AuthRepositoryState>
    implements AuthRepository {
  final AuthDataSource dataSource;

  _AuthRepositoryImpl(this.dataSource);

  @override
  Future<void> init() async {
    // TODO: Implement auth init method
    await Future<void>.delayed(const Duration(seconds: 1));
    emit(const AuthRepositoryState.unauthenticated());
  }

  @override
  Future<void> signIn({required String email, required String password}) async {
    logger.v('Signing in with email: $email');
    final authUser = await dataSource.signIn(email: email, password: password);
    logger.d('Signed in: $authUser');
    cache.save(authUser);
    emit(AuthRepositoryState.authenticated(authUser));
  }

  @override
  Future<void> signOut() {
    throw UnimplementedError();
  }
}
