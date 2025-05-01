import 'package:flutter/foundation.dart';

import '../../../util/double_ext.dart';

/// A pair of latitude and longitude coordinates, stored as degrees.
///
/// Taken from https://github.com/flutter/packages/blob/main/packages/google_maps_flutter/google_maps_flutter_platform_interface/lib/src/types/location.dart
@immutable
class LatLng {
  /// Creates a geographical location specified in degrees [latitude] and
  /// [longitude].
  ///
  /// The latitude is clamped to the inclusive interval from -90.0 to +90.0.
  ///
  /// The longitude is normalized to the half-open interval from -180.0
  /// (inclusive) to +180.0 (exclusive).
  const LatLng(double latitude, double longitude)
      : latitude =
            latitude < -90.0 ? -90.0 : (90.0 < latitude ? 90.0 : latitude),
        // Avoids normalization if possible to prevent unnecessary loss of
        // precision
        longitude = longitude >= -180 && longitude < 180
            ? longitude
            : (longitude + 180.0) % 360.0 - 180.0;

  /// The latitude in degrees between -90.0 and 90.0, both inclusive.
  final double latitude;

  /// The longitude in degrees between -180.0 (inclusive) and 180.0 (exclusive).
  final double longitude;

  /// Converts this object to something serializable in JSON.
  Object toJson() {
    return <double>[latitude, longitude];
  }

  /// Initialize a LatLng from an \[lat, lng\] array.
  static LatLng? fromJson(Object? json) {
    if (json == null) {
      return null;
    }
    assert(
      json is List && json.length == 2,
      'Invalid LatLng json. It should be a list of two doubles.',
    );
    final list = json as List<Object?>;
    return LatLng(list[0]! as double, list[1]! as double);
  }

  @override
  String toString() =>
      '${objectRuntimeType(this, 'LatLng')}($latitude, $longitude)';

  ({String lat, String lng}) _latLngToPrettyString() {
    final lat = latitude.doubleToDegrees();
    final lng = longitude.doubleToDegrees();
    final latStr =
        "${lat.degrees}° ${lat.minutes}' ${lat.seconds.toStringAsFixed(1)}\" "
        '${latitude.latCardinalPoint()}';
    final lonStr =
        "${lng.degrees}° ${lng.minutes}' ${lng.seconds.toStringAsFixed(1)}\" "
        '${longitude.lonCardinalPoint()}';
    return (lat: latStr, lng: lonStr);
  }

  /// Generates the coordinates like `40° 12' 59.1" N` from the double value.
  String toPrettyString() {
    final tokens = _latLngToPrettyString();
    return '${tokens.lat}, ${tokens.lng}';
  }

  @override
  bool operator ==(Object other) {
    return other is LatLng &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode => Object.hash(latitude, longitude);
}
