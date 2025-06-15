import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:wayt_app/repositories/repositories.dart';

void main() {
  group('TypographyWidgetFeatureModel', () {
    test('json serialization', () {
      final model = TypographyWidgetFeatureModel(
        id: 'test_id',
        data: 'Sample Text',
        format: TypographyFormat.material,
        textStyle: const TypographyFeatureStyle.h1(
          color: FeatureColor.blue,
          fontWeight: FontWeight.bold,
          isUnderlined: true,
        ),
      );
      final json = model.toJson();
      final fromJsonModel = TypographyWidgetFeatureModel.fromJson(json);
      expect(fromJsonModel, model);
      expect(fromJsonModel.toJson(), json);
    });
  });
}
