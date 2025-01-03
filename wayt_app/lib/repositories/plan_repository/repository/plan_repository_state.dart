part of 'plan_repository.dart';

typedef PlanRepositoryState = RepositoryState<PlanEntity>;

typedef PlanRepositoryPlanAdded = RepositoryItemAdded<PlanEntity>;
typedef PlanRepositoryPlanCollectionFetched
    = RepositoryCollectionFetched<PlanEntity>;
typedef PlanRepositoryPlanFetched = RepositoryItemFetched<PlanEntity>;
typedef PlanRepositoryPlanUpdated = RepositoryItemUpdated<PlanEntity>;
typedef PlanRepositoryPlanDeleted = RepositoryItemDeleted<PlanEntity>;
