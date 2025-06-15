import 'package:flutter_test/flutter_test.dart';
import 'package:wayt_app/repositories/repositories.dart';

void main() {
  group('LatLng', () {
    test('json serialization', () {
      const model = LatLng(-5, 10.0009);
      final json = model.toJson();
      final fromJsonModel = LatLng.fromJson(json);
      expect(fromJsonModel, model);
      expect(fromJsonModel.toJson(), json);
    });
  });
}
