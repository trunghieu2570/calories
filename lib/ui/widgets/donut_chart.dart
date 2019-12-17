import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DonutChartPainter extends CustomPainter {
  double value;

  DonutChartPainter({this.value});

  final circlePaint = new Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3;

  final arcPaint = new Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 10;

  @override
  void paint(Canvas canvas, Size size) {
    Offset center = new Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);
    double sweep1 = 2 * pi * (value / 100);
    //Draw circle
    canvas.drawOval(Rect.fromCircle(center: center, radius: radius),
        circlePaint..color = Colors.white.withAlpha(50));
    //DrawArc
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        sweep1, false, arcPaint..color = Colors.white);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class DonutChart extends StatefulWidget {
  final double value;
  final bool animate;

  DonutChart({Key key, this.value, this.animate}) : super(key: key);

  @override
  _DonutChartState createState() => _DonutChartState(value, animate);
}

class _DonutChartState extends State<DonutChart> with TickerProviderStateMixin {
  double _value = 0.0;
  final double value;
  bool _animate;
  AnimationController valueAnimationController;

  _DonutChartState(this.value, this._animate);

  @override
  void initState() {
    super.initState();
    valueAnimationController = new AnimationController(
      vsync: this,
      duration: new Duration(milliseconds: 1000),
    )..addListener(() {
        setState(() {
          _value = lerpDouble(0, value, valueAnimationController.value);
        });
      });
  }

  Future<void> playAnimation() {
    return valueAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    if (_animate) {
      playAnimation();
      _animate = false;
    }
    return Container(
      child: CustomPaint(
          painter: DonutChartPainter(value: _value),
          child: Center(
            child: new Text(
              _value.round().toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40,
                color: Colors.white,
              ),
            ),
          )),
    );
  }

  @override
  void dispose() {
    valueAnimationController.dispose();
    print("desfdjsgdjf");
    super.dispose();
  }
}
