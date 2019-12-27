import 'dart:math';

import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';

DateFormat _dateFormat = DateFormat("MMM dd, yyyy");

String add2StringAsDouble(String a, String b) {
  num na = num.parse(a != null ? a : 0.0);
  num nb = num.parse(b != null ? b : 0.0);
  if (na is double) {
    return (na * nb).toStringAsFixed(1);
  }
  if (nb is double) {
    return (na * nb).toStringAsFixed(1);
  }
  return (na + nb).toString();
}

String multiStringAndNum(String a, num n) {
  num na = num.parse(a != null ? a : 0);
  if (na is double) {
    return (na * n).toStringAsFixed(1);
  }
  if (n is double) {
    return (na * n).toStringAsFixed(1);
  }
  return (na * n).toString();
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

  return _dateFormat.format(date);
}

DateTime getDateFromIndex(int index) {
  try {
    return _dateFormat.parse(getDateString(index));
  } catch (err) {
    print(err);
    return null;
  }
}

int getIndexFromDate(DateTime date) {
  var firstDate = DateTime(1900);
  var result = date.difference(firstDate);
  return result.inDays;
}
