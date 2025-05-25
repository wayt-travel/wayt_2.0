part of 'travel_document_map_cubit.dart';

/// {@template travel_document_map_state}
/// Base class for the travel document map state.
/// {@endtemplate}
sealed class TravelDocumentMapState extends Equatable {
  /// {@macro travel_document_map_state}
  const TravelDocumentMapState();

  @override
  List<Object?> get props => [];
}

/// {@template travel_document_map_initial}
/// The initial state of the travel document map.
/// {@endtemplate}
final class TravelDocumentMapInitial extends TravelDocumentMapState {
  /// {@macro travel_document_map_initial}
  const TravelDocumentMapInitial();
}

/// {@template travel_document_map_initialized}
/// The state of the travel document map when it is initialized with the
/// travel items.
/// {@endtemplate}
final class TravelDocumentMapInitialized extends TravelDocumentMapState {
  /// The travel items to display on the map.
  ///
  /// This list is not pre-filtered, so it may contain items that are not
  /// meant to be displayed on the map (e.g., text widgets).
  final List<TravelItemEntity> travelItems;

  /// Where to center the map or the bounds where to place the camera.
  final Either<LatLng, LatLngBounds> centerOrBounds;

  /// {@macro travel_document_map_initialized}
  const TravelDocumentMapInitialized({
    required this.centerOrBounds,
    required this.travelItems,
  });

  @override
  List<Object?> get props => [centerOrBounds, travelItems];
}

/// {@template travel_document_map_item_added}
/// The state for when a new travel item is added to the map.
/// {@endtemplate}
final class TravelDocumentMapItemAdded extends TravelDocumentMapState {
  /// {@macro travel_document_map_item_added}
  const TravelDocumentMapItemAdded({required this.travelItem});

  /// The item added to the map.
  final TravelItemEntity travelItem;

  @override
  List<Object?> get props => [...super.props, travelItem];
}

/// {@template travel_document_map_item_removed}
/// The state for when a travel item is removed from the map.
/// {@endtemplate}
final class TravelDocumentMapItemRemoved extends TravelDocumentMapState {
  /// {@macro travel_document_map_item_removed}
  const TravelDocumentMapItemRemoved({required this.travelItem});

  /// The item removed from the map.
  final TravelItemEntity travelItem;

  @override
  List<Object?> get props => [...super.props, travelItem];
}

/// {@template travel_document_map_item_updated}
/// State for when a travel item is updated on the map.
/// {@endtemplate}
final class TravelDocumentMapItemUpdated extends TravelDocumentMapState {
  /// {@macro travel_document_map_item_updated}
  const TravelDocumentMapItemUpdated({
    required this.previous,
    required this.updated,
  });

  /// The previous travel item.
  final TravelItemEntity previous;

  /// The updated travel item.
  final TravelItemEntity updated;

  @override
  List<Object?> get props => [...super.props, previous, updated];
}
