/// This extension provides methods to convert a Duration to a string.
extension WDuration on Duration {
  /// Converts the duration to a string in the format HH:MM:SS
  String toHhMmSsString() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final twoDigitMinutes = twoDigits(inMinutes.remainder(60));
    final twoDigitSeconds = twoDigits(inSeconds.remainder(60));
    return inHours != 0
        ? '${twoDigits(inHours)}:$twoDigitMinutes:$twoDigitSeconds'
        : '$twoDigitMinutes:$twoDigitSeconds';
  }

  /// Converts the duration to a string in the format HH:MM:SS,mmm
  String toHhMmSsMmmString() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final twoDigitMinutes = twoDigits(inMinutes.remainder(60));
    final twoDigitSeconds = twoDigits(inSeconds.remainder(60));
    final twoDigitMilliseconds =
        twoDigits((inMilliseconds.remainder(1000) / 10).round());
    return inHours != 0
        ? '${twoDigits(inHours)}:$twoDigitMinutes:$twoDigitSeconds,'
            '$twoDigitMilliseconds'
        : '$twoDigitMinutes:$twoDigitSeconds,$twoDigitMilliseconds';
  }
}
