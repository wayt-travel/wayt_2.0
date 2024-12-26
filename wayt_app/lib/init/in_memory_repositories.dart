import '../repositories/repositories.dart';
import 'in_memory_data.dart';

({
  AuthRepository authRepo,
  UserRepository userRepo,
  PlanRepository planRepo,
}) inMemoryRepositories() {
  final data = InMemoryData();

  final authenticationRepository = AuthRepository(
    InMemoryAuthDataSource(),
  );

  final userRepository = UserRepository(
    InMemoryUserDataSource(),
  );

  final planRepository = PlanRepository(
    InMemoryPlanDataSource(data),
  );

  return (
    authRepo: authenticationRepository,
    userRepo: userRepository,
    planRepo: planRepository,
  );
}
