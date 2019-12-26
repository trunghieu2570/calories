import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DonutChartPainter extends CustomPainter {
  double _value;
  double _maxValue;

  DonutChartPainter(this._value, this._maxValue);

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
    double sweep1 = 2 * pi * (_value / _maxValue);
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
  final double maxValue;
  final double showValue;

  DonutChart({Key key, this.maxValue, this.showValue}) : super(key: key);

  //@override
  //_DonutChartState createState() => _DonutChartState(maxValue, showValue);
  @override
  DonutChartState createState() => DonutChartState();
}

class DonutChartState extends State<DonutChart> with TickerProviderStateMixin {
  double _value = 0.0;
  AnimationController valueAnimationController;
  var ani;

  @override
  void initState() {
    valueAnimationController = new AnimationController(
      vsync: this,
      duration: new Duration(milliseconds: 1000),
    );

    ani = Tween(begin: 0, end: widget.showValue).animate(CurvedAnimation(
        curve: Curves.easeInOutCirc, parent: valueAnimationController));
    valueAnimationController.addListener(() {
      setState(() {
        _value = ani.value.toDouble();
      });
    });
    super.initState();
    playAnimation();
  }

  void playAnimation() {
    valueAnimationController.forward(from: 0.0);
  }

  @override
  void didUpdateWidget(DonutChart oldWidget) {
    if (widget.showValue != oldWidget.showValue)
      ani = Tween(begin: 0, end: widget.showValue).animate(CurvedAnimation(
          curve: Curves.easeInOutCirc, parent: valueAnimationController));
    super.didUpdateWidget(oldWidget);
    playAnimation();
    //initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomPaint(
        painter: DonutChartPainter(_value, widget.maxValue),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                (widget.maxValue - _value).abs().round().toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                ),
              ),
              Text(
                widget.showValue < widget.maxValue ? 'remain' : 'over',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    valueAnimationController.dispose();
    super.dispose();
  }
}
