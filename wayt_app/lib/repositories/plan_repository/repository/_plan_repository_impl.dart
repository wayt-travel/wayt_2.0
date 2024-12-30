part of 'plan_repository.dart';

class _PlanRepositoryImpl
    extends Repository<String, PlanSummaryEntity, PlanRepositoryState>
    implements PlanRepository, PlanRepositoryWithDataSource {
  @override
  final PlanDataSource dataSource;

  /// Map of user ids to the ids of the plans they own.
  final _userPlansMap = <String, List<String>>{};

  _PlanRepositoryImpl(this.dataSource);

  /// Adds a [plan] to the cache and map.
  void _addToCacheAndMap(PlanSummaryEntity plan) {
    _userPlansMap.putIfAbsent(plan.userId, () => []).add(plan.id);
    cache.save(plan.id, plan);
  }

  /// Adds a collection of [plans] to the cache and map.
  void _addAllToCacheAndMap(Iterable<PlanSummaryEntity> plans) {
    for (final plan in plans) {
      _addToCacheAndMap(plan);
    }
  }

  /// Removes a [plan] from the cache and map.
  void _removeFromCacheAndMap(PlanSummaryEntity plan) {
    cache.delete(plan.id);
    _userPlansMap[plan.userId]?.remove(plan.id);
  }

  @override
  Future<PlanEntity> create(CreatePlanInput input) async {
    logger.v('Creating plan with input: $input');
    final created = await dataSource.create(input);
    logger.v('${created.toShortString()} created. Adding to cache and map.');
    _addToCacheAndMap(created);
    emit(PlanRepositoryPlanAdded(created));
    logger.i('Plan created and added to cache and map [$created].');
    return created;
  }

  @override
  Future<FetchPlanResponse> fetchOne(String id) async {
    logger.v('Fetching plan with id: $id');
    final response = await dataSource.readById(id);
    final (:plan, :travelItems) = response;
    logger.v('${plan.toShortString()} fetched. Adding it to cache and map.');
    _addToCacheAndMap(plan);
    emit(PlanRepositoryPlanFetched(plan));
    logger.i('Plan fetched and added to cache and map [$plan].');
    return response;
  }

  @override
  Future<void> delete(String id) async {
    logger.v('Deleting plan with id: $id');
    await dataSource.delete(id);
    final deletedItem = cache.getOrThrow(id);
    logger.v(
      'Plan ${deletedItem.id} deleted. Removing it from cache and map.',
    );
    _removeFromCacheAndMap(deletedItem);
    emit(PlanRepositoryPlanDeleted(deletedItem));
    logger.i('Plan deleted and removed from cache and map [$deletedItem].');
  }

  @override
  Future<List<PlanSummaryEntity>> fetchAllOfUser(String userId) async {
    logger.v('Fetching all plans of user with id: $userId');
    final plans = await dataSource.readAllOfUser(userId);
    logger.v('${plans.length} plans fetched. Adding them to cache and map.');
    _addAllToCacheAndMap(plans);
    emit(PlanRepositoryPlanCollectionFetched(plans));
    logger.i('${plans.length} plans fetched and added to cache and map.');
    return plans;
  }

  @override
  void add(PlanEntity plan, {bool shouldEmit = true}) {
    logger.v('Adding ${plan.toShortString()} to cache and map');
    _addToCacheAndMap(plan);
    logger.i('${plan.toShortString()} added to cache and map');
    if (shouldEmit) {
      emit(PlanRepositoryPlanFetched(plan));
    }
  }

  @override
  void addAll(Iterable<PlanEntity> plans, {bool shouldEmit = true}) {
    logger.v('Adding ${plans.length} plans to cache and map');
    _addAllToCacheAndMap(plans.cast<PlanSummaryEntity>());
    logger.i('${plans.length} plans added to cache and map');
    if (shouldEmit) {
      emit(PlanRepositoryPlanCollectionFetched(plans.toList()));
    }
  }
}
