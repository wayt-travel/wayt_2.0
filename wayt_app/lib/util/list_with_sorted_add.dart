import 'package:flext/flext.dart';

/// An implementation of a List that maintains its elements sorted when
/// adding elements to it via the [add] or [addAll] methods.
class ListWithSortedAdd<T> extends DelegatingList<T> {
  late final int Function(T a, T b) _compareFunction;

  ListWithSortedAdd(this._compareFunction) : super([]);

  /// Creates a new instance of [ListWithSortedAdd] that sorts its elements
  /// comparing fields returned by the [getField] function.
  ListWithSortedAdd.by(Comparable<dynamic> Function(T a) getField) : super([]) {
    _compareFunction = (a, b) => getField(a).compareTo(getField(b));
  }

  @override
  void add(T value) {
    if (isEmpty) {
      super.add(value);
      return;
    }
    for (var i = 0; i < length; i++) {
      // Insert the element before the first element that is greater than it
      // by the comparison function.
      if (_compareFunction(value, this[i]) < 0) {
        super.insert(i, value);
        return;
      }
    }
    // otherwise, the element is added at the end of the list.
    super.add(value);
  }

  @override
  void addAll(Iterable<T> iterable) {
    super.addAll(iterable);
    super.sort(_compareFunction);
  }
}
