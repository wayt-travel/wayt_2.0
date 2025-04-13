import 'package:a2f_sdk/a2f_sdk.dart';

import '../../../repositories.dart';
import 'events.dart';

/// State for when the order of items is updated successfully.
final class TravelItemRepoItemOrdersUpdateSuccess
    extends TravelItemRepositoryState<WidgetFolderEntity>
    with ModelToStringMixin {
  /// Creates a new instance.
  const TravelItemRepoItemOrdersUpdateSuccess({
    required this.travelDocumentId,
    required this.updatedOrders,
  });

  /// The travel document ID.
  final TravelDocumentId travelDocumentId;

  /// The updated orders of the items.
  /// The key is the ID of the item, and the value is the new order.
  /// If an item is not present in the map, it means that its order has not been
  /// updated.
  final Map<String, int> updatedOrders;

  @override
  List<Object?> get props => [travelDocumentId, updatedOrders];

  @override
  Map<String, dynamic> $toMap() => {
        'travelDocumentId': travelDocumentId,
        'updatedOrders.length': updatedOrders.length,
      };
}
