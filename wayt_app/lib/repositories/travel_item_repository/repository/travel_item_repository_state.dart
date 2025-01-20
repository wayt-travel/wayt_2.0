part of 'travel_item_repository.dart';

typedef TravelItemRepositoryState = RepositoryState<TravelItemEntity>;

typedef TravelItemRepositoryTravelItemAdded
    = RepositoryItemAdded<TravelItemEntity>;
typedef TravelItemRepositoryTravelItemCollectionFetched
    = RepositoryCollectionFetched<TravelItemEntity>;
typedef TravelItemRepositoryTravelItemFetched
    = RepositoryItemFetched<TravelItemEntity>;
typedef TravelItemRepositoryTravelItemUpdated
    = RepositoryItemUpdated<TravelItemEntity>;
typedef TravelItemRepositoryTravelItemDeleted
    = RepositoryItemDeleted<TravelItemEntity>;

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
