import 'sdk_candidate.dart';

/// A utility class that provides methods to assert conditions.
@SdkCandidate()
abstract interface class AssertionUtils {
  static void assertExactlyOneNotNull(Iterable<dynamic> iterable) {
    var found = false;
    for (final item in iterable) {
      if (!found) {
        // As long as we have not found the not null item, we continue to look
        // for it...
        found = item != null;
      } else {
        // We have already found the not null item, so all other items must be
        // null.
        assert(
          item == null,
          'There is more than one not null item in the input iterable.',
        );
      }
    }
    // Assert that we have found the not null item.
    assert(found, 'There are no not-null items in the input iterable');
  }

  static bool exactlyOneNotNull(Iterable<dynamic> iterable) {
    var found = false;
    for (final item in iterable) {
      if (!found) {
        // As long as we have not found the not null item, we continue to look
        // for it...
        found = item != null;
      } else if (item != null) {
        // We have already found the not null item... so there are more than one
        // not null items.
        return false;
      }
    }
    return found;
  }

  static bool allNull(Iterable<dynamic> iterable) =>
      iterable.fold(true, (val, el) => val && el == null);

  static bool allNotNull(Iterable<dynamic> iterable) =>
      iterable.fold(true, (val, el) => val && el != null);

  static bool allNullOrAllNotNull(Iterable<dynamic> iterable) =>
      allNull(iterable) || allNotNull(iterable);

  static void assertAllNull(Iterable<dynamic> iterable) {
    for (final it in iterable) {
      assert(it == null, '$it is not null while all elements must be null.');
    }
  }
}
