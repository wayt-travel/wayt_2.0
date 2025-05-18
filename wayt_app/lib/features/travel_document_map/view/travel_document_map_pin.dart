import '../../../repositories/repositories.dart';

/// Enumeration representing the types of map pins used in the travel document
/// map.
enum TravelDocumentMapPin {
  /// A pin representing a photo.
  photo,

  /// A pin representing a place.
  place;

  /// The icon asset path for the pin.
  String get assetPath => switch (this) {
        photo => 'assets/icons/map/photo.png',
        _ => 'assets/icons/map/other.png',
      };

  /// Gets the enum value from the given [TravelItemEntity].
  factory TravelDocumentMapPin.fromItem(TravelItemEntity item) {
    if (item is PhotoWidgetModel) {
      return TravelDocumentMapPin.photo;
    } else if (item is PlaceWidgetModel) {
      return TravelDocumentMapPin.place;
    } else if (item is TransferWidgetModel) {
      return TravelDocumentMapPin.place;
    }
    throw ArgumentError.value(
      item,
      'item',
      'Unsupported travel item type: ${item.runtimeType}',
    );
  }
}
