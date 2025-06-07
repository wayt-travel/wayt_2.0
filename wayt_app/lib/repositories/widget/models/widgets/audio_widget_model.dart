part of '../widget_model.dart';

/// {@template audio_widget_model}
/// A widget that represents an audio file.
///
/// This widget can be used to display an audio in the travel document.
/// The [id] uniquely identifies the widget.
///
/// The [name] is the name displayed in the travel document.
/// The default value is audio_CREATED_AT.
///
/// The [url] is the remote URL of the audio. It can be null if the audio has
/// not been uploaded yet.
/// The [order] is the order of the widget in the travel document.
///
/// The [travelDocumentId] is the ID of the travel document to which the
/// widget belongs.
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
/// It includes the dot.
/// {@endtemplate}
final class AudioWidgetModel extends WidgetModel {
  /// {@macro audio_widget_model}
  factory AudioWidgetModel({
    required String id,
    required String name,
    required String mediaId,
    required String? url,
    required int order,
    required TravelDocumentId travelDocumentId,
    required int? byteCount,
    required String mediaExtension,
    required int duration,
    String? folderId,
    DateTime? createdAt,
  }) {
    return AudioWidgetModel._(
      id: id,
      order: order,
      features: [
        DurationWidgetFeatureModel(
          id: const Uuid().v4(),
          data: Duration(milliseconds: duration),
        ),
        MediaWidgetFeatureModel(
          id: mediaId,
          url: url,
          mediaExtension: mediaExtension,
          byteCount: byteCount,
          mediaType: MediaFeatureType.audio,
          metadata: null,
        ),
        TypographyWidgetFeatureModel(
          id: const Uuid().v4(),
          data: name,
          format: TypographyFormat.plain,
        ),
      ],
      folderId: folderId,
      createdAt: createdAt ?? DateTime.now().toUtc(),
      travelDocumentId: travelDocumentId,
      updatedAt: null,
    );
  }

  /// {@macro audio_widget_model}
  AudioWidgetModel._({
    required super.id,
    required super.features,
    required super.folderId,
    required super.order,
    required super.createdAt,
    required super.travelDocumentId,
    required super.updatedAt,
  }) : super(
          type: WidgetType.audio,
          version: Version(1, 0, 0),
        );

  DurationWidgetFeatureModel get _durationFeature =>
      features.whereType<DurationWidgetFeatureModel>().first;

  MediaWidgetFeatureModel get _mediaFeature =>
      features.whereType<MediaWidgetFeatureModel>().first;

  /// {@macro media_widget_feature_url}
  String? get url => _mediaFeature.url;

  /// {@macro media_widget_feature_extension}
  String get mediaExtension => _mediaFeature.mediaExtension;

  /// {@macro duration_widget_feature_data}
  Duration get duration => _durationFeature.data;

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

  /// The ID of the media.
  ///
  /// This is the ID of the media file, not the widget.
  String get mediaId => _mediaFeature.id;

  /// The type of the media.
  MediaFeatureType get mediaType => _mediaFeature.mediaType;

  TypographyWidgetFeatureModel get _nameFeature =>
      features.whereType<TypographyWidgetFeatureModel>().first;

  /// The name of the audio.
  String get name =>
      features.whereType<TypographyWidgetFeatureModel>().first.data;

  @override
  WidgetModel copyWith({
    Option<String?> folderId = const Option.none(),
    int? order,
    DateTime? updatedAt,
    Option<String?> url = const Option.none(),
    String? name,
  }) {
    final nameFeature =
        name != null ? _nameFeature.copyWith(data: name) : _nameFeature;
    return AudioWidgetModel._(
      id: id,
      order: order ?? this.order,
      travelDocumentId: travelDocumentId,
      folderId: folderId.getOrElse(() => this.folderId),
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      features: [
        _durationFeature,
        _mediaFeature.copyWith(
          url: url.getOrElse(() => this.url),
          byteCount: _mediaFeature.byteCount,
        ),
        nameFeature,
      ].nonNulls.toList(),
    );
  }
}
