import 'package:pub_semver/pub_semver.dart';

import '../../widget_feature.dart';

/// {@template media_widget_feature}
/// A media feature.
///
/// This feature provides a widget with a media element, such as an image,
/// video, etc. The type of media is defined by the [mediaType] property.
/// {@endtemplate}
abstract interface class MediaWidgetFeatureEntity
    implements WidgetFeatureEntity {
  /// {@template media_widget_feature_url}
  /// The URL of the media.
  ///
  /// If null it means that the media file is not currently available.
  /// This can happen when the media has not been uploaded yet.
  /// {@endtemplate}
  String? get url;

  /// The type of the media.
  MediaFeatureType get mediaType;

  /// {@template media_widget_feature_byte_count}
  /// The size of the media in bytes.
  ///
  /// If null it means that the size was not computed and stored, but
  /// it has nothing to do with the availability of the media.
  /// {@endtemplate}
  int? get byteCount;

  /// The metadata of the media.
  ///
  /// This is a map of key-value pairs that can be used to store additional
  /// information about the media.
  Map<String, dynamic>? get metadata;

  /// {@template media_widget_feature_extension}
  /// The extension of the media, such as `.jpg`, `.png`.
  ///
  /// **It includes the dot.**
  /// {@endtemplate}
  String get mediaExtension;
}

/// {@macro media_widget_feature}
final class MediaWidgetFeatureModel extends WidgetFeatureModel
    implements MediaWidgetFeatureEntity {
  @override
  final String? url;

  @override
  final MediaFeatureType mediaType;

  @override
  final int? byteCount;

  @override
  final Map<String, dynamic>? metadata;

  @override
  final String mediaExtension;

  /// Creates a new [MediaWidgetFeatureModel] instance.
  ///
  /// {@macro media_widget_feature}
  MediaWidgetFeatureModel({
    required super.id,
    required this.url,
    required this.mediaType,
    required this.byteCount,
    required this.metadata,
    required this.mediaExtension,
  }) : super(
          type: WidgetFeatureType.media,
          version: Version(1, 0, 0),
        );

  /// Creates a copy of this [MediaWidgetFeatureModel] with the given
  /// parameters.
  MediaWidgetFeatureModel copyWith({
    int? index,
    String? url,
    int? byteCount,
    Map<String, dynamic>? metadata,
  }) =>
      MediaWidgetFeatureModel(
        id: id,
        url: url ?? this.url,
        mediaType: mediaType,
        byteCount: byteCount ?? this.byteCount,
        metadata: metadata ?? this.metadata,
        mediaExtension: mediaExtension,
      );

  @override
  List<Object?> get props => [
        ...super.props,
        url,
        mediaType,
        mediaExtension,
        byteCount,
        metadata,
      ];

  @override
  Map<String, dynamic> $toMap() => {
        ...super.$toMap(),
        'mediaExtension': mediaExtension,
        'mediaType': mediaType.toString(),
        'url': url,
        'byteCount': byteCount,
        'metadata': metadata,
      };
}
