import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:prometheus_analytics/core/consts/cardano_node_metrics.dart';
import 'package:prometheus_analytics/core/environment.dart';
import 'package:prometheus_analytics/data/models/repository_params_model.dart';
import 'package:prometheus_analytics/data/repository/repository.dart';
import 'package:prometheus_analytics/domain/entities/result_entity.dart';

part 'graphics_store.g.dart';

class GraphicsStore extends _GraphicsStore with _$GraphicsStore {}

abstract class _GraphicsStore with Store {
  final _repository = Repository();

  Timer? _timer;

  @observable
  int updatePauseInSeconds = 15;

  @observable
  String baseUrl = Environment.defaultBaseUrl;

  @readonly
  List<ResultEntity>? _blockFetchClientBlockDelaySResults;
  @readonly
  List<ResultEntity>? _densityRealResults;
  @readonly
  List<ResultEntity>? _blockFetchClientBlockSizeResults;
  @readonly
  List<ResultEntity>? _blockFetchClientBlockDelayCDFOneResults;

  void onDispose() => _timer?.cancel();

  void _setTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: updatePauseInSeconds), (_) => updateData());
  }

  @action
  Future<void> updateData() async {
    final to = DateTime.now();

    final futures = [
      _fetchData(
        metric: CardanoNodeMetrics.blockFetchClientBlockDelayS,
        to: to,
        minutes: 3,
        step: 1,
      ),
      _fetchData(
        metric: CardanoNodeMetrics.blockFetchClientBlockSize,
        to: to,
        minutes: 3,
        step: 1,
      ),
      _fetchData(
        metric: CardanoNodeMetrics.densityReal,
        to: to,
        minutes: 3,
        step: 1,
      ),
      _fetchData(
        metric: CardanoNodeMetrics.blockFetchClientBlockDelayCDFOne,
        to: to,
        minutes: 3,
        step: 1,
      ),
    ];

    await Future.wait(futures);

    _blockFetchClientBlockDelaySResults = await futures[0];
    _blockFetchClientBlockSizeResults = await futures[1];
    _densityRealResults = await futures[2];
    _blockFetchClientBlockDelayCDFOneResults = await futures[3];

    _setTimer();
  }

  @action
  Future<List<ResultEntity>?> _fetchData({
    required String metric,
    required DateTime to,
    required int minutes,
    required int step,
  }) async {
    final from = to.subtract(Duration(minutes: minutes));
    final responseData = await _repository.fetchMetric(
      RepositoryParamsModel(
        baseUrl: baseUrl,
        metric: metric,
        from: from,
        to: to,
        step: step,
      ),
    );
    return responseData?.result;
  }
}
