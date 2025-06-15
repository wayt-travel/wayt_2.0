import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pub_semver/pub_semver.dart';

import '../../../../../repositories.dart';

part 'means_of_transport_widget_feature.gen.g.dart';

/// A widget feature that represents a means of transport.
abstract interface class MeansOfTransportWidgetFeatureEntity
    implements WidgetFeatureEntity {
  /// The type of the means of transport.
  MeansOfTransportType get motType;
}

/// Implementation of [MeansOfTransportWidgetFeatureEntity].
@JsonSerializable(constructor: '_')
@VersionJsonConverter()
class MeansOfTransportWidgetFeatureModel extends WidgetFeatureModel
    implements MeansOfTransportWidgetFeatureEntity {
  @override
  final MeansOfTransportType motType;

  /// Creates a new [MeansOfTransportWidgetFeatureModel] instance.
  MeansOfTransportWidgetFeatureModel({
    required String id,
    required MeansOfTransportType motType,
    Version? version,
  }) : this._(
          id: id,
          motType: motType,
          type: WidgetFeatureType.meansOfTransport,
          version: version ?? Version(1, 0, 0),
        );

  /// Private constructor used for json serialization.
  MeansOfTransportWidgetFeatureModel._({
    required super.id,
    required this.motType,
    required super.type,
    required super.version,
  });

  /// Creates a new [MeansOfTransportWidgetFeatureModel] from a JSON map.
  factory MeansOfTransportWidgetFeatureModel.fromJson(Json json) =>
      _$MeansOfTransportWidgetFeatureModelFromJson(json);

  /// Converts this instance to a JSON map.
  @override
  Json toJson() => _$MeansOfTransportWidgetFeatureModelToJson(this);

  /// Creates a copy of this [MeansOfTransportWidgetFeatureModel] with the given
  /// parameters.

  MeansOfTransportWidgetFeatureModel copyWith({
    MeansOfTransportType? motType,
  }) =>
      MeansOfTransportWidgetFeatureModel._(
        id: id,
        motType: motType ?? this.motType,
        type: type,
        version: version,
      );

  @override
  List<Object?> get props => [
        ...super.props,
        id,
        motType,
      ];

  @override
  Map<String, dynamic> $toMap() => {
        ...super.$toMap(),
        'motType': motType.toString(),
      };
}
