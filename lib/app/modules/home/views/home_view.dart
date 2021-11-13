import 'package:flutter/material.dart';
import 'package:flutter_alarm_v1/app/widgets/my_time_picker_widget.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      initState: (_) {
        controller.notificationPermission(context);
        controller.notificationListener(context);
      },
      didChangeDependencies: (_) {
        // print("didChangeDependencies");
      },
      dispose: (_) {
        // print("dispose");
      },
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Alarm'),
            centerTitle: true,
          ),
          body: Center(
            child: Obx(
              () => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MyTimePickerWidget(
                    initialTime: controller.timeOfDay.value,
                    cancelText: "STOP ALARM",
                    confirmText: "SET ALARM",
                    helpText: "My Alarm set for: ${controller.alarmDateTime.value}",
                    onSet: (timeOfDay) => controller.onClickSetAlarm(timeOfDay),
                    // onSet: (timeOfDay) => controller.onClickNotificationSimple(),
                    onCancel: () => controller.onClickCancelAlarm(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
