import 'package:fpdart/fpdart.dart';
import 'package:pub_semver/pub_semver.dart';

import '../../../../../repositories.dart';

/// A Widget feature that contains geographical information.
abstract interface class GeoWidgetFeatureEntity implements WidgetFeatureEntity {
  /// The name of the location.
  String? get name;

  /// The full address of the location.
  String? get address;

  /// The coordinates of the location.
  LatLng get latLng;
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

  /// Creates a new [GeoWidgetFeatureModel] instance.
  GeoWidgetFeatureModel({
    required super.id,
    required super.index,
    required this.latLng,
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
    LatLng? latLng,
  }) =>
      GeoWidgetFeatureModel(
        id: id,
        index: index,
        latLng: latLng ?? this.latLng,
        name: name.getOrElse(() => this.name),
        address: address.getOrElse(() => this.address),
      );

  @override
  List<Object?> get props => [
        ...super.props,
        name,
        address,
        latLng,
      ];

  @override
  Map<String, dynamic> $toMap() => {
        ...super.$toMap(),
        'name': name,
        'address': address,
        'latLng': latLng,
      };
}
