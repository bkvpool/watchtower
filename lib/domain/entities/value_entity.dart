import 'package:prometheus_analytics/core/extensions/int_extensions.dart';

class ValueEntity {
  DateTime dateTime;
  double value;

  ValueEntity({
    required this.dateTime,
    required this.value,
  });

  factory ValueEntity.fromJson(List<dynamic> json) => ValueEntity(
        dateTime:(json[0] as int).toUnixTime,
        value: double.parse(json[1]),
      );
}
