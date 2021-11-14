import 'package:flutter/material.dart';
import 'package:flutter_alarm_v1/app/constants.dart';
import 'package:flutter_alarm_v1/app/models/alarm_info_model.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class AlarmInfoChart extends StatelessWidget {
  final List<AlarmInfoModel> data;

  AlarmInfoChart({required this.data});
  @override
  Widget build(BuildContext context) {
    List<charts.Series<AlarmInfoModel, String>> series = [
      charts.Series(
        id: kAlarmInfoChartId,
        data: data,
        domainFn: (AlarmInfoModel series, _) => series.alarm,
        measureFn: (AlarmInfoModel series, _) => series.interval,
        colorFn: (AlarmInfoModel series, _) => series.barColor,
        labelAccessorFn: (AlarmInfoModel series, _) => "${(series.interval * 0.001).toStringAsFixed(1)} s"
      )
    ];

    return charts.BarChart(
      series,
      animate: true,
      animationDuration: Duration(milliseconds: 4),
      behaviors: [
        new charts.SlidingViewport(),
        new charts.PanAndZoomBehavior(),
      ],
      barRendererDecorator: new charts.BarLabelDecorator<String>(),
      domainAxis: new charts.OrdinalAxisSpec(
        viewport: new charts.OrdinalViewport(data[data.length-1].alarm, 8),
        renderSpec: charts.SmallTickRendererSpec(
          // Rotation Here,
          minimumPaddingBetweenLabelsPx: 0,
          labelRotation: -45,
          labelOffsetFromTickPx: -32,
          labelAnchor: charts.TickLabelAnchor.before,
          labelStyle: charts.TextStyleSpec(
            // color: charts.Color(r: 255, g: 0, b: 255),
            fontSize: 10,
          ),
          lineStyle: new charts.LineStyleSpec(
            color: charts.MaterialPalette.black,
          ),
        ),
      ),
      primaryMeasureAxis: new charts.NumericAxisSpec(
        renderSpec: new charts.GridlineRendererSpec(
          labelAnchor: charts.TickLabelAnchor.before,
          labelJustification: charts.TickLabelJustification.outside,
        ),
      ),
    );
  }
}

