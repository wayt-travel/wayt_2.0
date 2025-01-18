import 'dart:math';

import 'package:flext/flext.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wayt_app/util/util.dart';

class _Item implements Comparable<_Item> {
  final int i1;
  final int i2;

  _Item(this.i1, this.i2);

  @override
  int compareTo(_Item other) {
    if (i1 != other.i1) {
      return i1.compareTo(other.i1);
    }
    return i2.compareTo(other.i2);
  }
}

void main() {
  group('ListWithSortedAdd', () {
    test('should add the element maintaining the correct order', () {
      final list = ListWithSortedAdd<int>((a, b) => a.compareTo(b))..add(0);
      expect(listEquals(list, [0]), isTrue);

      list.add(2);
      expect(listEquals(list, [0, 2]), isTrue);

      list.add(-1);
      expect(listEquals(list, [-1, 0, 2]), isTrue);

      list.add(0);
      expect(listEquals(list, [-1, 0, 0, 2]), isTrue);

      list.add(1);
      expect(listEquals(list, [-1, 0, 0, 1, 2]), isTrue);
    });

    test('should add the element maintaining the correct order (by)', () {
      // Order by i2. i1 should be neglected.
      final list = ListWithSortedAdd<_Item>.by((item) => item.i2);
      final isSorted = list.isSortedBy<num>((item) => item.i2);
      final rnd = Random();
      final addItem = (int i2) => list.add(_Item(rnd.nextInt(1000) - 500, i2));
      final addAllItems = (List<int> values) => list.addAll(
            values.map(
              (i2) => _Item(
                rnd.nextInt(1000) - 500,
                i2,
              ),
            ),
          );

      addItem(0);
      expect(isSorted, isTrue);

      addItem(2);
      expect(isSorted, isTrue);

      addItem(-1);
      expect(isSorted, isTrue);

      addItem(0);
      expect(isSorted, isTrue);

      addItem(1);
      expect(isSorted, isTrue);

      addAllItems(List.generate(100, (_) => rnd.nextInt(1000) - 500));
      expect(isSorted, isTrue);

      addAllItems(List.generate(100, (_) => rnd.nextInt(1000) - 500));
      expect(isSorted, isTrue);
    });
  });
}
