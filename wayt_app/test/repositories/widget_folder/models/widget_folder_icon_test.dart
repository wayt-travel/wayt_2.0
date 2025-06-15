import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wayt_app/repositories/repositories.dart';

void main() {
  group('WidgetFolderIcon', () {
    test('json serialization', () {
      final model = WidgetFolderIcon.fromIconData(Icons.home);
      final json = model.toJson();
      final fromJsonModel = WidgetFolderIcon.fromJson(json);
      expect(fromJsonModel, model);
      expect(fromJsonModel.toJson(), json);
    });
  });
}
