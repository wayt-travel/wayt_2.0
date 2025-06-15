import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wayt_app/repositories/repositories.dart';

void main() {
  group('WidgetFolderModel', () {
    test('json serialization', () {
      final model = WidgetFolderModel(
        id: 'test_id',
        travelDocumentId: const TravelDocumentId.plan('test_travel_doc_id'),
        createdAt: DateTime(2023, 10, 1, 10, 0),
        updatedAt: DateTime(2023, 10, 1, 10, 0),
        order: 1,
        name: 'Test Folder',
        icon: WidgetFolderIcon.fromIconData(Icons.folder),
        color: FeatureColor.blue,
      );
      final json = model.toJson();
      final fromJsonModel = WidgetFolderModel.fromJson(json);
      expect(fromJsonModel, model);
      expect(fromJsonModel.toJson(), json);
    });
  });
}
