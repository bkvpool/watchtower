import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:prometheus_analytics/core/environment.dart';
import 'package:prometheus_analytics/data/models/repository_params_model.dart';
import 'package:prometheus_analytics/domain/entities/data_entity.dart';

final class Repository {
  final _dioClient = Dio();

  Future<DataEntity?> fetchMetric(RepositoryParamsModel params) async {
    try {
      final response = await _dioClient.post(
        '${Environment.defaultProtocol}${params.baseUrl}${Environment.defaultAPIPath}',
        queryParameters: params.toJson(),
      );
      return DataEntity.fromJson(response.data['data']);
    } on DioException catch (e) {
      debugPrint(e.toString());
    } catch (e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
    }
    return null;
  }
}
