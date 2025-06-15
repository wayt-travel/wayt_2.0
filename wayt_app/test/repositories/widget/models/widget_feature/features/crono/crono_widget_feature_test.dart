import 'package:flutter_test/flutter_test.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:wayt_app/repositories/repositories.dart';

void main() {
  group('CronoWidgetFeatureModel', () {
    test('json serialization', () {
      final model = CronoWidgetFeatureModel(
        id: 'test_id',
        duration: const Duration(hours: 2, minutes: 30),
        startingAt: DateTime(2023, 10, 1, 10, 0),
        endingAt: DateTime(2023, 10, 1, 12, 30),
        version: Version(1, 0, 0),
      );
      final json = model.toJson();
      final fromJsonModel = CronoWidgetFeatureModel.fromJson(json);
      expect(fromJsonModel, model);
      expect(fromJsonModel.toJson(), json);
    });
  });
}
