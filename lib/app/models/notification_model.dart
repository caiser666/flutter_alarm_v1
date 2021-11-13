import 'package:flutter/material.dart';
import 'package:flutter_alarm_v1/app/utils/my_helper.dart';

class NotificationModel {
  final int dayOfTheWeek;
  final DateTime dateTime;
  final TimeOfDay timeOfDay;

  NotificationModel({
    required this.dayOfTheWeek,
    required this.timeOfDay,
    required this.dateTime,
  });

  Map<String, dynamic> toJson() => {
        'dayOfTheWeek': dayOfTheWeek,
        'timeOfDay': timeOfDay.toString(),
        'dateTime': dateTime.toIso8601String(),
      };

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        dayOfTheWeek: json['dayOfTheWeek'],
        timeOfDay: MyHelper().stringToTimeOfDay(json['timeOfDay']),
        dateTime: DateTime.parse(json['dateTime']),
      );
}
