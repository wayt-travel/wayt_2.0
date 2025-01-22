part of 'plan_repository.dart';

class _PlanRepositoryImpl
    extends Repository<String, PlanEntity, PlanRepositoryState>
    implements PlanRepository, PlanRepositoryWithDataSource {
  @override
  final PlanDataSource dataSource;

  /// Repository for the summary helper.
  final SummaryHelperRepository summaryHelperRepository;

  /// Map of user ids to a list of plan ids that the user has.
  final _userPlansMap = <String, List<String>>{};

  _PlanRepositoryImpl(this.dataSource, this.summaryHelperRepository);

  /// Adds a [plan] to the cache and map.
  void _addToCacheAndMap(PlanEntity plan) {
    _userPlansMap.putIfAbsent(plan.userId, () => []).add(plan.id);
    cache.save(plan.id, plan);
  }

  /// Adds a collection of [plans] to the cache and map.
  void _addAllToCacheAndMap(Iterable<PlanEntity> plans) {
    for (final plan in plans) {
      _addToCacheAndMap(plan);
    }
  }

  /// Removes a [plan] from the cache and map.
  void _removeFromCacheAndMap(PlanEntity plan) {
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
    // When the plan is created, it is fully loaded because it does not have
    // any items yet.
    summaryHelperRepository
        .setFullyLoaded(TravelDocumentId.journal(created.id));
    logger.i('Plan created and added to cache and map [$created].');
    return created;
  }

  @override
  Future<PlanWithItems> fetchOne(String id) async {
    logger.v('Fetching plan with id: $id');
    final response = await dataSource.readById(id);
    final (:plan, :travelItems) = response;
    logger.v('${plan.toShortString()} fetched. Adding it to cache and map.');
    _addToCacheAndMap(plan);
    emit(PlanRepositoryPlanFetched(plan));
    // The plan has been fully fetched but its items have not been loaded
    // completely yet, e.g., widgets have not been added to the widget
    // repository cache, so it is not fully loaded.
    summaryHelperRepository.unset(TravelDocumentId.journal(plan.id));
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
    // Remove the plan from the summary helper repository when it is deleted.
    summaryHelperRepository.unset(TravelDocumentId.journal(deletedItem.id));
    logger.i('Plan deleted and removed from cache and map [$deletedItem].');
  }

  @override
  Future<List<PlanEntity>> fetchAllOfUser(String userId) async {
    logger.v('Fetching all plans of user with id: $userId');
    final plans = await dataSource.readAllOfUser(userId);
    logger.v('${plans.length} plans fetched. Adding them to cache and map.');
    _addAllToCacheAndMap(plans);
    // Unsets all plans of the user from the summary helper repository.
    for (final plan in plans) {
      summaryHelperRepository.unset(TravelDocumentId.journal(plan.id));
    }
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
    _addAllToCacheAndMap(plans);
    logger.i('${plans.length} plans added to cache and map');
    if (shouldEmit) {
      emit(PlanRepositoryPlanCollectionFetched(plans.toList()));
    }
  }
}
