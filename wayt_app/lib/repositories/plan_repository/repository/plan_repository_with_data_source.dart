import '../../repositories.dart';

/// Interface that exposes the [PlanDataSource] instance of the repository.
abstract interface class PlanRepositoryWithDataSource
    implements PlanRepository {
  PlanDataSource get dataSource;
}
