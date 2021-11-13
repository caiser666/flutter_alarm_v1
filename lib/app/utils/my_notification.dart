import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_alarm_v1/app/constants.dart';

void initNotifications() {
  AwesomeNotifications().initialize(
    "resource://drawable/res_app_icon",
    [
      NotificationChannel(
        channelKey: kAlarmChannelKey,
        channelName: "Alarm Notifications",
        channelDescription: "my alarm notificaitons",
        importance: NotificationImportance.High,
        channelShowBadge: true,
        defaultColor: kNotifDefaultColor,
        ledColor: kNotifLedColor,
        playSound: true,
        soundSource: 'resource://raw/res_morph_power_rangers',
        vibrationPattern: lowVibrationPattern,
      ),
    ],
  );
}
