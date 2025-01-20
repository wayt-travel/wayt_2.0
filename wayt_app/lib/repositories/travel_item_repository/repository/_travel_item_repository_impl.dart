part of 'travel_item_repository.dart';

/// Helper class to hold the info of a widget or a folder in the cache.
@visibleForTesting
class TravelItemRepoHelper extends Equatable {
  /// The id of the widget or folder.
  final String id;

  /// The ids of the widgets in the folder. If this is a widget, this is null.
  final ListWithSortedAdd<String>? widgetIds;

  const TravelItemRepoHelper.widget(this.id) : widgetIds = null;

  const TravelItemRepoHelper.folder(
    this.id,
    ListWithSortedAdd<String> this.widgetIds,
  );

  bool get isFolder => widgetIds != null;
  bool get isWidget => !isFolder;

  @override
  List<Object?> get props => [id, widgetIds];
}

@visibleForTesting
class TravelItemRepositoryImpl
    extends Repository<String, TravelItemEntity, TravelItemRepositoryState>
    implements TravelItemRepository {
  /// The widget folder data source.
  final WidgetFolderDataSource widgetFolderDataSource;

  /// The widget data source.
  final WidgetDataSource widgetDataSource;

  /// Summary helper repository.
  final SummaryHelperRepository summaryHelperRepository;

  /// Map of travel document ids to the items they contain IN THE ROOT.
  ///
  /// By saying "in the root" I mean that this map does not contain the items
  /// that are contained in folders, but only the items that are directly
  /// contained in the root of the travel document.
  ///
  /// The key of this map is the travel document id. Easy.
  ///
  /// The value is a [SplayTreeMap], i.e., a map that maintains its items
  /// sorted. Each entry in this map represent a travel item in the document
  /// with:
  /// - key: the id of the item
  /// - value: a [TravelItemRepoHelper] object that holds the info of the item.
  ///
  /// The sorting is done based on the order field of the items, i.e.,
  /// `item.order`. See [_maybeAddTravelDocumentToMap] to see how the map is
  /// created.
  final Map<TravelDocumentId, SplayTreeMap<String, TravelItemRepoHelper>>
      _travelDocumentToItemsMap = {};

  TravelItemRepositoryImpl({
    required this.summaryHelperRepository,
    required this.widgetDataSource,
    required this.widgetFolderDataSource,
  });

  Map<TravelDocumentId, SplayTreeMap<String, TravelItemRepoHelper>>
      get travelDocumentToItemsMap =>
          Map.unmodifiable(_travelDocumentToItemsMap);

  /// Gets the order field of the item with the given [itemId].
  num _getOrderField(String itemId) => getOrThrow(itemId).order;

  void _maybeAddTravelDocumentToMap(TravelDocumentId id) {
    _travelDocumentToItemsMap.putIfAbsent(
      id,
      () => SplayTreeMap(
        (k1, k2) {
          final o1 = get(k1)?.order ?? double.negativeInfinity;
          final o2 = get(k2)?.order ?? double.negativeInfinity;
          final compareResult = o1.compareTo(o2);
          if (compareResult == 0 && k1 != k2 && o1 != double.negativeInfinity) {
            // If we're comparing two items with different keys but the same
            // order, we throw an error because the SplayTreeMap should not
            // contain two different items with the same order.
            throw StateError(
              'SplayTreeMap should not contain two items with the same '
              'order or it can malfunction',
            );
          }
          return compareResult;
        },
        // (key) => cache.items.containsKey(key),
      ),
    );
  }

  /// Inserts or updates an item in the repository cache and maps.
  ///
  /// The cache is updated with the item regardless of whether it is already
  /// present.
  ///
  /// As far as the maps are concerned, if the item is not already present
  /// it is simply added. Otherwise, the item is removed from the map and
  /// re-added to ensure that the order is preserved.
  @visibleForTesting
  @protected
  void upsertInCacheAndMaps(TravelItemEntity item) {
    // Save the item to the cache.
    cache.save(item.id, item);

    // Add the travel document id to the map if it does not exist.
    _maybeAddTravelDocumentToMap(item.travelDocumentId);

    if (item.isWidget && item.asWidget.folderId != null) {
      // Add the widget inside the folder item.
      final folderId = item.asWidget.folderId!;
      // Find the folder.
      final folder =
          _travelDocumentToItemsMap[item.travelDocumentId]![folderId];
      if (folder == null) {
        throw StateError(
          'Folder $folderId not found! Widget ${item.toShortString()} is '
          'contained in this folder and is being added to the repository '
          'but the repo does not contain its folder. This should not '
          'happen.',
        );
      }
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
      late final TravelItemRepoHelper helper;

      if (item.isFolderWidget) {
        helper = TravelItemRepoHelper.folder(
          item.id,
          ListWithSortedAdd.by(_getOrderField),
        );
      } else {
        helper = TravelItemRepoHelper.widget(item.id);
      }
      // Remove then readd the item.
      _travelDocumentToItemsMap[item.travelDocumentId]!
        // Remove the item
        ..remove(helper.id)
        // Readd the item
        ..putIfAbsent(helper.id, () => helper);
    }
  }

  /// Updates the orders of items of the travel document with the given [id] to
  /// match the provided [updatedOrders] map.
  ///
  /// The [updatedOrders] map has entries whose keys are the ids of the items
  /// whose order has changed and values their new order value.
  @visibleForTesting
  @protected
  void updateItemOrders(
    TravelDocumentId id,
    Map<String, int> updatedOrders,
  ) {
    if (!_travelDocumentToItemsMap.containsKey(id)) {
      throw StateError(
        'Travel document $id not found in the repository. This should not '
        'happen.',
      );
    }

    // First we make sure to remove all items in the root of a travel document.
    // This is needed in order for the SplayTreeMap to function properly without
    // too much complicated logic below.
    for (final itemId in updatedOrders.keys) {
      final item = cache.getOrThrow(itemId) as WidgetModel;
      if (item.isFolderWidget || item.folderId == null) {
        _travelDocumentToItemsMap[id]!.remove(itemId);
      }
    }

    for (final entry in updatedOrders.entries) {
      final itemId = entry.key;
      final newOrder = entry.value;
      final item = cache.getOrThrow(itemId) as WidgetModel;
      if (item.travelDocumentId != id) {
        throw ArgumentError(
          'Item ${item.id} does not belong to travel document $id.',
        );
      }
      // Update the item with the new order.
      final updated = item.copyWith(order: newOrder);
      upsertInCacheAndMaps(updated);
    }
  }

  /// Removes an [item] from the cache and maps.
  @visibleForTesting
  @protected
  void removeFromCacheAndMaps(TravelItemEntity item) {
    final itemsMap = _travelDocumentToItemsMap[item.travelDocumentId];
    if (itemsMap == null) return;

    if (item.isWidget && item.asWidget.folderId != null) {
      // If the item is a widget in a folder, we need to remove it from the
      // folder.
      final folderId = item.asWidget.folderId!;
      final folder = itemsMap[folderId];
      if (folder == null) return;
      folder.widgetIds!.remove(item.id);
    } else {
      // If the item is a widget in the root, we just to remove it from the
      // root.
      itemsMap.remove(item.id);
    }

    // Remove the item from the cache at the end, because before it may be
    // needed from the SplitTreeMap compare function (for internal logic while
    // removing the item from the map).
    cache.delete(item.id);
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
    upsertInCacheAndMaps(created);
    updateItemOrders(created.travelDocumentId, updatedOrders);
    emit(
      TravelItemRepositoryItemOrdersUpdated(
        travelDocumentId: created.travelDocumentId,
        updatedOrders: updatedOrders,
      ),
    );
    emit(TravelItemRepositoryTravelItemAdded(created));
    logger.i(
      'Widget created, added to cache and maps [$created] and orders updated',
    );
    return response;
  }

  @override
  Future<void> deleteFolder({
    required String id,
    required bool deleteContent,
  }) async {
    logger.v('Deleting folder with id: $id');
    final deletedItem = cache.getOrThrow(id);
    await widgetFolderDataSource.delete(id);
    logger.v(
      'Folder ${deletedItem.id} deleted. Removing it from cache and maps.',
    );
    removeFromCacheAndMaps(deletedItem);
    emit(TravelItemRepositoryTravelItemDeleted(deletedItem));
    logger.i('Folder deleted and removed from cache and maps [$deletedItem].');
  }

  @override
  Future<void> deleteWidget(String id) async {
    logger.v('Deleting widget with id: $id');
    final deletedItem = cache.getOrThrow(id);
    await widgetDataSource.delete(id);
    logger.v(
      'Widget ${deletedItem.id} deleted. Removing it from cache and maps.',
    );
    removeFromCacheAndMaps(deletedItem);
    emit(TravelItemRepositoryTravelItemDeleted(deletedItem));
    logger.i('Widget deleted and removed from cache and maps [$deletedItem].');
  }

  /// Wraps a travel item in a [TravelItemEntityWrapper].
  TravelItemEntityWrapper _wrapItem(TravelItemRepoHelper item) => item.isFolder
      ? TravelItemEntityWrapper.folder(
          cache.getOrThrow(item.id),
          item.widgetIds!.map(cache.getOrThrow).toList(),
        )
      : TravelItemEntityWrapper.widget(cache.getOrThrow(item.id));

  /// Gets all items of a journal or plan with the given `String`
  /// [travelDocumentId].
  List<TravelItemEntityWrapper> _getAllOfAny(String travelDocumentId) =>
      (_travelDocumentToItemsMap[TravelDocumentId.journal(travelDocumentId)] ??
              _travelDocumentToItemsMap[
                  TravelDocumentId.plan(travelDocumentId)])
          ?.values
          .map(_wrapItem)
          .toList() ??
      [];

  @override
  List<TravelItemEntityWrapper> getAllOf(TravelDocumentId travelDocumentId) =>
      _travelDocumentToItemsMap[travelDocumentId]
          ?.values
          .map(_wrapItem)
          .toList() ??
      [];

  @override
  List<TravelItemEntityWrapper> getAllOfJournal(String journalId) =>
      _getAllOfAny(journalId);

  @override
  List<TravelItemEntityWrapper> getAllOfPlan(String planId) =>
      _getAllOfAny(planId);

  @override
  void addAll({
    required TravelDocumentId travelDocumentId,
    required Iterable<TravelItemEntity> travelItems,
    bool shouldEmit = true,
  }) {
    logger.v('Adding ${travelItems.length} items to cache and maps');
    for (final item in travelItems) {
      upsertInCacheAndMaps(item);
    }
    logger.i('${travelItems.length} items added to cache and maps');
    if (shouldEmit) {
      emit(
        TravelItemRepositoryTravelItemCollectionFetched(
          travelItems.toList(),
        ),
      );
    }
  }

  @override
  TravelItemEntityWrapper? getWrapped(
    String id, {
    TravelItemEntityWrapper Function()? orElse,
  }) {
    final item = cache.get(id);
    if (item == null) return orElse?.call();
    if (item.isFolderWidget) {
      final itemHelper =
          _travelDocumentToItemsMap[item.travelDocumentId]?[item.id];
      if (itemHelper == null) return orElse?.call();
      return TravelItemEntityWrapper.folder(
        item,
        itemHelper.widgetIds!.map(cache.getOrThrow).toList(),
      );
    }
    return TravelItemEntityWrapper.widget(cache.getOrThrow(item.id));
  }

  @override
  TravelItemEntityWrapper getWrappedOrThrow(String id) => getWrapped(
        id,
        orElse: () => throw ArgumentError.value(
          id,
          'id',
          'Item with id $id not found.',
        ),
      )!;
}
