/// Extension methods for DateTime
extension A2DateTimeExtension on DateTime {
  /// Returns a new DateTime within the specified range.
  DateTime clamp(DateTime? minimumDate, DateTime? maximumDate) {
    if (minimumDate != null && isBefore(minimumDate)) {
      return minimumDate;
    }
    if (maximumDate != null && isAfter(maximumDate)) {
      return maximumDate;
    }
    return this;
  }
}
