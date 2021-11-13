import 'dart:convert';
import 'dart:io';
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alarm_v1/app/constants.dart';
import 'package:flutter_alarm_v1/app/models/alarm_info_model.dart';
import 'package:flutter_alarm_v1/app/models/notification_model.dart';
import 'package:flutter_alarm_v1/app/routes/app_pages.dart';
import 'package:flutter_alarm_v1/app/utils/my_helper.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    String _alarmInfoList = localStorage.read(kAlarmInfoChartId) ?? "";

    if (_alarmInfoList != "") {
      try {
        myAlarmInfoList.value = alarmInfoListFromJson(_alarmInfoList);
        update();
      } catch (e) {
        print(e);
      }
    }

    // localStorage.remove(kAlarmInfoChartId);
    super.onReady();
  }

  @override
  Future<void> dispose() async {
    AwesomeNotifications().actionSink.close();
    AwesomeNotifications().createdSink.close();
    super.dispose();
  }

  @override
  void onClose() {}

  final Stopwatch stopwatch = Stopwatch();
  final localStorage = GetStorage();

  Future<void> notificationPermission(BuildContext context) async {
    // print("notificationPermission");
    await AwesomeNotifications().isNotificationAllowed().then((isAllwoed) {
      if (!isAllwoed) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Allow Notifications!!!"),
            content: Text("Our App would like to send you notificaitons"),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  "Don\'t Allow",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16.0,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => AwesomeNotifications()
                    .requestPermissionToSendNotifications()
                    .then((_) => Get.back()),
                child: Text(
                  "Allow",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16.0,
                  ),
                ),
              )
            ],
          ),
        );
      } else {
        // notificationListener(context);
        isInit.value = true;
      }
    });
  }

  RxBool isInit = false.obs;
  RxList<AlarmInfoModel> myAlarmInfoList = <AlarmInfoModel>[].obs;

  void notificationListener(BuildContext context) {
    AwesomeNotifications().createdStream.listen((event) {
      // print("$event");
      if (isInit.value) {
        if (event.displayedDate == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green.shade600,
              content: Text("Successfully set alarm at ${event.body}"),
            ),
          );
        } else {
          stopwatch.reset();
          stopwatch.start();
        }
      }
    });

    AwesomeNotifications().actionStream.listen((event) async {
      // print("actionStream: $event");

      if (isInit.value) {
        if (event.channelKey == kAlarmChannelKey) {
          if (Platform.isIOS) {
            AwesomeNotifications().getGlobalBadgeCounter().then(
                  (value) =>
                      AwesomeNotifications().setGlobalBadgeCounter(value - 1),
                );
          }

          Map<String, String>? _payload = event.payload;

          late NotificationModel _notif;
          String _alarm = event.body ?? "";

          if (_payload != null) {
            String _value = _payload["notif"] ?? "";

            if (_value != "" && _value != "null") {
              _notif = new NotificationModel.fromJson(jsonDecode(_value));
              String _time =
                  "${_notif.timeOfDay.hour}:${_notif.timeOfDay.minute}:00";
              String _timeFormat =
                  DateFormat.jm().format(DateFormat("hh:mm:ss").parse(_time));
              _alarm = "${kDayNames[_notif.dayOfTheWeek - 1]}, $_timeFormat";
            }
          }

          AlarmInfoModel _alarmInfoModel = new AlarmInfoModel(
            alarm: _alarm,
            interval: stopwatch.elapsedMilliseconds,
            barColor: charts.ColorUtil.fromDartColor(Colors.green),
          );

          await onClickCancelAlarm();

          myAlarmInfoList.add(_alarmInfoModel);
          String _alarmInfoList = alarmInfoListToJson(myAlarmInfoList);

          // print(_alarmInfoList);
          localStorage.write(kAlarmInfoChartId, _alarmInfoList);

          Get.offNamedUntil(Routes.ALARM_INFO, (route) => route.isFirst);

          stopwatch.stop();
          stopwatch.reset();
        }
      }
    });
  }

  Future<void> onClickNotificationSimple() async {
    // print("onClickNotification");
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: MyHelper().createUniqueId(10),
        channelKey: kAlarmChannelKey,
        title: "Title",
        body: "body",
        payload: {"notif": "hello"},
        notificationLayout: NotificationLayout.Default,
      ),
    );

    // AlarmInfoModel _alarmInfoModel = new AlarmInfoModel(
    //   alarm: "test 1234",
    //   interval: 1000,
    //   barColor: charts.ColorUtil.fromDartColor(Colors.green),
    // );

    // await onClickCancelAlarm();

    // myAlarmInfoList.add(_alarmInfoModel);
    // String _alarmInfoList = alarmInfoListToJson(myAlarmInfoList);

    // localStorage.write(kAlarmInfoChartId, _alarmInfoList);
  }

  Future<void> onClickSetAlarm(TimeOfDay timeOfDay) async {
    NotificationModel? _notif = await pickAlarm(timeOfDay);
    try {
      if (_notif != null) setNotificationAlarm(_notif);
    } catch (e) {
      print(e);
    }
  }

  Future<void> setNotificationAlarm(NotificationModel notif) async {
    String _notif = jsonEncode(notif.toJson());

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: MyHelper().createUniqueId(10),
        channelKey: kAlarmChannelKey,
        payload: {"notif": _notif},
        title: "My Alarm",
        body: alarmDateTime.value,
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar(
        weekday: notif.dayOfTheWeek,
        hour: notif.timeOfDay.hour,
        minute: notif.timeOfDay.minute,
        second: 0,
        millisecond: 0,
        repeats: true,
      ),
    );
    // print("onClickNotificationAlarm: ${notif.dayOfTheWeek}");
  }

  RxString alarmDateTime = "".obs;
  Rx<TimeOfDay> timeOfDay = TimeOfDay.now().obs;

  Future<NotificationModel?> pickAlarm(TimeOfDay timeOfDay) async {
    int dayOfTheWeek = 0;
    NotificationModel? _notif;

    DateTime _currentDateTime = DateTime.now();
    TimeOfDay _timeOfDay = timeOfDay;

    dayOfTheWeek = _currentDateTime.weekday;

    String _time = "${_timeOfDay.hour}:${_timeOfDay.minute}:00";
    String _timeFormat =
        DateFormat.jm().format(DateFormat("hh:mm:ss").parse(_time));

    alarmDateTime.value = "${kDayNames[dayOfTheWeek - 1]}, $_timeFormat";

    _notif = NotificationModel(
        dayOfTheWeek: dayOfTheWeek,
        timeOfDay: _timeOfDay,
        dateTime: _currentDateTime);

    return _notif;
  }

  Future<void> onClickCancelAlarm() async {
    await AwesomeNotifications().cancelAllSchedules();
    alarmDateTime.value = "";
    timeOfDay.value = TimeOfDay.now();
  }

  Future<void> onClickClearAlarmInfoList() async {
    myAlarmInfoList.clear();
    localStorage.remove(kAlarmInfoChartId);
    await onClickCancelAlarm();
    update();
  }
}
