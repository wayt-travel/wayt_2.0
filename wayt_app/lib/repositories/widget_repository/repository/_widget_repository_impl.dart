part of 'widget_repository.dart';

class _WidgetRepositoryImpl
    extends Repository<String, WidgetEntity, WidgetRepositoryState>
    implements WidgetRepository {
  final WidgetDataSource _dataSource;

  _WidgetRepositoryImpl(this._dataSource);

  @override
  Future<WidgetEntity> create(CreateWidgetInput input) async {
    final created = await _dataSource.create(input);
    cache.save(created.id, created);
    emit(WidgetRepositoryWidgetAdded(created));
    return created;
  }

  @override
  Future<List<WidgetEntity>> fetchMany() {
    throw UnimplementedError();
  }

  @override
  Future<WidgetEntity> fetchOne(String id) async {
    final item = await _dataSource.read(id);
    cache.save(item.id, item);
    emit(WidgetRepositoryWidgetFetched(item));
    return item;
  }

  @override
  Future<void> delete(String id) async {
    await _dataSource.delete(id);
    final deletedItem = cache.getOrThrow(id);
    cache.delete(id);
    emit(WidgetRepositoryWidgetDeleted(deletedItem));
  }
}
