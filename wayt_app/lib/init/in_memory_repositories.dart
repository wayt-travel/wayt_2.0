import '../repositories/repositories.dart';
import 'in_memory_data.dart';

typedef RepositoryPack = ({
  AuthRepository authRepo,
  UserRepository userRepo,
  PlanRepository planRepo,
  WidgetRepository widgetRepo,
  TravelItemRepository travelItemRepo,
});

RepositoryPack inMemoryRepositories() {
  final data = InMemoryData();
  final authRepository = AuthRepository(InMemoryAuthDataSource(data));
  final userRepository = UserRepository(InMemoryUserDataSource(data));
  final planRepository = PlanRepository(InMemoryPlanDataSource(data));
  final widgetRepository = WidgetRepository(InMemoryWidgetDataSource(data));
  final travelItemRepository = TravelItemRepository(
    widgetRepository: widgetRepository,
  );

  return (
    authRepo: authRepository,
    userRepo: userRepository,
    planRepo: planRepository,
    widgetRepo: widgetRepository,
    travelItemRepo: travelItemRepository,
  );
}
