part of 'travel_item_repository.dart';

/// Helper class to hold the info of a widget or a folder in the cache.
@visibleForTesting
class TravelItemRepoHelper extends Equatable {
  /// The id of the widget or folder.
  final String id;

  /// The ids of the widgets in the folder. If this is a widget, this is null.
  final ListWithSortedAdd<String>? widgetIds;

  /// Create a new instance of [TravelItemRepoHelper] for a widget.
  const TravelItemRepoHelper.widget(this.id) : widgetIds = null;

  /// Create a new instance of [TravelItemRepoHelper] for a folder.
  const TravelItemRepoHelper.folder(
    this.id,
    ListWithSortedAdd<String> this.widgetIds,
  );

  /// Whether the helper represents a folder.
  bool get isFolder => widgetIds != null;

  /// Whether the helper represents a widget.
  bool get isWidget => !isFolder;

  @override
  List<Object?> get props => [id, widgetIds];
}

/// Implementation of [TravelItemRepository].
///
/// Visible for testing.
@visibleForTesting
class TravelItemRepositoryImpl extends RepositoryV2<
    String,
    TravelItemEntity,
    TravelItemRepositoryEvent,
    TravelItemRepositoryState,
    WError> implements TravelItemRepository {
  /// The travel item data source.
  final TravelItemDataSource travelItemDataSource;

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

  /// Creates a new instance of [TravelItemRepositoryImpl].
  TravelItemRepositoryImpl({
    required this.travelItemDataSource,
    required this.summaryHelperRepository,
    required this.widgetDataSource,
    required this.widgetFolderDataSource,
  }) : super(errorTransformer: (e) => e.errorOrGeneric) {
    on<TravelItemRepoWidgetCreatedEvent, UpsertWidgetOutput>(_createWidget);
    on<TravelItemRepoFolderCreatedEvent, UpsertWidgetFolderOutput>(
      _createFolder,
    );
    on<TravelItemRepoItemDeletedEvent, void>(_deleteItem);
    on<TravelItemRepoItemsReorderedEvent, Map<String, int>>(_reorderItems);
    on<TravelItemRepoItemsAddedEvent, void>(_addAll);
    on<TravelItemRepoFolderUpdatedEvent, UpsertWidgetFolderOutput>(
      _updateFolder,
    );
  }

  /// Gets the map of travel document ids to the items they contain IN THE ROOT.
  @visibleForTesting
  Map<TravelDocumentId, SplayTreeMap<String, TravelItemRepoHelper>>
      get travelDocumentToItemsMap =>
          Map.unmodifiable(_travelDocumentToItemsMap);

  /// Checks if the repository contains the travel document with the given [id].
  ///
  /// Throws an [ArgumentError] if the travel document is not found.
  void _checkThrowContainsTravelDocument(TravelDocumentId id) {
    if (!_travelDocumentToItemsMap.containsKey(id)) {
      throw ArgumentError(
        'Travel document $id not found in the repository.',
      );
    }
  }

  /// Checks if the repository contains the item with the given [itemId] in
  /// the root of the travel document with the given [travelDocumentId].
  ///
  /// Throws an [ArgumentError] otherwise.
  void _checkThrowContainsRootItem({
    required TravelDocumentId travelDocumentId,
    required String itemId,
  }) {
    _checkThrowContainsTravelDocument(travelDocumentId);
    if (cache[itemId] == null) {
      throw ArgumentError(
        'Root item $itemId not found in the repository cache.',
      );
    }
    if (!_travelDocumentToItemsMap[travelDocumentId]!.containsKey(itemId)) {
      throw ArgumentError(
        'Root item $itemId not found in the repository map.',
      );
    }
  }

  /// Checks if the repository contains the folder with the given [folderId] in
  /// the root of the travel document with the given [travelDocumentId].
  ///
  /// Throws an [ArgumentError] otherwise.
  void _checkThrowContainsFolder({
    required TravelDocumentId travelDocumentId,
    required String folderId,
  }) =>
      _checkThrowContainsRootItem(
        travelDocumentId: travelDocumentId,
        itemId: folderId,
      );

  /// Checks if the repository contains the widget with the given [itemId] in
  /// the folder with the given [folderId] in the travel document with the given
  /// [travelDocumentId].
  ///
  /// Throws an [ArgumentError] otherwise.
  void _checkThrowFolderContainsWidget({
    required TravelDocumentId travelDocumentId,
    required String folderId,
    required String itemId,
  }) {
    _checkThrowContainsFolder(
      travelDocumentId: travelDocumentId,
      folderId: folderId,
    );
    final item = cache[itemId];
    if (item == null) {
      throw ArgumentError(
        'Widget $itemId not found in the repository cache.',
      );
    }
    if (folderId != item.asWidget.folderId) {
      throw ArgumentError(
        'Widget $itemId is not contained in folder $folderId.',
      );
    }
    final folder = _travelDocumentToItemsMap[travelDocumentId]![folderId]!;
    if (!folder.widgetIds!.contains(itemId)) {
      throw ArgumentError(
        'Widget $itemId not found in folder $folderId.',
      );
    }
  }

  /// Checks if the repository contains the item with the given [itemId] in the
  /// travel document with the given [travelDocumentId].
  ///
  /// If the [folderId] is `null`, it checks if the item is in the root of the
  /// travel document. Otherwise, it checks if the item is in the folder with
  /// the given [folderId].
  ///
  /// Throws an [ArgumentError] otherwise.
  // ignore: unused_element
  void _checkThrowContainsItem({
    required TravelDocumentId travelDocumentId,
    required String? folderId,
    required String itemId,
  }) {
    if (folderId == null) {
      _checkThrowContainsRootItem(
        travelDocumentId: travelDocumentId,
        itemId: itemId,
      );
      return;
    }
    _checkThrowFolderContainsWidget(
      travelDocumentId: travelDocumentId,
      folderId: folderId,
      itemId: itemId,
    );
  }

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
          if (compareResult == 0 && k1 != k2) {
            // If we're comparing two items with different keys but the same
            // order, we cannot return 0 because the SplayTreeMap will think
            // that the items are the same and will not insert the second item.
            // Sp we return a comparison based on the keys.
            return k1.compareTo(k2);
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
    cache[item.id] = item;

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
      // Remove then re-add the item.
      _travelDocumentToItemsMap[item.travelDocumentId]!
        // Remove the item
        ..remove(helper.id)
        // Add the item
        ..putIfAbsent(helper.id, () => helper);
    }
  }

  /// Updates the orders of items of the travel document with the given [id] to
  /// match the provided [updatedOrders] map.
  ///
  /// It supports updating the order of items in the root of the travel document
  /// as well as the order of items in folders.
  ///
  /// The [updatedOrders] map has entries where:
  /// - the key is the id of a travel item
  /// - the value is the new order of the item
  ///
  /// If the item is not present in the [updatedOrders] map, it is assumed that
  /// the item order has not changed.
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
    // NB: the items are not removed from the cache, only from the map!
    final removedFolders = <String, TravelItemRepoHelper>{};
    for (final itemId in updatedOrders.keys) {
      final item = cache.getOrThrow(itemId);
      if (item.isFolderWidget || item.asWidget.folderId == null) {
        final removed = _travelDocumentToItemsMap[id]!.remove(itemId);
        if (removed != null && removed.isFolder) {
          // If the item is a folder, we need to store it in order to readd its
          // children later.
          removedFolders[removed.id] = removed;
        }
      }
    }

    for (final entry in updatedOrders.entries) {
      final itemId = entry.key;
      final newOrder = entry.value;
      final item = cache.getOrThrow(itemId);
      if (item.travelDocumentId != id) {
        throw ArgumentError(
          'Item ${item.id} does not belong to travel document $id.',
        );
      }
      // Update the item with the new order.
      final updated = item.copyWith(order: newOrder);
      // Writes the item into the cache (override) and adds the item back to the
      // map (since before it has been removed)
      upsertInCacheAndMaps(updated);
      if (updated.isFolderWidget && removedFolders.containsKey(updated.id)) {
        // If the item is a folder, we need to readd its children.
        _travelDocumentToItemsMap[id]![updated.id]
            ?.widgetIds
            ?.addAll(removedFolders[updated.id]!.widgetIds!);
      }
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
    cache.remove(item.id);
  }

  Future<UpsertWidgetFolderOutput> _createFolder(
    TravelItemRepoFolderCreatedEvent event,
    Emitter<TravelItemRepositoryState<TravelItemEntity>?> emit,
  ) async {
    final input = event.input;
    logger.v('Creating folder with input: $input');
    final response = await widgetFolderDataSource.create(input);
    final (widgetFolder: created, :updatedOrders) = response;
    logger.v(
      '${created.toShortString()} created and ${updatedOrders.length} other '
      'item orders updated.',
    );
    updateItemOrders(created.travelDocumentId, updatedOrders);
    upsertInCacheAndMaps(created);
    emit(
      TravelItemRepoItemOrdersUpdateSuccess(
        travelDocumentId: created.travelDocumentId,
        updatedOrders: updatedOrders,
      ),
    );
    emit(
      TravelItemRepoItemCreateSuccess(
        TravelItemEntityWrapper.folder(created, []),
      ),
    );
    logger.i(
      'Folder created, added to cache and maps [$created] and orders updated',
    );
    return response;
  }

  Future<UpsertWidgetOutput> _createWidget(
    TravelItemRepoWidgetCreatedEvent event,
    Emitter<TravelItemRepositoryState<TravelItemEntity>?> emit,
  ) async {
    final widget = event.widget;
    final index = event.index;
    logger.v('Creating widget with input: ${widget.toStringVerbose()}');
    final response = await widgetDataSource.create(widget, index: index);
    final (widget: created, :updatedOrders) = response;
    logger.v(
      '${created.toShortString()} created and ${updatedOrders.length} other '
      'item orders updated.',
    );
    updateItemOrders(created.travelDocumentId, updatedOrders);
    upsertInCacheAndMaps(created);
    emit(
      TravelItemRepoItemsReorderSuccess(
        travelDocumentId: created.travelDocumentId,
        updatedItemsOrder: updatedOrders,
      ),
    );
    emit(
      TravelItemRepoItemCreateSuccess(
        TravelItemEntityWrapper.widget(created),
      ),
    );
    logger.i(
      'Widget created, added to cache and maps [$created] and orders updated',
    );
    return response;
  }

  Future<void> _deleteItem(
    TravelItemRepoItemDeletedEvent event,
    Emitter<TravelItemRepositoryState<TravelItemEntity>?> emit,
  ) async {
    final id = event.id;
    logger.v('Deleting travel item with id: $id');
    final deletedItemWrapper = getWrappedOrThrow(id);
    final deletedItem = deletedItemWrapper.value;
    if (deletedItem.isFolderWidget) {
      await widgetFolderDataSource.delete(id);
    } else {
      await widgetDataSource.delete(id);
    }
    logger.v(
      'Item ${deletedItem.id} deleted. Removing it from cache and maps.',
    );
    removeFromCacheAndMaps(deletedItem);
    emit(TravelItemRepoItemDeleteSuccess(deletedItemWrapper));
    logger.i('Item deleted and removed from cache and maps [$deletedItem].');
  }

  Future<Map<String, int>> _reorderItems(
    TravelItemRepoItemsReorderedEvent event,
    Emitter<TravelItemRepositoryState<TravelItemEntity>?> emit,
  ) async {
    final travelDocumentId = event.input.travelDocumentId;
    final reorderedItemIds = event.input.reorderedItemIds;
    final folderId = event.input.folderId;
    logger.v(
      'Reordering ${reorderedItemIds.length} items in travel document '
      '$travelDocumentId (folderId=$folderId)',
    );

    if (folderId != null) {
      _checkThrowContainsFolder(
        travelDocumentId: travelDocumentId,
        folderId: folderId,
      );
    } else {
      _checkThrowContainsTravelDocument(travelDocumentId);
    }

    final items = _travelDocumentToItemsMap[travelDocumentId];
    late final Set<String>? itemsInTd;
    if (folderId != null) {
      itemsInTd = items?[folderId]?.widgetIds?.toSet();
    } else {
      itemsInTd = items?.keys.toSet();
    }
    if (!const SetEquality<String>()
        .equals(reorderedItemIds.toSet(), itemsInTd)) {
      throw ArgumentError.value(
        reorderedItemIds,
        'reorderedItemIds',
        'The provided reorderedItemIds do not match the items currently in the '
            'repo for travel document $travelDocumentId.',
      );
    }

    final updatedOrders = await travelItemDataSource.reorderItems(
      travelDocumentId: travelDocumentId,
      reorderedItemIds: reorderedItemIds,
      folderId: folderId,
    );

    if (updatedOrders.isEmpty) {
      logger.i('No items were reordered.');
      return updatedOrders;
    }

    logger.v('Items reordered. Updating the cache and maps.');

    updateItemOrders(travelDocumentId, updatedOrders);
    emit(
      TravelItemRepoItemOrdersUpdateSuccess(
        travelDocumentId: travelDocumentId,
        updatedOrders: updatedOrders,
      ),
    );

    logger.i(
      'Items of $travelDocumentId and folderId=$folderId reordered '
      'successfully.',
    );
    return updatedOrders;
  }

  /// Wraps a travel item in a [TravelItemEntityWrapper].
  TravelItemEntityWrapper _wrapItem(TravelItemRepoHelper item) => item.isFolder
      ? TravelItemEntityWrapper.folder(
          cache.getOrThrow(item.id).asFolderWidget,
          item.widgetIds!.map(cache.getOrThrow).cast<WidgetEntity>().toList(),
        )
      : TravelItemEntityWrapper.widget(
          cache.getOrThrow(item.id).asWidget,
        );

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

  void _addAll(
    TravelItemRepoItemsAddedEvent event,
    Emitter<TravelItemRepositoryState<TravelItemEntity>?> emit,
  ) {
    final travelItems = event.travelItems;
    final shouldEmit = event.shouldEmit;
    logger.v('Adding ${travelItems.length} items to cache and maps');
    // We need to insert folders before widgets because when inserting a widget
    // that is contained in a folder it is required that the folder is already
    // in the cache and maps.
    final travelItemsWithFoldersBefore = travelItems
        .flatMap(
          (item) => <TravelItemEntity>[
            item.value,
            if (item.isFolderWidget) ...item.asFolderWidgetWrapper.children,
          ],
        )
        .sorted(
          (i1, i2) => i1.isFolderWidget
              ? -1
              : i2.isFolderWidget
                  ? 1
                  : 0,
        );
    for (final item in travelItemsWithFoldersBefore) {
      upsertInCacheAndMaps(item);
    }
    logger.i('${travelItems.length} items added to cache and maps');
    if (shouldEmit) {
      emit(TravelItemRepoItemCollectionFetchSuccess(travelItems.toList()));
    }
  }

  @override
  TravelItemEntityWrapper? getWrapped(
    String id, {
    TravelItemEntityWrapper Function()? orElse,
  }) {
    final item = cache[id];
    if (item == null) return orElse?.call();
    if (item.isFolderWidget) {
      final itemHelper =
          _travelDocumentToItemsMap[item.travelDocumentId]?[item.id];
      if (itemHelper == null) return orElse?.call();
      return TravelItemEntityWrapper.folder(
        item.asFolderWidget,
        itemHelper.widgetIds!
            .map(cache.getOrThrow)
            .cast<WidgetEntity>()
            .toList(),
      );
    }
    return TravelItemEntityWrapper.widget(
      cache.getOrThrow(item.id).asWidget,
    );
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

  Future<UpsertWidgetFolderOutput> _updateFolder(
    TravelItemRepoFolderUpdatedEvent event,
    Emitter<TravelItemRepositoryState<TravelItemEntity>?> emit,
  ) async {
    final id = event.id;
    final input = event.input;
    final travelDocumentId = event.travelDocumentId;
    logger.v('Updating folder with input: $input');
    final previousItemWrapper = getWrappedOrThrow(id).asFolderWidgetWrapper;
    final response = await widgetFolderDataSource.update(
      id,
      travelDocumentId: travelDocumentId,
      input: input,
    );
    final (widgetFolder: updated, updatedOrders: _) = response;
    logger.v('${updated.toShortString()} updated');
    upsertInCacheAndMaps(updated);
    emit(
      TravelItemRepoItemUpdateSuccess(
        previousItemWrapper,
        TravelItemEntityWrapper.folder(updated, previousItemWrapper.children),
      ),
    );
    logger.i(
      'Folder updated, added to cache and maps [$updated]',
    );
    return response;
  }

  @override
  WTaskEither<void> addAll({
    required Iterable<TravelItemEntityWrapper> travelItems,
    bool shouldEmit = true,
  }) =>
      TaskEither(
        () => addSequentialAndWait(
          TravelItemRepoItemsAddedEvent(
            travelItems: travelItems,
            shouldEmit: shouldEmit,
          ),
        ),
      );

  @override
  WTaskEither<UpsertWidgetFolderOutput> createFolder(
    CreateWidgetFolderInput input,
  ) =>
      TaskEither(
        () => addSequentialAndWait(TravelItemRepoFolderCreatedEvent(input)),
      );

  @override
  WTaskEither<UpsertWidgetOutput> createWidget(
    WidgetModel widget,
    int? index,
  ) =>
      TaskEither(
        () => addSequentialAndWait(
          TravelItemRepoWidgetCreatedEvent(
            widget: widget,
            index: index,
          ),
        ),
      );

  @override
  WTaskEither<void> deleteItem(String id) => TaskEither(
        () => addSequentialAndWait(TravelItemRepoItemDeletedEvent(id)),
      );

  @override
  WTaskEither<Map<String, int>> reorderItems({
    required TravelDocumentId travelDocumentId,
    required List<String> reorderedItemIds,
    String? folderId,
  }) =>
      TaskEither(
        () => addSequentialAndWait(
          TravelItemRepoItemsReorderedEvent(
            TravelItemReorderedInput(
              travelDocumentId: travelDocumentId,
              reorderedItemIds: reorderedItemIds,
              folderId: folderId,
            ),
          ),
        ),
      );

  @override
  WTaskEither<UpsertWidgetFolderOutput> updateFolder(
    String id, {
    required TravelDocumentId travelDocumentId,
    required UpdateWidgetFolderInput input,
  }) =>
      TaskEither(
        () => addSequentialAndWait(
          TravelItemRepoFolderUpdatedEvent(
            id: id,
            travelDocumentId: travelDocumentId,
            input: input,
          ),
        ),
      );
}
