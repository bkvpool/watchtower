import 'package:prometheus_analytics/domain/entities/result_entity.dart';

class DataEntity {
  String resultType;
  List<ResultEntity> result;

  DataEntity({
    required this.resultType,
    required this.result,
  });

  factory DataEntity.fromJson(Map<String, dynamic> json) => DataEntity(
        resultType: json['resultType'],
        result: json['result'].map<ResultEntity>((json) => ResultEntity.fromJson(json)).toList(),
      );
}
