import 'dart:core';
import 'dart:math';

import 'package:al_planner/screens/pathing_screen.dart';
import 'package:al_planner/src/rust/third_party/motion_profiling/path.dart' as path;
import 'package:al_planner/utils/double.dart';
import 'package:flutter/material.dart';

import 'point.dart';

const double pointSize = 12;
const double maxSpeed = 76;
const double maxAccel = 250;

class Bezier {
  Point p1 = Point(0, 0);
  Point p2 = Point(0, 0);
  Point p3 = Point(0, 0);
  Point p4 = Point(0, 0);
  bool reversed = false;
  bool focused = false;
  bool visible = true;
  bool stopEnd = false;

  double pathMaxSpeed = maxSpeed;
  double pathMaxAccel = maxAccel;

  Bezier(this.p1, this.p2, this.p3, this.p4, this.pathMaxSpeed,
      this.pathMaxAccel, this.stopEnd);

  Bezier.fromJson(Map<String, dynamic> json)
      : p1 = Point.fromJson(json['path'][0]),
        p2 = Point.fromJson(json['path'][1]),
        p3 = Point.fromJson(json['path'][2]),
        p4 = Point.fromJson(json['path'][3]),
        pathMaxSpeed = json['constraints']['velocity'].toDouble() * 39.37,
        pathMaxAccel = json['constraints']['accel'].toDouble() * 39.37,
        reversed = json['inverted'],
        stopEnd = json.containsKey("stop_end") ? json["stop_end"] : false;

  Path getPath(width, height) {
    Path path = Path();
    path.moveTo(p1.getXScreen(width), p1.getYScreen(height));
    path.cubicTo(
        p2.getXScreen(width),
        p2.getYScreen(height),
        p3.getXScreen(width),
        p3.getYScreen(height),
        p4.getXScreen(width),
        p4.getYScreen(height));
    return path;
  }

  void drawCircles(Canvas canvas, width, height) {
    Paint paint = Paint();
    paint.strokeWidth = 3;
    paint.color = Colors.green;
    paint.style = PaintingStyle.stroke;
    canvas.drawCircle(
        Offset(p1.getXScreen(width), p1.getYScreen(height)), pointSize, paint);
    canvas.drawCircle(
        Offset(p2.getXScreen(width), p2.getYScreen(height)), pointSize, paint);

    if (stopEnd) {
      paint.color = Colors.deepOrangeAccent;
    } else {
      paint.color = Colors.red;
    }
    canvas.drawCircle(Offset(p3.getXScreen(width), p3.getYScreen(height)),
        pointSize - 2, paint);
    canvas.drawCircle(Offset(p4.getXScreen(width), p4.getYScreen(height)),
        pointSize - 2, paint);
  }

  Point evaluate(double t) {
    Point p5 = p1.lerp(p2, t);
    Point p6 = p2.lerp(p3, t);
    Point p7 = p3.lerp(p4, t);
    Point p8 = p5.lerp(p6, t);
    Point p9 = p6.lerp(p7, t);
    return p8.lerp(p9, t);
  }

  bool move(DragUpdateDetails details, Size size) {
    if (!visible) {
      return false;
    }

    if (sqrt(pow(
                p1.getXScreen(size.width) +
                    details.delta.dx -
                    details.localPosition.dx,
                2) +
            pow(
                p1.getYScreen(size.height) +
                    details.delta.dy -
                    details.localPosition.dy,
                2)) <
        pointSize) {
      p1.move(details.delta.dx, details.delta.dy, size.width, size.height);
      p2.move(details.delta.dx, details.delta.dy, size.width, size.height);
      return true;
    }
    if (sqrt(pow(
                p2.getXScreen(size.width) +
                    details.delta.dx -
                    details.localPosition.dx,
                2) +
            pow(
                p2.getYScreen(size.height) +
                    details.delta.dy -
                    details.localPosition.dy,
                2)) <
        pointSize) {
      p2.move(details.delta.dx, details.delta.dy, size.width, size.height);
      return true;
    }
    if (sqrt(pow(
                p3.getXScreen(size.width) +
                    details.delta.dx -
                    details.localPosition.dx,
                2) +
            pow(
                p3.getYScreen(size.height) +
                    details.delta.dy -
                    details.localPosition.dy,
                2)) <
        pointSize) {
      p3.move(details.delta.dx, details.delta.dy, size.width, size.height);
      return true;
    }
    if (sqrt(pow(
                p4.getXScreen(size.width) +
                    details.delta.dx -
                    details.localPosition.dx,
                2) +
            pow(
                p4.getYScreen(size.height) +
                    details.delta.dy -
                    details.localPosition.dy,
                2)) <
        pointSize) {
      p4.move(details.delta.dx, details.delta.dy, size.width, size.height);
      p3.move(details.delta.dx, details.delta.dy, size.width, size.height);
      return true;
    }

    return false;
  }

  bool isOver(details, Size size) {
    if (!visible) {
      return false;
    }

    if (sqrt(pow(p1.getXScreen(size.width) - details.localPosition.dx, 2) +
            pow(p1.getYScreen(size.height) - details.localPosition.dy, 2)) <
        pointSize) {
      return true;
    }
    if (sqrt(pow(p2.getXScreen(size.width) - details.localPosition.dx, 2) +
            pow(p2.getYScreen(size.height) - details.localPosition.dy, 2)) <
        pointSize) {
      return true;
    }
    if (sqrt(pow(p3.getXScreen(size.width) - details.localPosition.dx, 2) +
            pow(p3.getYScreen(size.height) - details.localPosition.dy, 2)) <
        pointSize) {
      return true;
    }
    if (sqrt(pow(p4.getXScreen(size.width) - details.localPosition.dx, 2) +
            pow(p4.getYScreen(size.height) - details.localPosition.dy, 2)) <
        pointSize) {
      return true;
    }

    return false;
  }

  @override
  String toString() {
    // TODO: implement toString
    return "P1:$p1 P2: $p2 P3: $p3 P4: $p4";
  }

  Map<String, dynamic> toJson() => {
        "inverted": reversed,
        "stop_end": stopEnd,
        "path": [p1, p2, p3, p4],
        "constraints": {
          "velocity": (pathMaxSpeed / 39.37).toPrecision(3),
          "accel": (pathMaxAccel / 39.37).toPrecision(3),
        }
      };

  path.PathSegment toPathSegment() {
    return path.PathSegment(inverted: reversed, stopEnd: stopEnd, path: [p1.toPoint(), p2.toPoint(), p3.toPoint(), p4.toPoint()]);
  }
}
