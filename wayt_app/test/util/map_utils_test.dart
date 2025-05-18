import 'package:flutter_test/flutter_test.dart';
import 'package:wayt_app/repositories/repositories.dart';
import 'package:wayt_app/util/util.dart';

void main() {
  group('GeoUtils.computeLatLngBounds', () {
    test('should compute the bounds for an empty input', () {
      final bounds = GeoUtils.computeLatLngBounds([]);
      expect(bounds.northeast, const LatLng(90, 180));
      expect(bounds.southwest, const LatLng(-90, -180));
    });

    test('should compute the bounds for a single point', () {
      const point = LatLng(10, 20);
      final bounds = GeoUtils.computeLatLngBounds([point]);
      expect(bounds.northeast, point);
      expect(bounds.southwest, point);
    });

    test('should compute the bounds for multiple points', () {
      const points = [
        LatLng(10, 20),
        LatLng(15, 25),
        LatLng(15, 25),
        LatLng(0, 0),
        LatLng(5, 30),
        LatLng(-5, -30),
        LatLng(-50, 30),
        LatLng(5, -50),
      ];
      final bounds = GeoUtils.computeLatLngBounds(points);
      expect(bounds.northeast.latitude, 15);
      expect(bounds.northeast.longitude, 30);
      expect(bounds.southwest.latitude, -50);
      expect(bounds.southwest.longitude, -50);
    });
  });
}
