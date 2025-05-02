import 'package:flext/flext.dart';
import 'package:fpdart/fpdart.dart';

import '../../../init/in_memory_data.dart';
import '../../repositories.dart';

/// In-memory implementation of the Widget data source.
final class InMemoryWidgetDataSource implements WidgetDataSource {
  final InMemoryDataHelper _dataHelper;

  /// Create a new instance of [InMemoryWidgetDataSource]
  InMemoryWidgetDataSource(this._dataHelper);

  @override
  Future<UpsertWidgetOutput> create(WidgetModel widget, {int? index}) {
    if (!_dataHelper.containsTravelDocument(widget.travelDocumentId)) {
      throw ArgumentError.value(
        widget.travelDocumentId,
        'widget.travelDocumentId',
        'The travel document does not exist.',
      );
    }
    late List<TravelItemEntity> travelItems;
    if (widget.folderId != null) {
      // The widget must be inserted in a folder.
      final folderWrapper =
          _dataHelper.getWidgetFolderWrapper(widget.folderId!);
      // The travel items are the children of the folder.
      travelItems = folderWrapper.children;
    } else {
      // Get the travel items in the root of the travel document.
      travelItems = _dataHelper
          .getTravelDocumentWrapper(widget.travelDocumentId)
          .rootTravelItems
          .toList();
    }

    if (index == null) {
      travelItems.add(widget);
    } else if (index.isBetween(0, travelItems.length)) {
      travelItems.insert(index, widget);
    } else {
      throw ArgumentError.value(
        index,
        'index',
        'The index is out of bounds.',
      );
    }

    // Recompute the order of the travel items after the insertion.
    travelItems = travelItems
        .mapIndexed(
          (i, w) =>
              w.order != i ? (w as TravelItemModel).copyWith(order: i) : w,
        )
        .toList();

    // Save the updated widgets.
    _dataHelper.saveTravelItems(travelItems);

    // Get the list of widgets whose order was updated.
    final updatedTravelItems = index != null && travelItems.length > index
        ? travelItems.sublist(index + 1)
        : <TravelItemModel>[];

    // Build the output.
    return Future.value(
      (
        widget: _dataHelper.getWidget(widget.id),
        updatedOrders: {
          for (final items in updatedTravelItems) items.id: items.order,
        },
      ),
    );
  }

  @override
  Future<UpsertWidgetOutput> update(WidgetModel widget) {
    if (!_dataHelper.containsTravelDocument(widget.travelDocumentId)) {
      throw ArgumentError.value(
        widget.travelDocumentId,
        'widget.travelDocumentId',
        'The travel document does not exist.',
      );
    }

    // Save the updated widget.
    _dataHelper.saveTravelItem(widget);

    // Build the output.
    return Future.value(
      (
        widget: _dataHelper.getWidget(widget.id),
        updatedOrders: <String, int>{},
      ),
    );
  }

  @override
  Future<WidgetModel> read(String id) async => _dataHelper.getWidget(id);

  @override
  Future<void> delete(String id) async {
    await waitFakeTime();
    _dataHelper.deleteItem(id);
  }

  @override
  Future<List<WidgetEntity>> moveToFolder({
    required TravelDocumentId travelDocumentId,
    required List<WidgetEntity> widgetsToMove,
    required String? destinationFolderId,
  }) {
    if (!_dataHelper.containsTravelDocument(travelDocumentId)) {
      throw ArgumentError.value(
        travelDocumentId,
        'widget.travelDocumentId',
        'The travel document does not exist.',
      );
    }
    // Check if all widgets belong to the same travel document.
    final allWidgetsBelongsToTravelDocument = widgetsToMove.fold(
      true,
      (acc, item) => acc && item.travelDocumentId == travelDocumentId,
    );
    if (!allWidgetsBelongsToTravelDocument) {
      throw ArgumentError.value(
        widgetsToMove,
        'widgetsToMove',
        'All widgets must belong to the same travel document '
            '$travelDocumentId.',
      );
    }
    // If the destinationFolderId does not exist in the travel document,
    // an error will be thrown by the data helper.
    final dstFolder = destinationFolderId != null
        ? _dataHelper.getWidgetFolder(destinationFolderId)
        : null;

    var startingOrder = -1;
    if (dstFolder != null) {
      // Get the last order of the destination folder.
      startingOrder = _dataHelper
              .getWidgetFolderWrapper(dstFolder.id)
              .children
              .map((w) => w.order)
              .maxOrNull ??
          -1;
    } else {
      // Get the last order of the root travel items.
      startingOrder = _dataHelper
              .getTravelDocumentWrapper(travelDocumentId)
              .rootTravelItems
              .map((w) => w.order)
              .maxOrNull ??
          -1;
    }
    startingOrder += 1;

    final updatedWidgets = widgetsToMove
        .map(
          (w) => w.copyWith(
            order: startingOrder++,
            folderId: Option.of(dstFolder?.id),
          ),
        )
        .cast<WidgetEntity>()
        .toList();

    _dataHelper.saveTravelItems(updatedWidgets);

    return Future.value(updatedWidgets);
  }
}
