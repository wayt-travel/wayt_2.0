part of 'plan_repository.dart';

class _PlanRepositoryImpl
    extends Repository<String, IPlanEntity, PlanRepositoryState>
    implements PlanRepository {
  final PlanDataSource dataSource;

  _PlanRepositoryImpl(this.dataSource);

  @override
  Future<void> create(PlanInput input) async {
    final item = await dataSource.create(input);
    cache.save(item.uuid, item);

    emit(PlanRepositoryPlanAdded(item));
  }

  @override
  Future<void> delete(String id) async {
    final item = cache.getOrThrow(id);
    await dataSource.delete(id);

    cache.delete(id);
    emit(PlanRepositoryPlanDeleted(item));
  }

  @override
  Future<Plans> read() async {
    final items = await dataSource.read();
    cache.saveAll({for (final i in items) i.uuid: i});

    emit(PlanRepositoryPlanCollectionFetched(items));

    return items;
  }

  @override
  Future<PlanEntity> readBy(String id) async {
    final item = await dataSource.readById(id);
    cache.save(item.uuid, item);

    return item;
  }
}
