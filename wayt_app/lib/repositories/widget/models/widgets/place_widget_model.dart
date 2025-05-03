part of '../widget_model.dart';

/// {@template place_widget_model}
/// A widget that represents a place.
///
/// This widget can be used to display a place in the travel document.
/// At least [latLng] and [name] are required.
///
/// The [id] uniquely identifies the widget.
///
/// The [order] is the order of the widget in the travel document.
///
/// The [travelDocumentId] is the ID of the travel document to which the
/// widget belongs.
///
/// The [latLng] are the latitude and longitude of the location.
///
/// The [name] is the name of the place.
///
/// The [address] is the full address of the place. It can be null.
///
/// The [folderId] is the ID of the folder where the widget is stored.
/// If null, the widget is stored in the root of the travel document.
///
/// The [createdAt] is the date and time when the widget was created.
/// If null, the current date and time is used.
///
/// The [updatedAt] is the date and time when the widget was last updated.
/// If null, the widget has not been updated yet.
/// {@endtemplate}
final class PlaceWidgetModel extends WidgetModel {
  /// {@macro place_widget_model}
  factory PlaceWidgetModel({
    required String id,
    required int order,
    required TravelDocumentId travelDocumentId,
    required LatLng latLng,
    required String name,
    String? address,
    String? folderId,
    DateTime? createdAt,
  }) =>
      PlaceWidgetModel._(
        id: id,
        order: order,
        features: [
          GeoWidgetFeatureModel(
            id: const Uuid().v4(),
            latLng: latLng,
            address: address,
            name: name,
          ),
        ],
        folderId: folderId,
        createdAt: createdAt ?? DateTime.now().toUtc(),
        travelDocumentId: travelDocumentId,
        updatedAt: null,
      );

  PlaceWidgetModel._({
    required super.id,
    required super.order,
    required super.features,
    required super.folderId,
    required super.createdAt,
    required super.travelDocumentId,
    required super.updatedAt,
  }) : super(
          type: WidgetType.place,
          version: Version(1, 0, 0),
        );

  /// The name of the place.
  String get name => _geoFeature.name ?? '';

  /// The full address of the place.
  String? get address => _geoFeature.address;

  /// The coordinates of the place.
  LatLng get latLng => _geoFeature.latLng;

  GeoWidgetFeatureModel get _geoFeature =>
      features.first as GeoWidgetFeatureModel;

  @override
  WidgetModel copyWith({
    Option<String?> folderId = const Option.none(),
    int? order,
    DateTime? updatedAt,
    String? name,
    Option<String?> address = const Option.none(),
    LatLng? latLng,
  }) =>
      PlaceWidgetModel._(
        id: id,
        order: order ?? this.order,
        features: [
          _geoFeature.copyWith(
            // Do not change the name if it is null
            name: Option.fromNullable(name),
            address: address,
            latLng: latLng ?? this.latLng,
          ),
        ],
        folderId: folderId.getOrElse(() => this.folderId),
        createdAt: createdAt,
        travelDocumentId: travelDocumentId,
        updatedAt: updatedAt ?? DateTime.now().toUtc(),
      );
}
