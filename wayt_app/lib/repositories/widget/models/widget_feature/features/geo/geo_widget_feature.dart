import 'package:fpdart/fpdart.dart';
import 'package:pub_semver/pub_semver.dart';

import '../../../../../../util/util.dart';
import '../../../../../repositories.dart';

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
    required super.id,
    required this.latLng,
    this.timestamp,
    this.name,
    this.address,
  }) : super(
          type: WidgetFeatureType.geo,
          version: Version(1, 0, 0),
        );

  /// Creates a copy of this [GeoWidgetFeatureModel] with the given
  /// parameters.
  GeoWidgetFeatureModel copyWith({
    Option<String?> name = const Option.none(),
    Option<String?> address = const Option.none(),
    Option<DateTime?> timestamp = const Option.none(),
    LatLng? latLng,
  }) =>
      GeoWidgetFeatureModel(
        id: id,
        latLng: latLng ?? this.latLng,
        name: name.getOr(this.name),
        address: address.getOr(this.address),
        timestamp: timestamp.getOr(this.timestamp),
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
