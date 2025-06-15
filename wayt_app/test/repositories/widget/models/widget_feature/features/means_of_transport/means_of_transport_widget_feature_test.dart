import 'package:flutter_test/flutter_test.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:wayt_app/repositories/repositories.dart';

void main() {
  group('MeansOfTransportWidgetFeatureModel', () {
    test('json serialization', () {
      final model = MeansOfTransportWidgetFeatureModel(
        id: 'test_id',
        motType: MeansOfTransportType.car,
        version: Version(1, 0, 0),
      );
      final json = model.toJson();
      final fromJsonModel = MeansOfTransportWidgetFeatureModel.fromJson(json);
      expect(fromJsonModel, model);
      expect(fromJsonModel.toJson(), json);
    });
  });
}
