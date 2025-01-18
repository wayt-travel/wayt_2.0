part of 'widget_repository.dart';

/// Extension containing private methods for [_WidgetRepositoryImpl].
extension _X on _WidgetRepositoryImpl {
  num _getOrderField(String id) => getOrThrow(id).order;

  /// Gets the widgets of the plan or journal with the given [id] from the
  /// cache.
  // ignore: unused_element
  List<WidgetEntity> _getWidgetsOfTravelDocument(TravelDocumentId id) =>
      _widgetMap[id]?.map(cache.getOrThrow).toList() ?? [];

  /// Updates the orders of widgets of plan/journal with the given [id] using
  /// the to match the provided [updatedOrders] map.
  void _updateWidgetOrders(
    TravelDocumentId id,
    Map<String, int> updatedOrders,
  ) {
    for (final entry in updatedOrders.entries) {
      final widget = cache.getOrThrow(entry.key) as WidgetModel;
      if (widget.travelDocumentId != id) {
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
    _widgetMap[widget.travelDocumentId]?.remove(widget.id);
    // Remove the widget from the folder map if it is already present.
    _folderWidgetMap[widget.folderId]?.remove(widget.id);

    // Add the widget to the map of widgets of the plan or journal.
    _widgetMap
        .putIfAbsent(
          widget.travelDocumentId,
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


}

class _WidgetRepositoryImpl
    extends Repository<String, WidgetEntity, WidgetRepositoryState>
    implements WidgetRepository {
  final WidgetDataSource _dataSource;

  /// Map of plan/journal ids to the ids of the widgets they contain.
  final Map<TravelDocumentId, ListWithSortedAdd<String>> _widgetMap = {};

  /// Map of folder ids (of plans/journals) to the ids of the widgets they
  /// contain.
  final Map<String, ListWithSortedAdd<String>> _folderWidgetMap = {};

  /// Summary helper repository.
  final SummaryHelperRepository _summaryHelperRepository;

  /// Private constructor.
  _WidgetRepositoryImpl(this._dataSource, this._summaryHelperRepository);

  @override
  Future<UpsertWidgetOutput> create(WidgetModel widget, int? index) async {
    
  }

  @override
  Future<void> delete(String id) async {

  }

  @override
  void addAll({
    required TravelDocumentId travelDocumentId,
    required Iterable<WidgetEntity> widgets,
    bool shouldEmit = true,
  }) {
    logger.v(
      'Adding ${widgets.length} widgets to cache and maps for $travelDocumentId',
    );
    _upsertAllInCacheAndMaps(widgets);
    logger.i(
      '${widgets.length} widgets added to cache and maps for $travelDocumentId',
    );
    // When all widgets are added, the plan/journal is fully loaded.
    _summaryHelperRepository.setFullyLoaded(travelDocumentId);
    if (shouldEmit) {
      emit(WidgetRepositoryWidgetCollectionFetched(widgets.toList()));
    }
  }

  @override
  List<WidgetEntity> getAllOfJournal(String journalId) =>
      _widgetMap[TravelDocumentId.journal(journalId)]
          ?.map(cache.getOrThrow)
          .toList() ??
      [];

  @override
  List<WidgetEntity> getAllOfPlan(String planId) =>
      _widgetMap[TravelDocumentId.plan(planId)]
          ?.map(cache.getOrThrow)
          .toList() ??
      [];
}
