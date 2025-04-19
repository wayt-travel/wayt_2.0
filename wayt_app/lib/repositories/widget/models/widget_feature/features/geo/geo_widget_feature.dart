import 'package:pub_semver/pub_semver.dart';

import '../../../../../../util/validators.dart';
import '../../../../../repositories.dart';

/// A Widget feature that contains geographical information.
abstract interface class GeoWidgetFeatureEntity implements WidgetFeatureEntity {
  /// The name of the location.
  String? get name;

  /// The full address of the location.
  String? get address;

  /// The coordinates of the location.
  (double, double) get coordinates;
}

/// Implementation of [GeoWidgetFeatureEntity].
class GeoWidgetFeatureModel extends WidgetFeatureModel
    implements GeoWidgetFeatureEntity {
  @override
  final String? name;

  @override
  final String? address;

  @override
  final (double, double) coordinates;

  /// Creates a new [GeoWidgetFeatureModel] instance.
  GeoWidgetFeatureModel({
    required super.id,
    required super.index,
    required this.coordinates,
    this.name,
    this.address,
  })  : assert(
          const Validators().coordinates().validateValue(coordinates).isValid,
          'Invalid coordinates',
        ),
        super(
          type: WidgetFeatureType.geo,
          version: Version(1, 0, 0),
        );

  /// Creates a copy of this [GeoWidgetFeatureModel] with the given
  /// parameters.
  GeoWidgetFeatureModel copyWith({
    String? name,
    String? address,
    (double, double)? coordinates,
  }) =>
      GeoWidgetFeatureModel(
        id: id,
        index: index,
        coordinates: coordinates ?? this.coordinates,
        name: name ?? this.name,
        address: address ?? this.address,
      );

  @override
  List<Object?> get props => [
        ...super.props,
        name,
        address,
        coordinates,
      ];

  @override
  Map<String, dynamic> $toMap() => {
        ...super.$toMap(),
        'name': name,
        'address': address,
        'coordinates': coordinates,
      };
}
