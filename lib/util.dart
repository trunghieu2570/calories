import 'dart:math';
import 'package:flutter/painting.dart';

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

String getDate(int index) {
  var firstDate = DateTime(1900);
  var date = firstDate.add(new Duration(days: index));
  return "${date.day} Thg ${date.month} ${date.year}";
}

int getIndexFromDate(DateTime date) {
  var firstDate = DateTime(1900);
  var result = date.difference(firstDate);
  return result.inDays;
}