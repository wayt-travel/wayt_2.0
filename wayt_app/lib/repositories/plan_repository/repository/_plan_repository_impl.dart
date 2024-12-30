part of 'plan_repository.dart';

class _PlanRepositoryImpl
    extends Repository<String, PlanSummaryEntity, PlanRepositoryState>
    implements PlanRepository {
  final PlanDataSource _dataSource;

  /// Map of user ids to the ids of the plans they own.
  final _userPlansMap = <String, List<String>>{};

  _PlanRepositoryImpl(this._dataSource);

  void _addToMap(PlanSummaryEntity plan) {
    _userPlansMap.putIfAbsent(plan.userId, () => []).add(plan.id);
  }

  void addAllToMap(List<PlanSummaryEntity> plans) {
    for (final plan in plans) {
      _addToMap(plan);
    }
  }

  @override
  Future<PlanEntity> create(CreatePlanInput input) async {
    final created = await _dataSource.create(input);
    cache.save(created.id, created);
    _addToMap(created);
    emit(PlanRepositoryPlanAdded(created));
    return created;
  }

  @override
  Future<PlanEntity> fetchOne(String id) async {
    final item = await _dataSource.readById(id);
    cache.save(item.id, item);
    _addToMap(item);
    emit(PlanRepositoryPlanFetched(item));
    return item;
  }

  @override
  Future<void> delete(String id) async {
    await _dataSource.delete(id);
    final deletedItem = cache.getOrThrow(id);
    cache.delete(id);
    _userPlansMap[deletedItem.userId]?.remove(id);
    emit(PlanRepositoryPlanDeleted(deletedItem));
  }

  @override
  Future<List<PlanSummaryEntity>> fetchAllOfUser(String userId) async {
    final plans = await _dataSource.readAllOfUser(userId);
    cache.saveAll({for (final plan in plans) plan.id: plan});
    addAllToMap(plans);
    emit(PlanRepositoryPlanCollectionFetched(plans));
    return plans;
  }
}
