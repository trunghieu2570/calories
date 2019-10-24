import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class DonutChartPainter extends CustomPainter {
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var rect = Offset.zero & size;
    canvas.clipRect(rect);
    Paint paint = new Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 20;

    Offset center = new Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);
    double sweep1 = 2 * pi * (80 / 100);
    double sweep2 = 2 * pi * (50 / 100);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius - 20),
        -pi / 2, sweep1, false, paint);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius - 50),
        -pi / 2, sweep2, false, paint..color = Colors.blue);
  }
}

class DonutChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomPaint(
        painter: DonutChartPainter(),
      ),
    );
  }
}
