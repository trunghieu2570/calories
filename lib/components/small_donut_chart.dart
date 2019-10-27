import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SmallDonutChartPainter extends CustomPainter {
  double value;
  SmallDonutChartPainter({this.value});
  @override
  void paint(Canvas canvas, Size size) {
    var rect = Offset.zero & size;
    canvas.clipRect(rect);
    Paint paint = new Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt
      ..strokeWidth = 5;

    Offset center = new Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);
    double sweep = 2 * pi * (value / 100);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius - paint.strokeWidth / 2),
        -pi / 2, sweep, false, paint..color = Colors.red);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class SmallDonutChart extends StatefulWidget {
  SmallDonutChart({Key key}) : super(key: key);
  @override
  SmallDonutChartState createState() => SmallDonutChartState();
}

class SmallDonutChartState extends State<SmallDonutChart>
    with TickerProviderStateMixin {
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
        painter: SmallDonutChartPainter(value: value),
      ),
    );
  }
}
