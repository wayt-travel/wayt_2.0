part of 'travel_item_repository.dart';

/// Helper class to hold the info of a widget or a folder in the cache.
class _TravelItemHelper extends Equatable {
  /// The id of the widget or folder.
  final String id;

  /// The ids of the widgets in the folder. If this is a widget, this is null.
  final ListWithSortedAdd<String>? widgetIds;

  const _TravelItemHelper.widget(this.id) : widgetIds = null;

  const _TravelItemHelper.folder(
    this.id,
    ListWithSortedAdd<String> this.widgetIds,
  );

  bool get isFolder => widgetIds != null;
  bool get isWidget => !isFolder;

  @override
  List<Object?> get props => [id, widgetIds];
}

class _TravelItemRepositoryImpl
    extends Repository<String, TravelItemEntity, TravelItemRepositoryState>
    implements TravelItemRepository {
  /// Subscription to the widget repository.
  StreamSubscription<WidgetRepositoryState>? _widgetRepositorySubscription;

  /// The widget folder repository.
  final WidgetFolderRepository widgetFolderRepository;

  /// The widget folder data source.
  final WidgetFolderDataSource widgetFolderDataSource;

  /// The widget repository.
  final WidgetRepository widgetRepository;

  /// The widget data source.
  final WidgetDataSource widgetDataSource;

  /// Summary helper repository.
  final SummaryHelperRepository summaryHelperRepository;

  /// Map of plan/journal ids to the ids of the widgets or folders they contain
  /// in the root. NB: widgets contained in folders do not appear as
  /// [_TravelItemHelper] in the map values.
  final Map<TravelDocumentId, ListWithSortedAdd<_TravelItemHelper>> _itemsMap =
      {};

  _TravelItemRepositoryImpl({
    required this.summaryHelperRepository,
    required this.widgetRepository,
    required this.widgetDataSource,
    required this.widgetFolderRepository,
    required this.widgetFolderDataSource,
  }) {
    _widgetRepositorySubscription = widgetRepository.listen((repoState) {
      if (isClosed) return;
      if (repoState is WidgetRepositoryWidgetAdded) {
        emit(TravelItemRepositoryTravelItemAdded(repoState.item));
      } else if (repoState is WidgetRepositoryWidgetFetched) {
        emit(TravelItemRepositoryTravelItemFetched(repoState.item));
      } else if (repoState is WidgetRepositoryWidgetUpdated) {
        emit(
          TravelItemRepositoryTravelItemUpdated(
            repoState.previousItem,
            repoState.updatedItem,
          ),
        );
      } else if (repoState is WidgetRepositoryWidgetDeleted) {
        emit(TravelItemRepositoryTravelItemDeleted(repoState.item));
      }
    });
    // TODO: add subscription to widget folder repository
  }

  @override
  Future<void> close() {
    _widgetRepositorySubscription?.cancel().ignore();
    return super.close();
  }

  num _getOrderField(String itemId) => getOrThrow(itemId).order;

  /// Sorting function to sort the items based on their order field.
  num _getOrderFieldOfHelper(_TravelItemHelper helper) =>
      _getOrderField(helper.id);

  /// Inserts or updates an item in the repository cache and maps.
  ///
  /// The cache is updated with the item regardless of whether it is already
  /// present.
  ///
  /// As far as the maps are concerned, if the item is not already present in
  /// it is simply added. Otherwise, the item is removed from the map and
  /// re-added to ensure that the order is correct.
  void _upsertInCacheAndMaps(TravelItemEntity item) {
    // Save the item to the cache.
    cache.save(item.id, item);

    // Add the travel document id to the map if it does not exist.
    _itemsMap.putIfAbsent(
      item.travelDocumentId,
      () => ListWithSortedAdd.by(_getOrderFieldOfHelper),
    );

    if (item.isWidget && item.asWidget.folderId != null) {
      // Add the widget inside the folder item.
      final folderId = item.asWidget.folderId!;
      final folder = _itemsMap[item.travelDocumentId]!.firstWhere(
        (h) => h.id == folderId,
        orElse: () => throw StateError(
          'Folder $folderId not found! Widget ${item.toShortString()} is '
          'contained in this folder and is being added to the repository '
          'but the repo does not contain its folder. This should not happen.',
        ),
      );
      if (!folder.isFolder) {
        throw StateError(
          'Item $folderId is not a folder in travel document '
          '${item.travelDocumentId}',
        );
      }
      // Remove then re-add the item in the folder
      folder.widgetIds!
        ..remove(item.id)
        ..add(item.id);
    } else {
      // Add the item in the root as _TravelItemHelper
      late final _TravelItemHelper helper;

      if (item.isFolderWidget) {
        helper = _TravelItemHelper.folder(
          item.id,
          ListWithSortedAdd.by(_getOrderField),
        );
      } else {
        helper = _TravelItemHelper.widget(item.id);
      }
      // Remove then readd the item.
      _itemsMap[item.travelDocumentId]!
        ..removeWhere((h) => h.id == helper.id)
        ..add(helper);
    }
  }

  /// Updates the orders of items of the travel document with the given [id]
  /// to match the provided [updatedOrders] map.
  void _updateItemOrders(
    TravelDocumentId id,
    Map<String, int> updatedOrders,
  ) {
    for (final entry in updatedOrders.entries) {
      final item = cache.getOrThrow(entry.key) as WidgetModel;
      if (item.travelDocumentId != id) {
        throw ArgumentError(
          'Item ${item.id} does not belong to travel document $id.',
        );
      }
      // Update the item with the new order.
      final updated = item.copyWith(order: entry.value);
      // Save the updated item to the cache.
      cache.save(updated.id, updated);
    }
    if (_itemsMap.containsKey(id)) {
      final helpers = _itemsMap[id]!
        // Sort the items in the map based on the order field.
        ..sortBy(_getOrderFieldOfHelper);

      // If the item is a folder, sort the widgets in the folder based on the
      // order field.
      for (final helper in helpers.where((h) => h.isFolder)) {
        helper.widgetIds!.sortBy(_getOrderField);
      }
    }
  }

  /// Removes an [item] from the cache and maps.
  void _removeFromCacheAndMaps(TravelItemEntity item) {
    cache.delete(item.id);
    final items = _itemsMap[item.travelDocumentId];
    if (items == null) return;

    if (item.isWidget && item.asWidget.folderId != null) {
      final folderId = item.asWidget.folderId!;
      final folder = items.firstWhereOrNull(
        (h) => h.id == folderId && h.isFolder,
      );
      if (folder == null) return;
      folder.widgetIds!.remove(item.id);
    } else {
      items.removeWhere((h) => h.id == item.id);
    }
  }

  @override
  Future<UpsertWidgetFolderOutput> createFolder(CreateWidgetFolderInput input) {
    // TODO: implement createFolder
    throw UnimplementedError();
  }

  @override
  Future<UpsertWidgetOutput> createWidget(
    WidgetModel widget,
    int? index,
  ) async {
    logger.v('Creating widget with input: $widget');
    final response = await widgetDataSource.create(widget, index);
    final (widget: created, :updatedOrders) = response;
    logger.v(
      '${created.toShortString()} created and ${updatedOrders.length} other '
      'item orders updated.',
    );
    _upsertInCacheAndMaps(created);
    _updateItemOrders(created.travelDocumentId, updatedOrders);
    emit(
      WidgetRepositoryWidgetOrdersUpdated(
        travelDocumentId: created.travelDocumentId,
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
  Future<void> deleteFolder({required String id, required bool deleteContent}) {
    // TODO: implement deleteFolder
    throw UnimplementedError();
  }

  @override
  Future<void> deleteWidget(String id) async {
    logger.v('Deleting widget with id: $id');
    final deletedItem = cache.getOrThrow(id);
    await widgetDataSource.delete(id);
    logger.v(
      'Widget ${deletedItem.id} deleted. Removing it from cache and maps.',
    );
    _removeFromCacheAndMaps(deletedItem);
    emit(WidgetRepositoryWidgetDeleted(deletedItem));
    logger.i('Widget deleted and removed from cache and maps [$deletedItem].');
  }

  @override
  List<TravelItemEntity> getAllOfJournal(String journalId) =>
      _itemsMap[TravelDocumentId.journal(journalId)]
          ?.map((h) => cache.getOrThrow(h.id))
          .toList() ??
      [];

  @override
  List<TravelItemEntity> getAllOfPlan(String planId) {
    // TODO: implement getAllOfPlan
    throw UnimplementedError();
  }

  @override
  void addAll({
    required TravelDocumentId travelDocumentId,
    required Iterable<TravelItemEntity> travelItems,
    bool shouldEmit = true,
  }) {
    // TODO: implement addAll
  }
}
