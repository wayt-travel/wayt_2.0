import 'package:flutter_test/flutter_test.dart';
import 'package:wayt_app/repositories/repositories.dart';

void main() {
  group('LatLngBounds', () {
    test('json serialization', () {
      final model = LatLngBounds(
        southwest: const LatLng(-5, -10.0009),
        northeast: const LatLng(5, 10.0009),
      );
      final json = model.toJson();
      final fromJsonModel = LatLngBounds.fromJson(json);
      expect(fromJsonModel, model);
      expect(fromJsonModel.toJson(), json);
    });
  });
}
