part of '../widget_model.dart';

/// {@template photo_widget_model}
/// A widget that represents a photo.
///
/// This widget can be used to display a photo in the travel document.
///
/// The [id] uniquely identifies the widget.
///
/// The [url] is the remote URL of the photo. It can be null if the photo has
/// not been uploaded yet.
///
/// The [order] is the order of the widget in the travel document.
///
/// The [travelDocumentId] is the ID of the travel document to which the
/// widget belongs.
///
/// The [byteCount] is the size of the photo in bytes. It can be null if the
/// size was not computed and stored.
///
/// The [latLng] are the latitude and longitude of the location where
/// the photo was taken. It can be null if the photo is not geotagged.
///
/// The [folderId] is the ID of the folder where the widget is stored.
/// If null, the widget is stored in the root of the travel document.
///
/// The [createdAt] is the date and time when the widget was created.
/// If null, the current date and time is used.
///
/// The [updatedAt] is the date and time when the widget was last updated.
/// If null, the widget has not been updated yet.
///
/// The [mediaExtension] is the extension of the media file.
/// It includes the dot, e.g. ".jpg".
///
/// The [size] is the size of the photo.
/// It is used to store the size of the photo in the metadata.
/// {@endtemplate}
final class PhotoWidgetModel extends WidgetModel {
  /// {@macro photo_widget_model}
  ///
  /// The [metadata] is a map of additional metadata that can be stored
  factory PhotoWidgetModel({
    required String id,
    required String mediaId,
    required String? url,
    required int order,
    required TravelDocumentId travelDocumentId,
    required int? byteCount,
    required LatLng? latLng,
    required String mediaExtension,
    required IntSize size,
    required DateTime? takenAt,
    Map<String, dynamic>? metadata,
    String? folderId,
    DateTime? createdAt,
  }) =>
      PhotoWidgetModel._(
        id: id,
        order: order,
        features: [
          MediaWidgetFeatureModel(
            id: mediaId,
            url: url,
            mediaExtension: mediaExtension,
            byteCount: byteCount,
            mediaType: MediaFeatureType.image,
            metadata: {
              'size': size.toJson(),
              ...?metadata,
            },
          ),
          if (latLng != null)
            GeoWidgetFeatureModel(
              id: const Uuid().v4(),
              latLng: latLng,
              timestamp: takenAt,
            ),
        ],
        folderId: folderId,
        createdAt: createdAt ?? DateTime.now().toUtc(),
        travelDocumentId: travelDocumentId,
        updatedAt: null,
      );

  PhotoWidgetModel._({
    required super.id,
    required super.order,
    required super.features,
    required super.folderId,
    required super.createdAt,
    required super.travelDocumentId,
    required super.updatedAt,
  }) : super(
          type: WidgetType.photo,
          version: Version(1, 0, 0),
        );

  /// {@macro media_widget_feature_url}
  String? get url => _mediaFeature.url;

  /// Path to the local file of the photo.
  ///
  /// Returns null if the photo is not stored locally.
  String? get localPath => TravelDocumentLocalMediaDataSource.I.getMediaPath(
        travelDocumentId: travelDocumentId,
        folderId: folderId,
        mediaExtension: _mediaFeature.mediaExtension,
        mediaWidgetFeatureId: _mediaFeature.id,
      );

  /// {@macro media_widget_feature_byte_count}
  int? get byteCount => _mediaFeature.byteCount;

  /// The coordinates where the photo was taken.
  ///
  /// Returns null if the photo is not geotagged.
  LatLng? get latLng => _geoFeature?.latLng;

  /// The type of the media.
  MediaFeatureType get mediaType => _mediaFeature.mediaType;

  /// {@macro media_widget_feature_extension}
  String get mediaExtension => _mediaFeature.mediaExtension;

  /// The ID of the media.
  ///
  /// This is the ID of the media file, not the widget.
  String get mediaId => _mediaFeature.id;

  MediaWidgetFeatureModel get _mediaFeature =>
      features.whereType<MediaWidgetFeatureModel>().first;

  GeoWidgetFeatureModel? get _geoFeature =>
      features.whereType<GeoWidgetFeatureModel>().firstOrNull;

  /// The size of the photo.
  IntSize? get size => IntSize.maybeFromJson(
        _mediaFeature.metadata?['size'] as Map<String, dynamic>?,
      );

  @override
  WidgetModel copyWith({
    Option<String?> folderId = const Option.none(),
    int? order,
    DateTime? updatedAt,
    Option<LatLng?> latLng = const Option.none(),
    Option<DateTime?> takenAt = const Option.none(),
    Map<String, dynamic>? metadata,
    Option<String?> url = const Option.none(),
  }) =>
      PhotoWidgetModel._(
        id: id,
        order: order ?? this.order,
        travelDocumentId: travelDocumentId,
        folderId: folderId.getOrElse(() => this.folderId),
        createdAt: createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        features: [
          _mediaFeature.copyWith(
            url: url.getOrElse(() => this.url),
            byteCount: _mediaFeature.byteCount,
            metadata: metadata,
          ),
          if (latLng.isSome() || _geoFeature != null)
            _geoFeature?.copyWith(
              latLng: latLng.getOrElse(() => this.latLng),
              timestamp: takenAt,
            ),
        ].nonNulls.toList(),
      );
}
