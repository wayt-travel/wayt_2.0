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
  final map = <String, _Item>{};
  late Map<String, _Item> orderedMap;

  setUp(() {
    for (final i in List.generate(10, (i) => i)) {
      final item = _Item(const Uuid().v4(), i);
      map[item.id] = item;
    }
    orderedMap =
        SplayTreeMap((k1, k2) => map[k1]!.order.compareTo(map[k2]!.order))
          ..addAll(map);
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

    test('update method updates the order', () {
      final item = map.values.first;
      final updatedItem = item.copyWith(order: 100);
      map[item.id] = updatedItem;
      orderedMap.update(updatedItem.id, (value) => updatedItem);
      expectSorted();
    });
  });
}
