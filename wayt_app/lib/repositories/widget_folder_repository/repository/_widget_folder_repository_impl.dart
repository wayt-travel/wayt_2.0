part of 'widget_folder_repository.dart';

class _WidgetFolderRepositoryImpl
    extends Repository<String, WidgetFolderEntity, WidgetFolderRepositoryState>
    implements WidgetFolderRepository {
  final WidgetFolderDataSource _dataSource;

  _WidgetFolderRepositoryImpl(this._dataSource);

  @override
  Future<UpsertWidgetFolderOutput> create(CreateWidgetFolderInput input) async {
    logger.v('Creating widget folder with input: $input');
    final response = await _dataSource.create(input);
    final (widgetFolder: created, :updatedOrders) = response;
    logger.v(
      '${created.toShortString()} created and ${updatedOrders.length} other '
      'widget folder orders updated.',
    );
    cache.save(created.id, created);
    emit(WidgetFolderRepositoryWidgetFolderAdded(created));
    return response;
  }

  @override
  Future<List<WidgetFolderEntity>> fetchMany() {
    throw UnimplementedError();
  }

  @override
  Future<WidgetFolderEntity> fetchOne(String id) async {
    final item = await _dataSource.read(id);
    cache.save(item.id, item);
    emit(WidgetFolderRepositoryWidgetFolderFetched(item));
    return item;
  }

  @override
  Future<void> delete(String id) async {
    await _dataSource.delete(id);
    final deletedItem = cache.getOrThrow(id);
    cache.delete(id);
    emit(WidgetFolderRepositoryWidgetFolderDeleted(deletedItem));
  }
}
