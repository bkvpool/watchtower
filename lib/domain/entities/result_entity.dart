import 'package:prometheus_analytics/domain/entities/metrics_entity.dart';
import 'package:prometheus_analytics/domain/entities/value_entity.dart';

class ResultEntity {
  MetricEntity metric;
  List<ValueEntity> values;

  ResultEntity({
    required this.metric,
    required this.values,
  });

  factory ResultEntity.fromJson(Map<String, dynamic> json) => ResultEntity(
        metric: MetricEntity.fromJson(json['metric']),
        values: json['values'].map<ValueEntity>((json) => ValueEntity.fromJson(json)).toList(),
      );
}
