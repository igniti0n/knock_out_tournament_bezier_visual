// import 'dart:developer' as dev;
// import 'dart:math';

import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:practice/element_pair.dart';

class ElementsConnectionsPainter extends CustomPainter {
  final List<ElementPair> pairs;

  ElementsConnectionsPainter({
    required this.pairs,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // canvas.translate(0, -165);
    for (final pair in pairs) {
      var first = pair.first;
      var second = pair.second;
      if (second.position.dy < first.position.dy) {
        final temp = first;
        first = second;
        second = temp;
      }
      connectWidgets(
        canvas: canvas,
        size: size,
        widget1Position: first.position,
        widget2Position: second.position,
        widget1Size: first.size,
        widget2Size: second.size,
      );
      // drawDependencyDirectionArrow(
      //   canvas: canvas,
      //   widget1Position: pair.first.position,
      //   widget2Position: pair.second.position,
      //   widget1Size: pair.first.size,
      //   widget2Size: pair.second.size,
      // );
    }
  }

  void drawDependencyDirectionArrow({
    required Canvas canvas,
    required Offset widget1Position,
    required Offset widget2Position,
    required Size widget1Size,
    required Size widget2Size,
  }) {
    final firstWidth = widget1Size.width / 2;
    final secondWidth = widget2Size.width / 2;
    final firstPositionX = widget1Position.dx;
    final firstPositionY = widget1Position.dy;
    final secondPositionX = widget2Position.dx;
    final secondPositionY = widget2Position.dy;
    // Draw the circle
    final midpoint = Offset(
      (firstPositionX + firstWidth + secondPositionX + secondWidth) / 2,
      (firstPositionY + (widget1Size.height / 2) + secondPositionY + (widget2Size.height / 2)) / 2,
    );
    final distX = ((firstPositionX + firstWidth) - (secondPositionX + secondWidth));
    final distY = ((firstPositionY + (widget1Size.height / 2)) - (secondPositionY + (widget2Size.height / 2)));

    final tang = atan2(distY, distX);
    final angle = tang * (180 / pi);

    final circlePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;
    const radius = 12.0;
    // canvas.drawCircle(midpoint, radius, circlePaint);

    const xPadding = 5;
    final xPaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..strokeWidth = 2.5;

    final radiansAngle = tang - pi / 2;
    canvas.translate(midpoint.dx, midpoint.dy);
    canvas.rotate(radiansAngle);
    canvas.drawLine(
      const Offset(0, -radius + xPadding),
      const Offset(radius - xPadding, radius - xPadding),
      // Offset(midpoint.dx, midpoint.dy - radius + xPadding),
      // Offset(midpoint.dx + radius - xPadding, midpoint.dy + radius - xPadding),
      xPaint,
    );
    canvas.drawLine(
      const Offset(-radius + xPadding, radius - xPadding),
      const Offset(0, -radius + xPadding),
      // Offset(midpoint.dx - radius + xPadding, midpoint.dy + radius - xPadding),
      // Offset(midpoint.dx, midpoint.dy - radius + xPadding),
      xPaint,
    );
    canvas.rotate(-(radiansAngle));
    canvas.translate(-midpoint.dx, -midpoint.dy);
  }

  void connectWidgets({
    required Canvas canvas,
    required Size size,
    required Offset widget1Position,
    required Offset widget2Position,
    required Size widget1Size,
    required Size widget2Size,
  }) {
    final path = Path();
    final linePaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(size.width / 2, 100),
        Offset(size.width / 2, size.height - 100),
        [Colors.red, Colors.blue],
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    late final Offset firstCenter;
    late final Offset secondCenter;

    if (widget1Position.dx < widget2Position.dx) {
      firstCenter = Offset(
        widget1Position.dx + widget1Size.width,
        widget1Position.dy + widget1Size.height / 2,
      );
      secondCenter = Offset(
        widget2Position.dx, //+ widget2Size.width / 2,
        widget2Position.dy + widget2Size.height / 2,
      );
    } else {
      firstCenter = Offset(
        widget1Position.dx,
        widget1Position.dy + widget1Size.height / 2,
      );
      secondCenter = Offset(
        widget2Position.dx + widget2Size.width,
        widget2Position.dy + widget2Size.height / 2,
      );
    }

    // firstCenter = Offset(
    //   widget1Position.dx + widget1Size.width,
    //   widget1Position.dy + widget1Size.height / 2,
    // );
    //  secondCenter = Offset(
    //   widget2Position.dx, //+ widget2Size.width / 2,
    //   widget2Position.dy + widget2Size.height / 2,
    // );

    final mainMidPoint = getMidpoint(
      firstPosition: firstCenter,
      secondPosition: secondCenter,
      firstSize: widget1Size,
      secondSize: widget2Size,
    );
    var firstHalfMidpoint = getMidpoint(
      firstPosition: firstCenter,
      secondPosition: mainMidPoint,
      firstSize: widget1Size,
      secondSize: widget2Size,
    );
    var secondHalfMidpoint = getMidpoint(
      firstPosition: mainMidPoint,
      secondPosition: secondCenter,
      firstSize: widget1Size,
      secondSize: widget2Size,
    );
    late final double yDifference;

    if (firstHalfMidpoint.dy > secondHalfMidpoint.dy) {
      yDifference = (firstHalfMidpoint.dy - secondHalfMidpoint.dy) / 2;
    } else {
      yDifference = (secondHalfMidpoint.dy - firstHalfMidpoint.dy) / 2;
    }

    if (secondHalfMidpoint.dx < firstHalfMidpoint.dx) {
      secondHalfMidpoint += Offset(yDifference, yDifference);
    } else if (secondHalfMidpoint.dx > firstHalfMidpoint.dx) {
      secondHalfMidpoint += Offset(-yDifference, yDifference);
    }

    if (firstHalfMidpoint.dy > mainMidPoint.dy) {
      firstHalfMidpoint += Offset(0, yDifference);
    } else if (firstHalfMidpoint.dy < mainMidPoint.dy) {
      firstHalfMidpoint += Offset(0, -yDifference);
    }

    // canvas.drawCircle(firstHalfMidpoint, 10, linePaint);
    // canvas.drawCircle(mainMidPoint, 10, linePaint);
    // canvas.drawCircle(secondHalfMidpoint, 10, linePaint);

    // draw berzier curves connecting the two elements all fancy like
    path.moveTo(firstCenter.dx, firstCenter.dy);
    path.cubicTo(
      firstHalfMidpoint.dx,
      firstHalfMidpoint.dy,
      secondHalfMidpoint.dx,
      secondHalfMidpoint.dy,
      secondCenter.dx,
      secondCenter.dy,
    );
    // path.quadraticBezierTo(
    //   secondHalfMidpoint.dx,
    //   secondHalfMidpoint.dy,
    //   secondCenter.dx,
    //   secondCenter.dy,
    // );

    canvas.drawPath(path, linePaint);
  }

  Offset getMidpoint({
    required Offset firstPosition,
    required Offset secondPosition,
    required Size firstSize,
    required Size secondSize,
  }) {
    final firstPositionX = firstPosition.dx;
    final firstPositionY = firstPosition.dy;
    final secondPositionX = secondPosition.dx;
    final secondPositionY = secondPosition.dy;
    // Draw the circle
    final midpoint = Offset(
      firstPositionX + (secondPositionX - firstPositionX) / 2,
      firstPositionY + (secondPositionY - firstPositionY) / 2,
    );
    return midpoint;
  }

  @override
  bool shouldRepaint(covariant ElementsConnectionsPainter oldDelegate) {
    return oldDelegate.pairs != pairs;
  }
}
