import 'package:flext/flext.dart';

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
  Future<WidgetModel> read(String id) async => _dataHelper.getWidget(id);

  @override
  Future<void> delete(String id) async {
    await waitFakeTime();
    _dataHelper.deleteItem(id);
  }
}
