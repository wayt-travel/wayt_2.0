import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../../repositories/repositories.dart';

/// Extension on [LatLng] to convert it to a [Point].
extension LatLngToPoint on LatLng {
  /// Converts a [LatLng] to a [Point].
  Point toPoint() => Point(
        coordinates: Position(longitude, latitude),
      );
}

/// Extension on [Point] to convert it to a [LatLng].
extension PointToLatLng on Point {
  /// Converts a [Point] to a [LatLng].
  LatLng toLatLng() => LatLng(
        coordinates.lat.toDouble(),
        coordinates.lng.toDouble(),
      );
}
