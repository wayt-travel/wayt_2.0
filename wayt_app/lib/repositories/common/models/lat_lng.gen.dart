import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../util/sdk/double_ext.dart';

part 'lat_lng.gen.g.dart';

/// A pair of latitude and longitude coordinates, stored as degrees.
///
/// Taken from https://github.com/flutter/packages/blob/main/packages/google_maps_flutter/google_maps_flutter_platform_interface/lib/src/types/location.dart
@immutable
@JsonSerializable()
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

  /// Creates a LatLng from a JSON object.
  factory LatLng.fromJson(Map<String, dynamic> json) => _$LatLngFromJson(json);

  /// Serializes this instance to a JSON map.
  Map<String, dynamic> toJson() => _$LatLngToJson(this);

  /// The latitude in degrees between -90.0 and 90.0, both inclusive.
  final double latitude;

  /// The longitude in degrees between -180.0 (inclusive) and 180.0 (exclusive).
  final double longitude;

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
