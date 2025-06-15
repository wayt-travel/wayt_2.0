import 'package:flutter_test/flutter_test.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:wayt_app/repositories/repositories.dart';

void main() {
  group('MediaWidgetFeatureModel', () {
    test('json serialization', () {
      final model = MediaWidgetFeatureModel(
        id: 'test_id',
        byteCount: 1024,
        mediaType: MediaFeatureType.image,
        url: 'https://example.com/image.jpg',
        mediaExtension: '.jpg',
        metadata: {
          'width': 800,
          'height': 600,
        },
        version: Version(1, 0, 0),
      );
      final json = model.toJson();
      final fromJsonModel = MediaWidgetFeatureModel.fromJson(json);
      expect(fromJsonModel, model);
      expect(fromJsonModel.toJson(), json);
    });
  });
}
