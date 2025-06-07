part of '../widget_model.dart';

/// {@template file_widget_model}
/// A widget that represents a file.
///
/// This widget can be used to display a file in the travel document.
///
/// The [id] uniquely identifies the widget.
///
/// The [name] is the name displayed in the travel document.
/// The default value is the name of the file.
///
/// The [url] is the remote URL of the file. It can be null if the file has
/// not been uploaded yet.
///
/// The [order] is the order of the widget in the travel document.
///
/// The [travelDocumentId] is the ID of the travel document to which the
/// widget belongs.
///
/// The [byteCount] is the size of the file in bytes. It can be null if the
/// size was not computed and stored.
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
/// {@endtemplate}
final class FileWidgetModel extends WidgetModel {
  /// {@macro file_widget_model}
  factory FileWidgetModel({
    required String id,
    required String mediaId,
    required String? url,
    required int order,
    required TravelDocumentId travelDocumentId,
    required int? byteCount,
    required String mediaExtension,
    required String name,
    String? folderId,
    DateTime? createdAt,
  }) =>
      FileWidgetModel._(
        id: id,
        order: order,
        features: [
          TypographyWidgetFeatureModel(
            id: const Uuid().v4(),
            data: name,
            format: TypographyFormat.plain,
          ),
          MediaWidgetFeatureModel(
            id: mediaId,
            url: url,
            mediaExtension: mediaExtension,
            byteCount: byteCount,
            mediaType: MediaFeatureType.file,
            metadata: null,
          ),
        ],
        folderId: folderId,
        createdAt: createdAt ?? DateTime.now().toUtc(),
        travelDocumentId: travelDocumentId,
        updatedAt: null,
      );

  FileWidgetModel._({
    required super.id,
    required super.order,
    required super.features,
    required super.folderId,
    required super.createdAt,
    required super.travelDocumentId,
    required super.updatedAt,
  }) : super(
          type: WidgetType.file,
          version: Version(1, 0, 0),
        );

  // Getters
  /// Path to the local file.
  ///
  /// Returns null if the file is not stored locally.
  String? get localPath => TravelDocumentLocalMediaDataSource.I.getMediaPath(
        travelDocumentId: travelDocumentId,
        folderId: folderId,
        mediaExtension: _mediaFeature.mediaExtension,
        mediaWidgetFeatureId: _mediaFeature.id,
      );

  /// {@macro media_widget_feature_byte_count}
  int? get byteCount => _mediaFeature.byteCount;

  MediaWidgetFeatureModel get _mediaFeature =>
      features.whereType<MediaWidgetFeatureModel>().first;

  TypographyWidgetFeatureModel get _nameFeature =>
      features.whereType<TypographyWidgetFeatureModel>().first;

  /// The name of the file.
  String get name =>
      features.whereType<TypographyWidgetFeatureModel>().first.data;

  /// The type of the media.
  MediaFeatureType get mediaType => _mediaFeature.mediaType;

  /// {@macro media_widget_feature_extension}
  String get mediaExtension => _mediaFeature.mediaExtension;

  /// {@macro media_widget_feature_url}
  String? get url => _mediaFeature.url;

  @override
  WidgetModel copyWith({
    Option<String?> folderId = const Option.none(),
    int? order,
    DateTime? updatedAt,
    Option<String?> url = const Option.none(),
    String? name,
  }) {
    final mediaFeature = _mediaFeature.copyWith(
      url: url.getOrElse(() => this.url),
      byteCount: _mediaFeature.byteCount,
    );
    final nameFeature =
        name != null ? _nameFeature.copyWith(data: name) : _nameFeature;
    return FileWidgetModel._(
      id: id,
      order: order ?? this.order,
      travelDocumentId: travelDocumentId,
      folderId: folderId.getOrElse(() => this.folderId),
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      // Is important to keep the original features'order. See the constructor
      features: [nameFeature, mediaFeature],
    );
  }
}
