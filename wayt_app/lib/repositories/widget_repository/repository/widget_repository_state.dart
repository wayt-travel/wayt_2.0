part of 'widget_repository.dart';

typedef WidgetRepositoryState = RepositoryState<WidgetEntity>;

typedef WidgetRepositoryWidgetAdded = RepositoryItemAdded<WidgetEntity>;
typedef WidgetRepositoryWidgetCollectionFetched
    = RepositoryCollectionFetched<WidgetEntity>;
typedef WidgetRepositoryWidgetFetched = RepositoryItemFetched<WidgetEntity>;
typedef WidgetRepositoryWidgetUpdated = RepositoryItemUpdated<WidgetEntity>;
typedef WidgetRepositoryWidgetDeleted = RepositoryItemDeleted<WidgetEntity>;

/// State for when the order of widgets is updated.
class WidgetRepositoryWidgetOrdersUpdated extends WidgetRepositoryState {
  const WidgetRepositoryWidgetOrdersUpdated({
    required this.travelDocumentId,
    required this.updatedOrders,
  });

  final TravelDocumentId travelDocumentId;
  final Map<String, int> updatedOrders;

  @override
  List<Object?> get props => [travelDocumentId, updatedOrders];
}
