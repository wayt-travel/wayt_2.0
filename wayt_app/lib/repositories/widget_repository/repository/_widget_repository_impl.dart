part of 'widget_repository.dart';

class _WidgetRepositoryImpl
    extends Repository<String, WidgetEntity, WidgetRepositoryState>
    implements WidgetRepository {
  final WidgetDataSource _dataSource;

  /// Map of plan ids to the ids of the widgets they contain.
  final Map<String, List<String>> _planWidgetMap = {};

  /// Map of journal ids to the ids of the widgets they contain.
  final Map<String, List<String>> _journalWidgetMap = {};

  /// Map of folder ids (of plans) to the ids of the widgets they contain.
  final Map<String, List<String>> _planFolderWidgetMap = {};

  /// Map of folder ids (of journals) to the ids of the widgets they contain.
  final Map<String, List<String>> _journalFolderWidgetMap = {};

  /// Private constructor.
  _WidgetRepositoryImpl(this._dataSource);

  /// Adds a widget to the repository cache and maps.
  void _addToCacheAndMaps(WidgetEntity widget) {
    cache.save(widget.id, widget);
    if (widget.journalId != null) {
      _journalWidgetMap.putIfAbsent(widget.journalId!, () => []).add(widget.id);
      if (widget.folderId != null) {
        _journalFolderWidgetMap
            .putIfAbsent(widget.folderId!, () => [])
            .add(widget.id);
      }
    } else {
      _planWidgetMap.putIfAbsent(widget.planId!, () => []).add(widget.id);
      if (widget.folderId != null) {
        _planFolderWidgetMap
            .putIfAbsent(widget.folderId!, () => [])
            .add(widget.id);
      }
    }
  }

  /// Adds a collection of widgets to the repository cache and maps.
  ///
  /// It uses [_addToCacheAndMaps] to add each widget.
  void _addAllToCacheAndMaps(Iterable<WidgetEntity> widgets) {
    for (final widget in widgets) {
      _addToCacheAndMaps(widget);
    }
  }

  /// Removes a [widget] from the cache and maps.
  void _removeFromCacheAndMaps(WidgetEntity widget) {
    cache.delete(widget.id);
    if (widget.journalId != null) {
      _journalWidgetMap.remove(widget.journalId);
      if (widget.folderId != null) {
        _journalFolderWidgetMap.remove(widget.folderId);
      }
    } else {
      _planWidgetMap.remove(widget.planId);
      if (widget.folderId != null) {
        _planFolderWidgetMap.remove(widget.folderId);
      }
    }
  }

  @override
  Future<WidgetEntity> create(CreateWidgetInput input) async {
    logger.v('Creating widget with input: $input');
    final created = await _dataSource.create(input);
    logger.v(
      '${created.toShortString()} created. Adding it to cache and maps.',
    );
    _addToCacheAndMaps(created);
    emit(WidgetRepositoryWidgetAdded(created));
    logger.i('Widget created and added to cache and maps [$created].');
    return created;
  }

  @override
  Future<List<WidgetEntity>> fetchMany() {
    throw UnimplementedError();
  }

  @override
  Future<WidgetEntity> fetchOne(String id) async {
    logger.v('Fetching widget with id: $id');
    final item = await _dataSource.read(id);
    logger.v('${item.toShortString()} fetched. Adding it to cache and maps.');
    _addToCacheAndMaps(item);
    emit(WidgetRepositoryWidgetFetched(item));
    logger.i('Widget fetched and added to cache and maps [$item].');
    return item;
  }

  @override
  Future<void> delete(String id) async {
    logger.v('Deleting widget with id: $id');
    final deletedItem = cache.getOrThrow(id);
    await _dataSource.delete(id);
    logger.v(
      'Widget ${deletedItem.id} deleted. Removing it from cache and maps.',
    );
    _removeFromCacheAndMaps(deletedItem);
    emit(WidgetRepositoryWidgetDeleted(deletedItem));
    logger.i('Widget deleted and removed from cache and maps [$deletedItem].');
  }

  @override
  void add(WidgetEntity widget, {bool shouldEmit = true}) {
    logger.v('Adding ${widget.toShortString()} to cache and maps');
    _addToCacheAndMaps(widget);
    logger.i('${widget.toShortString()} added to cache and maps');
    if (shouldEmit) {
      emit(WidgetRepositoryWidgetFetched(widget));
    }
  }

  @override
  void addAll(Iterable<WidgetEntity> widgets, {bool shouldEmit = true}) {
    logger.v('Adding ${widgets.length} widgets to cache and maps');
    _addAllToCacheAndMaps(widgets);
    logger.i('${widgets.length} widgets added to cache and maps');
    if (shouldEmit) {
      emit(WidgetRepositoryWidgetCollectionFetched(widgets.toList()));
    }
  }

  @override
  List<WidgetEntity> getAllOfJournal(String journalId) =>
      _journalWidgetMap[journalId]?.map(cache.getOrThrow).toList() ?? [];

  @override
  List<WidgetEntity> getAllOfPlan(String planId) =>
      _planWidgetMap[planId]?.map(cache.getOrThrow).toList() ?? [];
}
