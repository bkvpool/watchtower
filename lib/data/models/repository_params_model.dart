import 'package:prometheus_analytics/core/extensions/date_time_extensions.dart';

final class RepositoryParamsModel {
  final String baseUrl;
  final String metric;
  final DateTime from;
  final DateTime to;
  final int step;

  const RepositoryParamsModel({
    required this.baseUrl,
    required this.metric,
    required this.from,
    required this.to,
    required this.step,
  });

  Map<String, dynamic> toJson() => {
        'query': metric,
        'start': from.unixTime,
        'end': to.unixTime,
        'step': step,
      };
}
