import 'dart:math';

import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';

String add2StringAsDouble(String a, String b) {
  double na = double.parse(a != null ? a : 0.0);
  double nb = double.parse(b != null ? b : 0.0);
  return (na + nb).toString();
}

Offset rotateOffset({double angle, Size size}) {
  final double r =
      sqrt(size.width * size.width + size.height * size.height) / 2;
  final alpha = atan(size.height / size.width);
  final beta = alpha + angle;
  final shiftY = r * sin(beta);
  final shiftX = r * cos(beta);
  final translateX = size.width / 2 - shiftX;
  final translateY = size.height / 2 - shiftY;
  return new Offset(translateX, translateY);
}

String getDateString(int index) {
  var firstDate = DateTime(1900);
  var date = firstDate.add(new Duration(days: index));
  DateFormat dateFormat = DateFormat("MMM dd, yyyy");
  return dateFormat.format(date);
}

int getIndexFromDate(DateTime date) {
  var firstDate = DateTime(1900);
  var result = date.difference(firstDate);
  return result.inDays;
}
