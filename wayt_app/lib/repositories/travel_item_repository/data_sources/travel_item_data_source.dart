import '../../repositories.dart';

/// Data source for TravelItem entities.
abstract interface class TravelItemDataSource {
  /// Reorders the items in a travel document.
  ///
  /// This method supports reordering the items in the root of the travel
  /// document as well as the items contained in a folder. For the latter, the
  /// [folderId] should be provided.
  ///
  /// Returns a map of the items with their new order. If the order of an item
  /// was not changed, it will not be included in the returned map.
  Future<Map<String, int>> reorderItems({
    required TravelDocumentId travelDocumentId,
    required List<String> reorderedItemIds,
    String? folderId,
  });
}
