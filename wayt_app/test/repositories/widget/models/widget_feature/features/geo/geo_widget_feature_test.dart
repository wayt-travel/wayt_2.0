import 'package:flutter_test/flutter_test.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:wayt_app/repositories/repositories.dart';

void main() {
  group('GeoWidgetFeatureModel', () {
    test('json serialization', () {
      final model = GeoWidgetFeatureModel(
        id: 'test_id',
        latLng: const LatLng(37.7749, -122.4194),
        timestamp: DateTime(2023, 10, 1, 10, 0),
        name: 'San Francisco',
        address: '1 Market St, San Francisco, CA 94105',
        version: Version(1, 0, 0),
      );
      final json = model.toJson();
      final fromJsonModel = GeoWidgetFeatureModel.fromJson(json);
      expect(fromJsonModel, model);
      expect(fromJsonModel.toJson(), json);
    });
  });
}
