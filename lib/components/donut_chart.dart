import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:calories/util.dart' as Util;

class DonutChartPainter extends CustomPainter {
  double value;
  DonutChartPainter({this.value});

  final circlePaint = new Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 5;
  //arc
  final arcPaint = new Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 15;

  final redGradient = new SweepGradient(
    colors: [
      Colors.red[200],
      Colors.red,
    ],
  );
  final blueGradient = new SweepGradient(
    colors: [
      Colors.lightBlue,
      Colors.blue,
    ],
  );
  //paint2
  final paint2 = new Paint()
    ..color = Colors.red
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..strokeWidth = 12;
  //shadow
  final shadowPaint = new Paint()
    ..color = Colors.green.withAlpha(80)
    ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3.5);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    //Xoay canvas
    Offset rotated = Util.rotateOffset(angle: -pi / 2, size: size);
    canvas.translate(rotated.dx, rotated.dy);
    canvas.rotate(-pi / 2);
    //Draw
    Offset center = new Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);
    double sweep1 = 2 * pi * (value / 100);
    double sweep2 = 2 * pi * (40 / 100);
    //Draw circle
    canvas.drawOval(Rect.fromCircle(center: center, radius: radius - 20),
        circlePaint..color = Colors.red.withAlpha(50));
    canvas.drawOval(Rect.fromCircle(center: center, radius: radius - 50),
        circlePaint..color = Colors.blue.withAlpha(50));
    //DrawArc
    canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - 20),
        0,
        sweep1,
        false,
        arcPaint
          ..color = Colors.red
          ..shader = redGradient
              .createShader(Rect.fromCircle(center: center, radius: radius)));
    canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - 50),
        0,
        sweep2,
        false,
        arcPaint
          ..color = Colors.blue
          ..shader = blueGradient
              .createShader(Rect.fromCircle(center: center, radius: radius)));
    canvas.drawOval(
        Rect.fromCircle(center: center.translate(0, 5), radius: radius - 70),
        shadowPaint);
    canvas.drawOval(
        Rect.fromCircle(center: center, radius: radius - 75),
        paint2
          ..style = PaintingStyle.fill
          ..color = Colors.green);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class DonutChart extends StatefulWidget {
  DonutChart({Key key}) : super(key: key);
  @override
  DonutChartState createState() => DonutChartState();
}

class DonutChartState extends State<DonutChart> with TickerProviderStateMixin {
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

  void playAnimation() {
    valueAnimationController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
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
