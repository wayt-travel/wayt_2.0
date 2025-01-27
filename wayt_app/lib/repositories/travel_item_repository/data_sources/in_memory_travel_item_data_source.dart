import 'package:flext/flext.dart';

import '../../../init/in_memory_data.dart';
import '../../repositories.dart';

/// In-memory implementation of the travel item data source.
final class InMemoryTravelItemDataSource implements TravelItemDataSource {
  final InMemoryDataHelper _dataHelper;

  /// Creates a new instance of [InMemoryTravelItemDataSource].
  InMemoryTravelItemDataSource(this._dataHelper);

  @override
  Future<Map<String, int>> reorderItems({
    required TravelDocumentId travelDocumentId,
    required List<String> reorderedItemIds,
    String? folderId,
  }) async {
    final travelDocument =
        _dataHelper.getTravelDocumentWrapper(travelDocumentId);
    late final List<TravelItemEntity> itemsBefore;

    if (folderId == null) {
      itemsBefore = travelDocument.rootTravelItems.toList();
    } else {
      itemsBefore = travelDocument.travelItems
          .firstWhere((e) => e.value.id == folderId)
          .asFolderWidgetWrapper
          .children
          .toList();
    }
    final reorderedItems = itemsBefore
        .sorted((a, b) {
          final aIndex = reorderedItemIds.indexOf(a.id);
          final bIndex = reorderedItemIds.indexOf(b.id);
          return aIndex.compareTo(bIndex);
        })
        .mapIndexed((j, item) => item.copyWith(order: j))
        .toList();
    _dataHelper.saveTravelItems(reorderedItems);

    return reorderedItems
        // Return only the items whose order has been updated with the
        // corresponding updated value.
        .where(
          (e) => e.order != itemsBefore.firstWhere((e) => e.id == e.id).order,
        )
        .map((e) => MapEntry(e.id, e.order))
        .let(Map.fromEntries);
  }
}
