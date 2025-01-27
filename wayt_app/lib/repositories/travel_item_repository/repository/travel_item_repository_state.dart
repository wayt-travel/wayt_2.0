part of 'travel_item_repository.dart';

/// The common state for the travel item repository.
typedef TravelItemRepositoryState = RepositoryState<TravelItemEntityWrapper>;

/// The state for when a travel item is added to the repository.
typedef TravelItemRepositoryTravelItemAdded
    = RepositoryItemAdded<TravelItemEntityWrapper>;

/// The state for when a collection of travel items is fetched and saved in the
/// repository.
typedef TravelItemRepositoryTravelItemCollectionFetched
    = RepositoryCollectionFetched<TravelItemEntityWrapper>;

/// The state for when a travel item is updated in the repository.
typedef TravelItemRepositoryTravelItemUpdated
    = RepositoryItemUpdated<TravelItemEntityWrapper>;

/// The state for when a travel item is deleted from the repository.
typedef TravelItemRepositoryTravelItemDeleted
    = RepositoryItemDeleted<TravelItemEntityWrapper>;

/// State for when the order of travel items is updated.
class TravelItemRepositoryItemOrdersUpdated extends TravelItemRepositoryState {
  /// Default constructor.
  const TravelItemRepositoryItemOrdersUpdated({
    required this.travelDocumentId,
    required this.updatedOrders,
  });

  /// The travel document ID.
  final TravelDocumentId travelDocumentId;

  /// The updated orders.
  ///
  /// The key is the travel item ID and the value is the new order.
  final Map<String, int> updatedOrders;

  @override
  List<Object?> get props => [travelDocumentId, updatedOrders];
}
