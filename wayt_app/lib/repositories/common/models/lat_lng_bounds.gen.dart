import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../repositories.dart';

part 'lat_lng_bounds.gen.g.dart';

/// A latitude/longitude aligned rectangle.
///
/// The rectangle conceptually includes all points (lat, lng) where
/// * lat ∈ [`southwest.latitude`, `northeast.latitude`]
/// * lng ∈ [`southwest.longitude`, `northeast.longitude`],
///   if `southwest.longitude` ≤ `northeast.longitude`,
/// * lng ∈ [-180, `northeast.longitude`] ∪ [`southwest.longitude`, 180],
///   if `northeast.longitude` < `southwest.longitude`
@immutable
@JsonSerializable()
class LatLngBounds {
  /// Creates geographical bounding box with the specified corners.
  ///
  /// The latitude of the southwest corner cannot be larger than the
  /// latitude of the northeast corner.
  LatLngBounds({required this.southwest, required this.northeast})
      : assert(
          southwest.latitude <= northeast.latitude,
          'The latitude of the southwest corner cannot be larger than the '
          'latitude of the northeast corner.',
        );

  /// Creates a [LatLngBounds] from a JSON map.
  factory LatLngBounds.fromJson(Map<String, dynamic> json) =>
      _$LatLngBoundsFromJson(json);

  /// The southwest corner of the rectangle.
  final LatLng southwest;

  /// The northeast corner of the rectangle.
  final LatLng northeast;

  /// Serializes this instance to a JSON map.
  Map<String, dynamic> toJson() => _$LatLngBoundsToJson(this);

  /// Returns whether this rectangle contains the given [LatLng].
  bool contains(LatLng point) {
    return _containsLatitude(point.latitude) &&
        _containsLongitude(point.longitude);
  }

  bool _containsLatitude(double lat) {
    return (southwest.latitude <= lat) && (lat <= northeast.latitude);
  }

  bool _containsLongitude(double lng) {
    if (southwest.longitude <= northeast.longitude) {
      return southwest.longitude <= lng && lng <= northeast.longitude;
    } else {
      return southwest.longitude <= lng || lng <= northeast.longitude;
    }
  }

  @override
  String toString() {
    return '${objectRuntimeType(this, 'LatLngBounds')}($southwest, $northeast)';
  }

  @override
  bool operator ==(Object other) {
    return other is LatLngBounds &&
        other.southwest == southwest &&
        other.northeast == northeast;
  }

  @override
  int get hashCode => Object.hash(southwest, northeast);
}
