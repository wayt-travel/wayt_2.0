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

  GeoWidgetFeatureModel({
    required super.id,
    required super.index,
    required this.coordinates,
    this.name,
    this.address,
  })  : assert(
          L10nValidators.coordinates().validateValue(coordinates).isValid,
          'Invalid coordinates',
        ),
        super(
          type: WidgetFeatureType.geo,
          version: Version(1, 0, 0),
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
