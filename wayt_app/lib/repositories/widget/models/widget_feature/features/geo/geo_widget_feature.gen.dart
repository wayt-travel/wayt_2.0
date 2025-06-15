import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:fpdart/fpdart.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pub_semver/pub_semver.dart';

import '../../../../../../util/util.dart';
import '../../../../../repositories.dart';

part 'geo_widget_feature.gen.g.dart';

/// A Widget feature that contains geographical information.
abstract interface class GeoWidgetFeatureEntity implements WidgetFeatureEntity {
  /// The name of the location.
  String? get name;

  /// The full address of the location.
  String? get address;

  /// The coordinates of the location.
  LatLng get latLng;

  /// The date and time when the location was recorded.
  /// If null, the location was not recorded at a specific time or the
  /// timestamp is not meaningful.
  DateTime? get timestamp;
}

/// Implementation of [GeoWidgetFeatureEntity].
@JsonSerializable(constructor: '_')
@VersionJsonConverter()
class GeoWidgetFeatureModel extends WidgetFeatureModel
    implements GeoWidgetFeatureEntity {
  @override
  final String? name;

  @override
  final String? address;

  @override
  final LatLng latLng;

  @override
  final DateTime? timestamp;

  /// Creates a new [GeoWidgetFeatureModel] instance.
  GeoWidgetFeatureModel({
    required String id,
    required LatLng latLng,
    DateTime? timestamp,
    String? name,
    String? address,
    Version? version,
  }) : this._(
          id: id,
          latLng: latLng,
          timestamp: timestamp,
          name: name,
          address: address,
          version: version ?? Version(1, 0, 0),
          type: WidgetFeatureType.geo,
        );

  /// Private constructor for [GeoWidgetFeatureModel].
  GeoWidgetFeatureModel._({
    required super.id,
    required this.latLng,
    required this.timestamp,
    required this.address,
    required this.name,
    required super.version,
    required super.type,
  });

  /// Creates a [GeoWidgetFeatureModel] from a JSON map.
  factory GeoWidgetFeatureModel.fromJson(Map<String, dynamic> json) =>
      _$GeoWidgetFeatureModelFromJson(json);

  /// Converts this [GeoWidgetFeatureModel] to a JSON map.
  @override
  Json toJson() => _$GeoWidgetFeatureModelToJson(this);

  /// Creates a copy of this [GeoWidgetFeatureModel] with the given
  /// parameters.
  GeoWidgetFeatureModel copyWith({
    Option<String?> name = const Option.none(),
    Option<String?> address = const Option.none(),
    Option<DateTime?> timestamp = const Option.none(),
    LatLng? latLng,
  }) =>
      GeoWidgetFeatureModel._(
        id: id,
        latLng: latLng ?? this.latLng,
        name: name.getOr(this.name),
        address: address.getOr(this.address),
        timestamp: timestamp.getOr(this.timestamp),
        version: version,
        type: type,
      );

  @override
  List<Object?> get props => [
        ...super.props,
        name,
        address,
        latLng,
        timestamp,
      ];

  @override
  Map<String, dynamic> $toMap() => {
        ...super.$toMap(),
        'name': name,
        'address': address,
        'latLng': latLng,
        'timestamp': timestamp?.toIso8601String(),
      };
}
