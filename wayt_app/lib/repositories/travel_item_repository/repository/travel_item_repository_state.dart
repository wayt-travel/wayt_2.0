part of 'travel_item_repository.dart';

typedef TravelItemRepositoryState = RepositoryState<TravelItemEntityWrapper>;

typedef TravelItemRepositoryTravelItemAdded
    = RepositoryItemAdded<TravelItemEntityWrapper>;
typedef TravelItemRepositoryTravelItemCollectionFetched
    = RepositoryCollectionFetched<TravelItemEntityWrapper>;
typedef TravelItemRepositoryTravelItemUpdated
    = RepositoryItemUpdated<TravelItemEntityWrapper>;
typedef TravelItemRepositoryTravelItemDeleted
    = RepositoryItemDeleted<TravelItemEntityWrapper>;

/// State for when the order of travel items is updated.
class TravelItemRepositoryItemOrdersUpdated extends TravelItemRepositoryState {
  const TravelItemRepositoryItemOrdersUpdated({
    required this.travelDocumentId,
    required this.updatedOrders,
  });

  final TravelDocumentId travelDocumentId;
  final Map<String, int> updatedOrders;

  @override
  List<Object?> get props => [travelDocumentId, updatedOrders];
}
