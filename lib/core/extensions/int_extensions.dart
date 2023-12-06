extension IntUnixTimeExtention on int {
  DateTime get toUnixTime => DateTime.fromMillisecondsSinceEpoch(this * Duration.millisecondsPerSecond, isUtc: true);
}
