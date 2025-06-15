import 'package:flutter_test/flutter_test.dart';
import 'package:wayt_app/repositories/repositories.dart';

void main() {
  group('TravelDocumentId', () {
    test('json serialization', () {
      const model1 = TravelDocumentId.journal('journalId');
      final json1 = model1.toJson();
      final fromJsonModel1 = TravelDocumentId.fromJson(json1);
      expect(fromJsonModel1, model1);
      expect(fromJsonModel1.toJson(), json1);

      const model2 = TravelDocumentId.plan('planId');
      final json2 = model2.toJson();
      final fromJsonModel2 = TravelDocumentId.fromJson(json2);
      expect(fromJsonModel2, model2);
      expect(fromJsonModel2.toJson(), json2);
    });
  });
}
