import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:prometheus_analytics/core/extensions/date_time_extensions.dart';
import 'package:prometheus_analytics/core/extensions/int_extensions.dart';
import 'package:prometheus_analytics/domain/entities/result_entity.dart';
import 'package:prometheus_analytics/presentation/graphics/bloc/graphics_store.dart';
import 'package:prometheus_analytics/presentation/graphics/components/graphics_drawer.dart';

class GraphicsScreen extends StatefulWidget {
  const GraphicsScreen({super.key});

  @override
  State<GraphicsScreen> createState() => _GraphicsScreenState();
}

class _GraphicsScreenState extends State<GraphicsScreen> {
  final _store = GraphicsStore();
  final _dateFormatter = DateFormat('HH:mm:ss');
  final _colors = {
    0: Colors.green,
    1: Colors.amber,
    2: Colors.blue,
  };

  @override
  void initState() {
    super.initState();
    _store.updateData();
  }

  @override
  void dispose() {
    _store.onDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Stake Pool Metrics'),
        actions: const [],
      ),
      drawer: GraphicsDrawer(store: _store,),
      body: Builder(
        builder: (context) {
          return ListView(
            padding: const EdgeInsets.all(8.0),
            children: [
              Observer(
                builder: (_) => _buildGraphic(
                  title: 'blockfetchclient_blockdelay_s',
                  resultsList: _store.blockFetchClientBlockDelaySResults,
                ),
              ),
              const Divider(),
              Observer(
                builder: (_) => _buildGraphic(
                  title: 'blockfetchclient_blocksize',
                  resultsList: _store.blockFetchClientBlockSizeResults,
                ),
              ),
              const Divider(),
              Observer(
                builder: (_) => _buildGraphic(
                  title: 'density_real',
                  resultsList: _store.densityRealResults,
                  maxYCoafficient: 1.0025,
                  minYCoafficient: .9975,
                ),
              ),
              const Divider(),
              Observer(
                builder: (_) => _buildGraphic(
                  title: 'blockfetchclient_blockdelay_cdfOne',
                  resultsList: _store.blockFetchClientBlockDelayCDFOneResults,
                  maxYCoafficient: 1.0025,
                  minYCoafficient: .9975,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGraphic({
    required String title,
    required List<ResultEntity>? resultsList,
    double maxYCoafficient = 1.1,
    double minYCoafficient = .9,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Metric: $title'),
            SizedBox(
              height: 300.0,
              child: Builder(
                builder: (_) {
                  if (resultsList == null) return const Align(child: CircularProgressIndicator());

                  final transformed = _transformToLineBarsData(resultsList);
                  return LineChart(
                    LineChartData(
                      lineBarsData: transformed.$1,
                      maxY: transformed.$2 * maxYCoafficient,
                      minY: (transformed.$3 ?? 0) * minYCoafficient,
                      clipData: const FlClipData.all(),
                      gridData: const FlGridData(show: false),
                      titlesData: FlTitlesData(
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 60,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              final date = value.toInt().toUnixTime;
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                child: RotatedBox(
                                  quarterTurns: 3,
                                  child: Text(
                                    _dateFormatter.format(date),
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        leftTitles: const AxisTitles(),
                        rightTitles: const AxisTitles(),
                        bottomTitles: const AxisTitles(),
                      ),
                    ),
                    duration: Durations.long2,
                    curve: Curves.easeInOutCubic,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  (List<LineChartBarData>, double, double?) _transformToLineBarsData(List<ResultEntity> resultsList) {
    final lineBarsData = <LineChartBarData>[];
    double? minY;
    double maxY = .0;

    for (int i = 0; i < resultsList.length; i++) {
      final result = resultsList[i];
      result.values.map((e) => LineChartBarData());
      lineBarsData.add(
        LineChartBarData(
          spots: result.values.map((e) {
            minY = minY == null ? e.value : min(minY!, e.value);
            maxY = max(maxY, e.value);
            return FlSpot(e.dateTime.unixTime.toDouble(), e.value);
          }).toList(),
          color: _colors[i],
          isCurved: true,
          isStepLineChart: true,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(),
        ),
      );
    }
    return (lineBarsData, maxY, minY);
  }
}
