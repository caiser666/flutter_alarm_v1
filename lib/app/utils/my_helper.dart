import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyHelper {
  int createUniqueId(int maxValue) {
    Random random = new Random();
    return random.nextInt(maxValue);
  }

  Color stringToColor(String hexColor) {
    String _hexOpcaticy = "ff";
    String _hexCode = "";
    String _color = "";

    _hexCode = hexColor.replaceAll('#', '');

    if (_hexCode.length == 8) {
      _hexOpcaticy = _hexCode.substring(_hexCode.length - 2);
      _hexCode = _hexCode.substring(0, _hexCode.length - 2);
      _color = _hexOpcaticy + _hexCode;
    }
    if (_hexCode.length == 6) {
      _color = _hexOpcaticy + _hexCode;
    }

    return Color(int.parse('$_color', radix: 16));
  }

  TimeOfDay stringToTimeOfDay(String timeOfDay) {
    final format = DateFormat.jm();
    List<String> _times = timeOfDay.split(":");

    String _hour = _times[0].substring(_times[0].length - 2);
    String _minute = _times[1].substring(0, 2);
    
    TimeOfDay _timeOfDay = TimeOfDay(
      hour: int.parse(_hour),
      minute: int.parse(_minute),
    );
    return _timeOfDay;
  }
}
