import 'dart:collection';

import 'package:flext/flext.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

class _Item {
  final String id;
  final int order;

  _Item(this.id, this.order);

  _Item copyWith({int? order}) {
    return _Item(id, order ?? this.order);
  }
}

void main() {
  late Map<String, _Item> map;
  late Map<String, _Item> orderedMap;

  _Item addItem({String? id, int order = 0}) {
    final item = _Item(id ?? const Uuid().v4(), order);
    map[item.id] = item;
    orderedMap[item.id] = item;
    return item;
  }

  setUp(() {
    map = {};
    orderedMap = SplayTreeMap(
      (k1, k2) => map[k1]!
          .order
          .compareTo(map[k2]!.order)
          .let((r) => r == 0 ? k1.compareTo(k2) : r),
    );
    for (final i in List.generate(10, (i) => i)) {
      addItem(order: i);
    }
  });

  void expectSorted() {
    expect(
      orderedMap.values.isSortedBy<num>((a) => a.order),
      isTrue,
    );
  }

  group('SplayTreeMap', () {
    test('[] operator updates the order', () {
      final item = map.values.first;
      final updatedItem = item.copyWith(order: 100);
      map[item.id] = updatedItem;
      orderedMap[item.id] = updatedItem;
      expectSorted();
    });

    test('does not have problems in handling items with the same order', () {
      final i1 = addItem();
      final i2 = addItem();
      final i3 = addItem();
      expectSorted();
      orderedMap.remove(i1.id);
      expectSorted();
      expect(orderedMap[i1.id], isNull);
      expect(orderedMap[i2.id], i2);
      expect(orderedMap[i3.id], i3);
      orderedMap.remove(i2.id);
      expectSorted();
      expect(orderedMap[i1.id], isNull);
      expect(orderedMap[i2.id], isNull);
      expect(orderedMap[i3.id], i3);
      orderedMap.remove(i3.id);
      expectSorted();
      expect(orderedMap[i1.id], isNull);
      expect(orderedMap[i2.id], isNull);
      expect(orderedMap[i3.id], isNull);
    });
  });
}
