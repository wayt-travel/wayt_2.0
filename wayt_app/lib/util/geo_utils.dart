import '../repositories/repositories.dart';

/// A utility class for geographical calculations.
abstract class GeoUtils {
  /// Computes the [LatLngBounds] from a list of [LatLng] coordinates.
  ///
  /// The bounds are set in order to include all the coordinates in a rectangle.
  ///
  /// If the [coords] list is empty the maximum bounds are returned.
  ///
  /// If the [coords] list contains only one element, the resulting bounds will
  /// be on the same [LatLng] coordinates.
  static LatLngBounds computeLatLngBounds(Iterable<LatLng> coords) {
    if (coords.isEmpty) {
      return LatLngBounds(
        northeast: const LatLng(90, 180),
        southwest: const LatLng(-90, -180),
      );
    }
    var minLat = 90.0;
    var maxLat = -90.0;
    var minLon = 180.0;
    var maxLon = -180.0;

    for (final p in coords) {
      final lon = p.longitude;
      final lat = p.latitude;
      if (lon > maxLon) {
        maxLon = lon;
      }
      if (lon < minLon) {
        minLon = lon;
      }
      if (lat > maxLat) {
        maxLat = lat;
      }
      if (lat < minLat) {
        minLat = lat;
      }
    }
    return LatLngBounds(
      northeast: LatLng(maxLat, maxLon),
      southwest: LatLng(minLat, minLon),
    );
  }

  /// Computes the middle point of [LatLngBounds].
  static LatLng computeMiddleLatLngOfBounds(LatLngBounds bounds) {
    return computeMiddleLatLngOf2Points(bounds.northeast, bounds.southwest);
  }

  /// Computes the middle point between two coordinates.
  static LatLng computeMiddleLatLngOf2Points(LatLng x, LatLng y) {
    return LatLng(
      (x.latitude + y.latitude) / 2,
      (x.longitude + y.longitude) / 2,
    );
  }

  /// Computes the bounds of a list of [LatLng] coordinates.
  static ({LatLng center, LatLngBounds? bounds}) computeBounds(
    Iterable<LatLng> coords,
  ) {
    LatLngBounds? latLngBounds;
    var latLng = const LatLng(0, 0);
    if (coords.length > 1) {
      // If there are more than one notes to render, then we try to compute the
      // moment bounds.
      latLngBounds = computeLatLngBounds(coords);
      if (latLngBounds.northeast == latLngBounds.southwest) {
        // If somehow the bounds are on the same points, we do not want
        // to use bounds (it will be weird), but we use this coordinate as a
        // center for the map screen that we are going to build.
        latLng = latLngBounds.northeast;
        latLngBounds = null;
      } else {
        // Otherwise we compute the middle point to center the camera there.
        latLng = computeMiddleLatLngOfBounds(latLngBounds);
      }
    } else if (coords.isNotEmpty) {
      // There is only one note: we do not use bounds (i.e., latLngBounds will
      // be null).
      latLng = coords.last;
    }
    return (center: latLng, bounds: latLngBounds);
  }

  /// Given a list of [LatLng] it computes the average value.
  static LatLng computeAvgLatLng(List<LatLng> coords) {
    if (coords.isEmpty) return const LatLng(0, 0);
    if (coords.length == 1) return coords.first;
    final lat = coords.fold<double>(
          0,
          (previousValue, element) => previousValue + element.latitude,
        ) /
        coords.length;
    final lng = coords.fold<double>(
          0,
          (previousValue, element) => previousValue + element.longitude,
        ) /
        coords.length;
    return LatLng(lat, lng);
  }
}
