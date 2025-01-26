import 'package:flext/flext.dart';

import '../../../init/in_memory_data.dart';
import '../../repositories.dart';

/// In-memory implementation of the WidgetFolder data source.
final class InMemoryWidgetFolderDataSource implements WidgetFolderDataSource {
  final InMemoryDataHelper _dataHelper;

  InMemoryWidgetFolderDataSource(this._dataHelper);

  @override
  Future<UpsertWidgetFolderOutput> create(CreateWidgetFolderInput input) {
    if (!_dataHelper.containsTravelDocument(input.travelDocumentId)) {
      throw ArgumentError.value(
        input.travelDocumentId,
        'input.travelDocumentId',
        'The travel document does not exist.',
      );
    }

    final index = input.index;
    final folder = WidgetFolderModel(
      id: _dataHelper.generateUuid(),
      travelDocumentId: input.travelDocumentId,
      createdAt: DateTime.now().toUtc(),
      updatedAt: null,
      order: -1,
      name: input.name,
      icon: input.icon,
      color: input.color,
    );

    // Get the travel items of the plan or journal and insert the widget at the
    // specified index.
    var travelItems = _dataHelper
        .getTravelDocumentWrapper(input.travelDocumentId)
        .rootTravelItems
        .toList();

    if (index == null) {
      travelItems.add(folder);
    } else if (index.isBetween(0, travelItems.length)) {
      travelItems.insert(index, folder);
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
        : <WidgetFolderModel>[];

    // Build the output.
    return Future.value(
      (
        widgetFolder: _dataHelper.getWidgetFolder(folder.id),
        updatedOrders: {
          for (final items in updatedTravelItems) items.id: items.order,
        },
      ),
    );
  }

  @override
  Future<WidgetFolderModel> read(String id) async =>
      _dataHelper.getWidgetFolder(id);

  @override
  Future<void> delete(String id) async {
    await waitFakeTime();
    _dataHelper.deleteItem(id);
  }
}
