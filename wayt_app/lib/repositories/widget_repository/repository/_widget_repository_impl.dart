part of 'widget_repository.dart';

/// Extension containing private methods for [_WidgetRepositoryImpl].
extension _X on _WidgetRepositoryImpl {
  num _getOrderField(String id) => getOrThrow(id).order;

  /// Gets the widgets of the plan or journal with the given [id] from the
  /// cache.
  // ignore: unused_element
  List<WidgetEntity> _getWidgetsOfPlanOrJournal(PlanOrJournalId id) =>
      _widgetMap[id]?.map(cache.getOrThrow).toList() ?? [];

  /// Updates the orders of widgets of plan/journal with the given [id] using
  /// the to match the provided [updatedOrders] map.
  void _updateWidgetOrders(PlanOrJournalId id, Map<String, int> updatedOrders) {
    for (final entry in updatedOrders.entries) {
      final widget = cache.getOrThrow(entry.key) as WidgetModel;
      if (widget.planOrJournalId != id) {
        throw ArgumentError(
          'Widget ${widget.id} does not belong to plan/journal $id.',
        );
      }
      final updatedWidget = widget.copyWith(order: entry.value);
      cache.save(updatedWidget.id, updatedWidget);
    }
    _widgetMap[id]?.sortBy(_getOrderField);
  }

  /// Inserts or updates a widget in the repository cache and maps.
  ///
  /// The cache is updated with the widget regardless of whether it is already
  /// present.
  ///
  /// As far as the maps are concerned, if the widget is not already present in
  /// it is simply added. Otherwise, the widget is removed from the maps and
  /// re-added to ensure that the order is correct.
  void _upsertInCacheAndMaps(WidgetEntity widget) {
    // Save the widget to the cache.
    cache.save(widget.id, widget);

    // Remove the widget from the map if it is already present.
    _widgetMap[widget.planOrJournalId]?.remove(widget.id);
    // Remove the widget from the folder map if it is already present.
    _folderWidgetMap[widget.folderId]?.remove(widget.id);

    // Add the widget to the map of widgets of the plan or journal.
    _widgetMap
        .putIfAbsent(
          widget.planOrJournalId,
          // Create a new list with sorting based on the widget.order field
          () => ListWithSortedAdd.by(_getOrderField),
        )
        .add(widget.id);

    // Add the widget to the map of folders.
    if (widget.folderId != null) {
      _folderWidgetMap
          .putIfAbsent(
            widget.folderId!,
            // Create a new list with sorting based on the widget.order field
            () => ListWithSortedAdd.by(_getOrderField),
          )
          .add(widget.id);
    }
  }

  /// Adds a collection of widgets to the repository cache and maps.
  ///
  /// It uses [_upsertInCacheAndMaps] to add each widget.
  void _upsertAllInCacheAndMaps(Iterable<WidgetEntity> widgets) {
    for (final widget in widgets) {
      _upsertInCacheAndMaps(widget);
    }
  }

  /// Removes a [widget] from the cache and maps.
  void _removeFromCacheAndMaps(WidgetEntity widget) {
    cache.delete(widget.id);
    _widgetMap.remove(widget.planOrJournalId);
    if (widget.folderId != null) {
      _folderWidgetMap.remove(widget.folderId);
    }
  }
}

class _WidgetRepositoryImpl
    extends Repository<String, WidgetEntity, WidgetRepositoryState>
    implements WidgetRepository {
  final WidgetDataSource _dataSource;

  /// Map of plan/journal ids to the ids of the widgets they contain.
  final Map<PlanOrJournalId, ListWithSortedAdd<String>> _widgetMap = {};

  /// Map of folder ids (of plans/journals) to the ids of the widgets they
  /// contain.
  final Map<String, ListWithSortedAdd<String>> _folderWidgetMap = {};

  /// Summary helper repository.
  final SummaryHelperRepository _summaryHelperRepository;

  /// Private constructor.
  _WidgetRepositoryImpl(this._dataSource, this._summaryHelperRepository);

  @override
  Future<UpsertWidgetOutput> create(WidgetModel widget, int? index) async {
    logger.v('Creating widget with input: $widget');
    final response = await _dataSource.create(widget, index);
    final (widget: created, :updatedOrders) = response;
    logger.v(
      '${created.toShortString()} created and ${updatedOrders.length} other '
      'widget orders updated.',
    );
    _upsertInCacheAndMaps(created);
    _updateWidgetOrders(created.planOrJournalId, updatedOrders);
    emit(
      WidgetRepositoryWidgetOrdersUpdated(
        planOrJournalId: created.planOrJournalId,
        updatedOrders: updatedOrders,
      ),
    );
    emit(WidgetRepositoryWidgetAdded(created));
    logger.i(
      'Widget created, added to cache and maps [$created] and orders updated',
    );
    return response;
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
  void addAll({
    required PlanOrJournalId planOrJournalId,
    required Iterable<WidgetEntity> widgets,
    bool shouldEmit = true,
  }) {
    logger.v(
      'Adding ${widgets.length} widgets to cache and maps for $planOrJournalId',
    );
    _upsertAllInCacheAndMaps(widgets);
    logger.i(
      '${widgets.length} widgets added to cache and maps for $planOrJournalId',
    );
    // When all widgets are added, the plan/journal is fully loaded.
    _summaryHelperRepository.setFullyLoaded(planOrJournalId);
    if (shouldEmit) {
      emit(WidgetRepositoryWidgetCollectionFetched(widgets.toList()));
    }
  }

  @override
  List<WidgetEntity> getAllOfJournal(String journalId) =>
      _widgetMap[PlanOrJournalId.journal(journalId)]
          ?.map(cache.getOrThrow)
          .toList() ??
      [];

  @override
  List<WidgetEntity> getAllOfPlan(String planId) =>
      _widgetMap[PlanOrJournalId.plan(planId)]
          ?.map(cache.getOrThrow)
          .toList() ??
      [];
}
