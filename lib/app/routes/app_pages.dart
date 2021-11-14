import 'package:flutter_alarm_v1/app/modules/home/views/alarm_info_view.dart';
import 'package:flutter_alarm_v1/app/utils/my_media_query.dart';
import 'package:get/get.dart';

import 'package:flutter_alarm_v1/app/modules/home/bindings/home_binding.dart';
import 'package:flutter_alarm_v1/app/modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes. HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => MyMediaQuery(child: HomeView()),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ALARM_INFO,
      page: () => MyMediaQuery(child: AlarmInfoView()),
      binding: HomeBinding(),
    ),
  ];
}
