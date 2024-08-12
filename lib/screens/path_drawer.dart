import 'dart:math';

import 'package:flutter/material.dart';
import '../utils/bezier.dart';
import '../utils/robot.dart';

class PathDrawer extends CustomPainter {

  List<Bezier> bezier;
  List<RobotPosition> robots;
  List<double> commandDots;

  PathDrawer(this.bezier, this.robots, this.commandDots);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (var element in bezier) {
      if (element.visible || element.focused) {
        Path path = element.getPath(size.width, size.height);
        if (element.focused) {
          paint.color = Colors.limeAccent;
        } else if (element.reversed) {
          paint.color = Colors.orange;
        } else {
          paint.color = Colors.blue;
        }
        canvas.drawPath(path, paint);
        element.drawCircles(canvas, size.width, size.height);
      }
    }

    for (var robot in robots) {
      canvas.drawCircle(robot.getRobotScreenPosition(size), 5, paint);
      canvas.drawLine(robot.getRobotScreenPosition(size), robot.getRobotScreenPosition(size) + Offset.fromDirection(-robot.angle - pi/2, 20.0), paint);
    }

    for (var command in commandDots) {
      if (0 <= command && bezier.length >= command) {
        paint.color = Colors.yellow;
        if (bezier[command.toInt()].visible) {
          canvas.drawCircle(bezier[command.toInt().clamp(0, bezier.length-1)].evaluate(command % 1.00001).getOffset(size), 5, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}