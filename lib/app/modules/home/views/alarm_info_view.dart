import 'package:flutter/material.dart';
import 'package:flutter_alarm_v1/app/modules/home/controllers/home_controller.dart';
import 'package:flutter_alarm_v1/app/widgets/my_alarm_info_chart_widget.dart';

import 'package:get/get.dart';

class AlarmInfoView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      initState: (_) {},
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Alarm Info'),
            centerTitle: true,
          ),
          body: Container(
            margin: EdgeInsets.symmetric(vertical: 12.0),
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                Stack(
                  children: [
                    Text(
                      controller.myAlarmInfoList.length > 0 ? "delay (ms)" : "",
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.black38,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 32.0),
                      constraints: BoxConstraints(
                        minHeight: 196,
                        maxWidth: Get.width,
                        maxHeight: 32,
                      ),
                      width: Get.width,
                      child: controller.myAlarmInfoList.length > 0
                          ? AlarmInfoChart(data: controller.myAlarmInfoList)
                          : Container(
                              color: Colors.black12,
                              alignment: Alignment.center,
                              child: Text("Data has been cleared."),
                            ),
                    ),
                  ],
                ),
                Container(
                  // height: 24.0,
                  margin:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                  alignment: Alignment.centerRight,
                  child: Obx(
                    () => TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          controller.myAlarmInfoList.length > 0
                              ? Colors.blue
                              : Colors.black26,
                        ),
                        elevation: MaterialStateProperty.all(2.0),
                      ),
                      onPressed: controller.myAlarmInfoList.length > 0
                          ? () => controller.onClickClearAlarmInfoList()
                          : null,
                      child: Text(
                        "Clear",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
