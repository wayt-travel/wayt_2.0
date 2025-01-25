import 'package:flext/flext.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';
import 'package:wayt_app/init/init.dart';
import 'package:wayt_app/repositories/repositories.dart';

void main() {
  late InMemoryDataHelper dataHelper;
  late InMemoryWidgetDataSource dataSource;
  late TravelDocumentId travelDocumentId;

  WidgetModel buildWidget({
    String? id,
    int order = -1,
    TravelDocumentId? travelDocumentId,
  }) {
    return TextWidgetModel(
      id: id ?? const Uuid().v4(),
      travelDocumentId: travelDocumentId ??
          TravelDocumentId.plan(dataHelper.sortedPlans.first.id),
      order: order,
      text: 'text',
      textStyle: const FeatureTextStyle.body(),
    );
  }

  List<TravelItemModel> getTravelItems() => dataHelper
      .getTravelDocumentWrapper(travelDocumentId)
      .rootTravelItems
      .cast<TravelItemModel>();

  void addWidgets(int count) {
    final widgetCount = getTravelItems().length;
    dataHelper.saveTravelItems([
      for (var i = 0; i < count; i++) buildWidget(order: widgetCount + i),
    ]);
  }

  void expectOrdered([Map<String, int> updatedOrders = const {}]) {
    // The order of the widgets in the cache is updated.
    for (final order in updatedOrders.entries) {
      expect(dataHelper.getTravelItem(order.key).order, order.value);
    }
    final items = getTravelItems();
    for (var i = 0; i < items.length; i++) {
      expect(items[i].order, i);
    }
  }

  setUp(() {
    dataHelper = InMemoryDataHelper();
    travelDocumentId = dataHelper.sortedPlans.first.tid;
    dataSource = InMemoryWidgetDataSource(dataHelper);
  });

  group('InMemoryWidgetDataSource.create', () {
    test('should throw if the travel document does not exist', () {
      expect(
        () => dataSource.create(
          buildWidget(
            travelDocumentId: TravelDocumentId.plan(const Uuid().v4()),
          ),
          index: 0,
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should throw if index is out of bounds [0, length]', () {
      expect(
        () => dataSource.create(buildWidget(), index: -1),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => dataSource.create(
          buildWidget(),
          index: getTravelItems().length + 1,
        ),
        throwsA(isA<ArgumentError>()),
      );
      addWidgets(3);
      expect(
        () => dataSource.create(
          buildWidget(),
          index: getTravelItems().length + 1,
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should add a widget at the end if index=null', () async {
      addWidgets(3);
      final widget = buildWidget();
      final (widget: created, :updatedOrders) = await dataSource.create(widget);
      // The order of the widget model stays the same.
      expect(widget.order, -1);
      expect(created.order, getTravelItems().length - 1);
      expect(created, getTravelItems().last);
      // No order to update if the widget is added at the end.
      expect(updatedOrders, isEmpty);
    });

    test('should add a widget a the end if index=length', () async {
      addWidgets(3);
      final widget = buildWidget();
      final (widget: created, :updatedOrders) =
          await dataSource.create(widget, index: getTravelItems().length);
      // The order of the widget model stays the same.
      expect(widget.order, -1);
      expect(created.order, getTravelItems().length - 1);
      expect(created, getTravelItems().last);
      // No order to update if the widget is added at the end.
      expect(updatedOrders, isEmpty);
      expectOrdered();
    });

    test(
      'should add a widget at the beginning and update all other '
      "widgets' orders if index=0",
      () async {
        addWidgets(3);
        final widget = buildWidget();
        final (widget: created, :updatedOrders) = await dataSource.create(
          widget,
          index: 0,
        );
        // The order of the widget model stays the same.
        expect(widget.order, -1);
        expect(created.order, 0);
        expect(created, getTravelItems().first);
        // All other widgets' orders are updated.
        expectOrdered(updatedOrders);
      },
    );

    test(
      'should add a widget inside the list and update only the orders of '
      'items positioned after the new widget',
      () async {
        const index = 5;
        addWidgets(10);
        final widget = buildWidget();
        final itemsBefore = getTravelItems();
        final (widget: created, :updatedOrders) = await dataSource.create(
          widget,
          index: index,
        );
        final itemsAfter = getTravelItems();
        expect(itemsAfter, hasLength(itemsBefore.length + 1));
        // The order of the widget model stays the same.
        expect(widget.order, -1);
        expect(created.order, index);
        expect(created, itemsAfter[index]);
        // Only the orders of the widgets after the new widget are updated.
        expectOrdered(updatedOrders);

        for (var i = 0; i < itemsAfter.length; i++) {
          if (i < index) {
            final before = itemsBefore[i];
            final after = itemsAfter[i];
            // All items before the new widget stay the same.
            expect(after, before);
          } else if (i == index) {
            final after = itemsAfter[i];
            // The new widget is added at the specified index.
            expect(after, created);
          } else {
            final before = itemsBefore[i - 1];
            final after = itemsAfter[i];
            // All items after the new widget are the same as before but with
            // updated order (newOrder = previousOrder + 1)
            expect(
              after,
              before.let(
                (item) => item.copyWith(order: item.order + 1),
              ),
            );
          }
        }
      },
    );
  });
}
