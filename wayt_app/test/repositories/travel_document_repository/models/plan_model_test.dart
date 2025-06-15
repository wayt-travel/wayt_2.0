import 'package:flutter_test/flutter_test.dart';
import 'package:wayt_app/init/init.dart';
import 'package:wayt_app/repositories/repositories.dart';

void main() {
  late InMemoryDataHelper inMemoryData;
  setUp(() {
    inMemoryData = InMemoryDataHelper();
  });
  group('PlanModel', () {
    test('json serialization', () {
      final model = inMemoryData.sortedPlans.first;
      final json = model.toJson();
      final fromJsonModel = PlanModel.fromJson(json);
      expect(fromJsonModel, model);
      expect(fromJsonModel.toJson(), json);
    });
  });
}
