import 'dart:math';

import 'package:flutter/material.dart';

class Example extends StatefulWidget {
  const Example({Key? key}) : super(key: key);

  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  int percent = 58;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(border: Border.all(
            color: Colors.red
          )),
          child: RadialPercentWidget(
            child: Text(
              '$percent%',
              style: const TextStyle(color: Colors.white,
          fontSize: 25),
            ),
            percent: percent * 0.01,
            fillColor: Colors.blue,
            lineColor: Colors.red,
            freeColor: Colors.yellow,
            lineWidth: 5,
          )
        )
    );
  }
}

class RadialPercentWidget extends StatelessWidget {
  final Widget child;

  final double percent;
  final Color fillColor;
  final Color lineColor;
  final Color freeColor;
  final double lineWidth;

  const RadialPercentWidget({Key? key, required this.child, required this.percent, required this.fillColor, required this.lineColor, required this.freeColor, required this.lineWidth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CustomPaint(
          painter: MyPainter(
            percent: percent,
            fillColor: fillColor,
            lineColor: lineColor,
            freeColor: freeColor,
            lineWidth: lineWidth
          ),
        ),
        Center(child: child),
      ],
    );
  }
}



class MyPainter extends CustomPainter{
  final double percent;
  final Color fillColor;
  final Color lineColor;
  final Color freeColor;
  final double lineWidth;

  MyPainter({
    required this.percent,
    required this.fillColor,
    required this.lineColor,
    required this.freeColor,
    required this.lineWidth
  });

  @override
  void paint(Canvas canvas, Size size) {
    const circlePadding = 8.0;
    final arcRect = Offset(lineWidth / 2 + circlePadding / 2, lineWidth / 2 + circlePadding / 2) & Size(size.width - lineWidth - circlePadding, size.height - lineWidth - circlePadding);

    drawBackground(canvas, size);
    drawFilledArc(canvas, arcRect);
    drawFillArc(canvas, arcRect);


    // paint.strokeWidth = 15;
    // canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width / 2, paint);
    // canvas.drawRect(rect, paint);
    // canvas.drawRect(Offset.zero & Size(30, 30), paint);
  }

  void drawFillArc(Canvas canvas, Rect arcRect) {
    final paint = Paint();
    paint.color = lineColor;
    paint.style = PaintingStyle.stroke;
    paint.strokeCap = StrokeCap.round;
    paint.strokeWidth = lineWidth;
    canvas.drawArc(
        arcRect,
        -pi / 2,
        pi * 2 * percent,
        false,
        paint
    );
  }

  void drawFilledArc(Canvas canvas, Rect arcRect) {
    final paint = Paint();
    paint.color = freeColor;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = lineWidth;
    canvas.drawArc(
        arcRect,
        pi * 2 * percent - (pi / 2),
        pi * 2 * (1 - percent),
        false,
        paint
    );
  }

  void drawBackground(Canvas canvas, Size size) {
    final backgroundPaint = Paint();
    backgroundPaint.color = fillColor;
    backgroundPaint.style = PaintingStyle.fill;
    canvas.drawOval(Offset.zero & size, backgroundPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}