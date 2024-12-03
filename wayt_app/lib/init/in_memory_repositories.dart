import '../repositories/repositories.dart';

({
  AuthRepository authRepo,
  UserRepository userRepo,
}) inMemoryRepositories() {
  final authenticationRepository = AuthRepository(
    InMemoryAuthDataSource(),
  );

  final userRepository = UserRepository(
    InMemoryUserDataSource(),
  );

  return (authRepo: authenticationRepository, userRepo: userRepository);
}
