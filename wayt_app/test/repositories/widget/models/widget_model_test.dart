import 'package:flext/flext.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wayt_app/init/init.dart';
import 'package:wayt_app/repositories/repositories.dart';

void main() {
  late InMemoryDataHelper dataHelper;
  setUp(() {
    dataHelper = InMemoryDataHelper();
  });

  WidgetModel? getModel(WidgetType type) =>
      dataHelper.allWidgets.firstWhereOrNull((widget) => widget.type == type)
          as WidgetModel?;

  group('WidgetModel', () {
    test('json serialization', () {
      void runModelTest(WidgetType type) {
        final model = getModel(type);
        if (model == null) return;
        final json = model.toJson();
        final fromJsonModel = WidgetModel.fromJson(json);
        expect(fromJsonModel, model);
        expect(fromJsonModel.toJson(), json);
      }

      WidgetType.values.forEach(runModelTest);
    });
  });
}
