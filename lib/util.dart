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
