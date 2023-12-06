class MetricEntity {
  String name;
  String instance;
  String job;

  MetricEntity({
    required this.name,
    required this.instance,
    required this.job,
  });

  factory MetricEntity.fromJson(Map<String, dynamic> json) => MetricEntity(
        name: json['__name__'],
        instance: json['instance'],
        job: json['job'],
      );
}
