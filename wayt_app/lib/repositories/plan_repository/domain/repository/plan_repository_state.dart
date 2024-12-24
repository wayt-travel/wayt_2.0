part of 'plan_repository.dart';

typedef PlanRepositoryState = RepositoryState<IPlanEntity>;

typedef PlanRepositoryPlanAdded = RepositoryItemAdded<PlanEntity>;
typedef PlanRepositoryPlanCollectionFetched
    = RepositoryCollectionFetched<PlanSummaryEntity>;
typedef PlanRepositoryPlanFetched = RepositoryItemFetched<PlanEntity>;
typedef PlanRepositoryPlanUpdated = RepositoryItemUpdated<PlanEntity>;
typedef PlanRepositoryPlanDeleted = RepositoryItemDeleted<IPlanEntity>;
