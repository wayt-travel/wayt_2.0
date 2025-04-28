part of 'travel_document_repository.dart';

enum _TravelDocumentType {
  plans,
  journals;

  bool get isPlans => this == plans;
  bool get isJournals => this == journals;
}

class _TravelDocumentRepositoryImpl extends Repository<String,
        TravelDocumentEntity, TravelDocumentRepositoryState>
    implements
        TravelDocumentRepository,
        TravelDocumentRepositoryWithDataSource {
  @override
  final TravelDocumentDataSource dataSource;

  /// Repository for the summary helper.
  final SummaryHelperRepository summaryHelperRepository;

  /// Map of user ids to the plans and journals owned by the user.
  final _userPlansMap = <String, ({Set<String> plans, Set<String> journals})>{};

  _TravelDocumentRepositoryImpl(this.dataSource, this.summaryHelperRepository);

  /// Adds a [travelDocument] to the cache and map.
  void _addToCacheAndMap(TravelDocumentEntity travelDocument) {
    _userPlansMap
        .putIfAbsent(travelDocument.userId, () => (journals: {}, plans: {}))
        .let((data) => travelDocument.isJournal ? data.journals : data.plans)
        .add(travelDocument.id);
    cache.save(travelDocument.id, travelDocument);
  }

  /// Clears the cache and map.
  void _clearCacheAndMap(_TravelDocumentType type) {
    for (final userId in _userPlansMap.keys) {
      if (type.isPlans) {
        _userPlansMap[userId]?.plans.clear();
        cache.deleteAll(
          cache.items.values.where((e) => e.isPlan).map((e) => e.id),
        );
      }
      if (type.isJournals) {
        _userPlansMap[userId]?.journals.clear();
        cache.deleteAll(
          cache.items.values.where((e) => e.isJournal).map((e) => e.id),
        );
      }
    }
  }

  /// Adds a collection of [travelDocuments] to the cache and map.
  void _addAllToCacheAndMap(Iterable<TravelDocumentEntity> travelDocuments) {
    for (final plan in travelDocuments) {
      _addToCacheAndMap(plan);
    }
  }

  /// Removes a [travelDocument] from the cache and map.
  void _removeFromCacheAndMap(TravelDocumentEntity travelDocument) {
    cache.delete(travelDocument.id);
    _userPlansMap[travelDocument.userId]
        ?.let((data) => travelDocument.isJournal ? data.journals : data.plans)
        .remove(travelDocument.id);
  }

  @override
  Future<PlanEntity> createPlan(CreatePlanInput input) async {
    logger.d('Creating plan with input: $input');
    final created = await dataSource.createPlan(input);
    logger.d('${created.toShortString()} created. Adding to cache and map.');
    _addToCacheAndMap(created);
    emit(TravelDocumentRepositoryEntityAdded(created));
    // When the plan is created, it is fully loaded because it does not have
    // any items yet.
    summaryHelperRepository
        .setFullyLoaded(TravelDocumentId.journal(created.id));
    logger.i('Plan created and added to cache and map [$created].');
    return created;
  }

  @override
  Future<TravelDocumentWrapper> fetchOne(String id) async {
    logger.d('Fetching travel document with id: $id');
    final wrapper = await dataSource.readById(id);
    final travelDocument = wrapper.travelDocument;
    logger.d(
      '${travelDocument.toShortString()} fetched. Adding it to cache and map.',
    );
    _addToCacheAndMap(travelDocument);
    emit(TravelDocumentRepositoryItemFetched(travelDocument));
    // The travel document has been fully fetched but its items have not been
    // loaded completely yet, e.g., widgets have not been added to the travel
    // items repository cache, so it is not fully loaded.
    summaryHelperRepository.unset(TravelDocumentId.journal(travelDocument.id));
    logger.i(
      'Travel document fetched and added to cache and map [$travelDocument].',
    );
    return wrapper;
  }

  @override
  Future<void> delete(String id) async {
    logger.d('Deleting plan with id: $id');
    await dataSource.delete(id);
    final deletedItem = cache.getOrThrow(id);
    logger.d(
      'Plan ${deletedItem.id} deleted. Removing it from cache and map.',
    );
    _removeFromCacheAndMap(deletedItem);
    emit(TravelDocumentRepositoryItemDeleted(deletedItem));
    // Remove the plan from the summary helper repository when it is deleted.
    summaryHelperRepository.unset(TravelDocumentId.journal(deletedItem.id));
    logger.i('Plan deleted and removed from cache and map [$deletedItem].');
  }

  @override
  Future<List<PlanEntity>> fetchAllPlansOfUser(String userId) async {
    logger.d('Fetching all plans of user with id: $userId');
    final plans = await dataSource.readAllPlansOfUser(userId);
    logger.d('${plans.length} plans fetched. Adding them to cache and map.');
    _clearCacheAndMap(_TravelDocumentType.plans);
    _addAllToCacheAndMap(plans);
    // Unsets all plans of the user from the summary helper repository.
    for (final plan in plans) {
      summaryHelperRepository.unset(TravelDocumentId.journal(plan.id));
    }
    emit(TravelDocumentRepositoryCollectionFetched(plans));
    logger.i('${plans.length} plans fetched and added to cache and map.');
    return plans;
  }

  @override
  void add(TravelDocumentEntity travelDocument, {bool shouldEmit = true}) {
    logger.d('Adding ${travelDocument.toShortString()} to cache and map');
    _addToCacheAndMap(travelDocument);
    logger.i('${travelDocument.toShortString()} added to cache and map');
    if (shouldEmit) {
      emit(TravelDocumentRepositoryItemFetched(travelDocument));
    }
  }

  @override
  void addAll(
    Iterable<TravelDocumentEntity> travelDocuments, {
    bool shouldEmit = true,
  }) {
    logger.d('Adding ${travelDocuments.length} plans to cache and map');
    _addAllToCacheAndMap(travelDocuments);
    logger.i('${travelDocuments.length} plans added to cache and map');
    if (shouldEmit) {
      emit(TravelDocumentRepositoryCollectionFetched(travelDocuments.toList()));
    }
  }

  @override
  List<TravelDocumentEntity> getAllOfUser(String userId) =>
      _userPlansMap[userId]
          ?.let(
            (data) => [
              ...data.plans.map(cache.getOrThrow),
              ...data.journals.map(cache.getOrThrow),
            ],
          )
          .toList() ??
      [];

  @override
  Future<PlanEntity> updatePlan(String id, UpdatePlanInput input) async {
    logger.d('Updating the plan with id $id and input: $input');
    final previous = cache.getOrThrow(id);
    final updated = await dataSource.updatePlan(id, input: input);
    logger.d('${updated.toShortString()} updated. Updating to cache and map.');
    _addToCacheAndMap(updated);
    emit(TravelDocumentRepositoryItemUpdated(previous, updated));
    logger.i('Plan updated to cache and map [$updated].');
    return updated;
  }
}
