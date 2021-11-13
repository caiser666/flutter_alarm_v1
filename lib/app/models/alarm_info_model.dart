import 'dart:convert';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_alarm_v1/app/utils/my_helper.dart';

class AlarmInfoModel {
  final String alarm;
  late int interval;
  final charts.Color barColor;

  AlarmInfoModel({
    required this.alarm,
    required this.interval,
    required this.barColor,
  });

  Map<String, dynamic> toJson() => {
        'alarm': alarm,
        'interval': interval,
        'barColor': barColor.toString(),
      };

  factory AlarmInfoModel.fromJson(Map<String, dynamic> json) => AlarmInfoModel(
        alarm: json["alarm"],
        interval: json["interval"],
        barColor: charts.ColorUtil.fromDartColor(
            MyHelper().stringToColor(json["barColor"].toString())),
      );
}

List<AlarmInfoModel> alarmInfoListFromJson(String value) =>
    List<AlarmInfoModel>.from(
        jsonDecode(value).map((x) => AlarmInfoModel.fromJson(x)));

String alarmInfoListToJson(List<AlarmInfoModel> data) =>
    jsonEncode(List<dynamic>.from(data.map((x) => x.toJson())));
