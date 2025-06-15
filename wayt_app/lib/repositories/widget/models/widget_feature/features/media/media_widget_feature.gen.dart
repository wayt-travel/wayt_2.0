import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pub_semver/pub_semver.dart';

import '../../../../../repositories.dart';

part 'media_widget_feature.gen.g.dart';

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
  Json? get metadata;

  /// {@template media_widget_feature_extension}
  /// The extension of the media, such as `.jpg`, `.png`.
  ///
  /// **It includes the dot.**
  /// {@endtemplate}
  String get mediaExtension;
}

/// {@macro media_widget_feature}
@JsonSerializable(constructor: '_')
@VersionJsonConverter()
final class MediaWidgetFeatureModel extends WidgetFeatureModel
    implements MediaWidgetFeatureEntity {
  @override
  final String? url;

  @override
  final MediaFeatureType mediaType;

  @override
  final int? byteCount;

  @override
  final Json? metadata;

  @override
  final String mediaExtension;

  /// Creates a new [MediaWidgetFeatureModel] instance.
  ///
  /// {@macro media_widget_feature}
  MediaWidgetFeatureModel({
    required String id,
    required String? url,
    required MediaFeatureType mediaType,
    required int? byteCount,
    required Json? metadata,
    required String mediaExtension,
    Version? version,
  }) : this._(
          id: id,
          url: url,
          mediaType: mediaType,
          byteCount: byteCount,
          metadata: metadata,
          mediaExtension: mediaExtension,
          type: WidgetFeatureType.media,
          version: version ?? Version(1, 0, 0),
        );

  /// Private constructor used for json serialization.
  MediaWidgetFeatureModel._({
    required super.id,
    required this.url,
    required this.mediaType,
    required this.byteCount,
    required this.metadata,
    required this.mediaExtension,
    required super.type,
    required super.version,
  });

  /// Creates a new [MediaWidgetFeatureModel] from a JSON map.
  factory MediaWidgetFeatureModel.fromJson(Json json) =>
      _$MediaWidgetFeatureModelFromJson(json);

  /// Converts this instance to a JSON map.
  @override
  Json toJson() => _$MediaWidgetFeatureModelToJson(this);

  /// Creates a copy of this [MediaWidgetFeatureModel] with the given
  /// parameters.
  MediaWidgetFeatureModel copyWith({
    int? index,
    String? url,
    int? byteCount,
    Json? metadata,
  }) =>
      MediaWidgetFeatureModel._(
        id: id,
        url: url ?? this.url,
        mediaType: mediaType,
        byteCount: byteCount ?? this.byteCount,
        metadata: metadata ?? this.metadata,
        mediaExtension: mediaExtension,
        version: version,
        type: type,
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
