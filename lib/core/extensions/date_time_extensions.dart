extension DateTimeUnixTimeExtention on DateTime {
  int get unixTime => (millisecondsSinceEpoch / Duration.millisecondsPerSecond).round();
}
