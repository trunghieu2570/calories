import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DonutChartPainter extends CustomPainter {
  double value;
  DonutChartPainter({this.value});
  @override
  void paint(Canvas canvas, Size size) {
    var rect = Offset.zero & size;
    canvas.clipRect(rect);
    Paint paint1 = new Paint()
      ..color = Colors.red.withAlpha(50)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5;
    Paint paint2 = new Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 15;
    Paint shadowPaint = new Paint()
      ..color = Colors.blue.withAlpha(60)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4.5);

    Offset center = new Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);
    double sweep1 = 2 * pi * (value / 100);
    double sweep2 = 2 * pi * (0 / 100);
    canvas.drawOval(
        Rect.fromCircle(center: center, radius: radius - 20), paint1);
    canvas.drawOval(Rect.fromCircle(center: center, radius: radius - 50),
        paint1..color = Colors.blue.withAlpha(50));
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius - 20),
        -pi / 2, sweep1, false, paint2..color = Colors.red);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius - 50),
        -pi / 2, sweep2, false, paint2..color = Colors.blue);
    canvas.drawOval(
        Rect.fromCircle(center: center.translate(0, 8), radius: radius - 65),
        shadowPaint);
    canvas.drawOval(Rect.fromCircle(center: center, radius: radius - 70),
        paint2..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class DonutChart extends StatefulWidget {
  @override
  _DonutChartState createState() => _DonutChartState();
}

class _DonutChartState extends State<DonutChart> with TickerProviderStateMixin {
  double value;
  AnimationController valueAnimationController;

  @override
  void initState() {
    super.initState();
    setState(() {
      value = 0;
    });
    valueAnimationController = new AnimationController(
      vsync: this,
      duration: new Duration(milliseconds: 5000),
    )..addListener(() {
        setState(() {
          value = lerpDouble(0, 100, valueAnimationController.value);
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    valueAnimationController.forward(from: 0.4);
    return Container(
      child: CustomPaint(
          painter: DonutChartPainter(value: value),
          child: Center(
            child: new Text(
              value.round().toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40,
                color: Colors.white,
              ),
            ),
          )),
    );
  }
}
