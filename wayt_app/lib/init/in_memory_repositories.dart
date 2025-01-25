import '../repositories/repositories.dart';
import 'in_memory_data.dart';

typedef RepositoryPack = ({
  AuthRepository authRepo,
  UserRepository userRepo,
  SummaryHelperRepository summaryHelperRepo,
  PlanRepository planRepo,
  TravelItemRepository travelItemRepo,
});

RepositoryPack inMemoryRepositories() {
  final data = InMemoryDataHelper();
  final authRepository = AuthRepository(InMemoryAuthDataSource(data));
  final userRepository = UserRepository(InMemoryUserDataSource(data));
  final summaryHelperRepository = SummaryHelperRepository();
  final planRepository = PlanRepository(
    dataSource: InMemoryPlanDataSource(data),
    summaryHelperRepository: summaryHelperRepository,
  );
  final travelItemRepository = TravelItemRepository(
    summaryHelperRepository: summaryHelperRepository,
    widgetDataSource: InMemoryWidgetDataSource(data),
    widgetFolderDataSource: InMemoryWidgetFolderDataSource(data),
  );

  return (
    authRepo: authRepository,
    userRepo: userRepository,
    summaryHelperRepo: summaryHelperRepository,
    planRepo: planRepository,
    travelItemRepo: travelItemRepository,
  );
}
