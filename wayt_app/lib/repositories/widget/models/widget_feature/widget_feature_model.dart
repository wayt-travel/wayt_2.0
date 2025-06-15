import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pub_semver/pub_semver.dart';

import '../../widget.dart';

/// Parent model for all features of a widget in a travel document.
@JsonSerializable(
  createToJson: false,
  createFactory: false,
)
abstract class WidgetFeatureModel extends Model implements WidgetFeatureEntity {
  @override
  final String id;

  @JsonKey()
  @override
  final WidgetFeatureType type;

  @override
  final Version version;

  /// Creates a new [WidgetFeatureModel] instance.
  WidgetFeatureModel({
    required this.id,
    required this.version,
    required this.type,
  });

  @override
  @mustCallSuper
  List<Object?> get props => [
        id,
        version,
        type,
      ];

  /// Converts the model to a map.
  Json toJson();

  /// Creates a new [WidgetFeatureModel] implementation from the given JSON.
  factory WidgetFeatureModel.fromJson(Map<String, dynamic> json) {
    final type = WidgetFeatureType.fromName(json['type'] as String);
    return switch (type) {
      WidgetFeatureType.geo => GeoWidgetFeatureModel.fromJson(json),
      WidgetFeatureType.typography =>
        TypographyWidgetFeatureModel.fromJson(json),
      WidgetFeatureType.media => MediaWidgetFeatureModel.fromJson(json),
      WidgetFeatureType.crono => CronoWidgetFeatureModel.fromJson(json),
      WidgetFeatureType.meansOfTransport =>
        MeansOfTransportWidgetFeatureModel.fromJson(json),
      WidgetFeatureType.price => throw UnimplementedError(),
    };
  }

  @override
  @mustCallSuper
  Map<String, dynamic> $toMap() => {
        'id': id,
        'type': type.toString(),
        'version': version.toString(),
      };
}
