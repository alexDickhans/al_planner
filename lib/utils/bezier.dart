import 'dart:convert';
import 'dart:core';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'point.dart';

const double pointSize = 12;
const double maxSpeed = 71;
const double maxAccel = 200;

class Bezier {
  Point p1 = Point(0, 0);
  Point p2 = Point(0, 0);
  Point p3 = Point(0, 0);
  Point p4 = Point(0, 0);
  bool reversed = false;
  bool focused = false;
  bool visible = true;

  double pathMaxSpeed = maxSpeed;
  double pathMaxAccel = maxAccel;

  Bezier(
      this.p1, this.p2, this.p3, this.p4, this.pathMaxSpeed, this.pathMaxAccel);

  Bezier.fromJson(Map<String, dynamic> json)
      : p1 = Point.fromJson(json['paths'][0]),
        p2 = Point.fromJson(json['paths'][1]),
        p3 = Point.fromJson(json['paths'][2]),
        p4 = Point.fromJson(json['paths'][3]),
        pathMaxSpeed = json['constraints']['velocity'].toDouble(),
        pathMaxAccel = json['constraints']['accel'].toDouble(),
        reversed = json['inverted'];

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

    if (!visible) {
      return;
    }

    Paint paint = Paint();
    paint.strokeWidth = 3;
    paint.color = Colors.green;
    paint.style = PaintingStyle.stroke;
    canvas.drawCircle(
        Offset(p1.getXScreen(width), p1.getYScreen(height)), pointSize, paint);
    canvas.drawCircle(
        Offset(p2.getXScreen(width), p2.getYScreen(height)), pointSize, paint);

    paint.color = Colors.red;
    canvas.drawCircle(
        Offset(p3.getXScreen(width), p3.getYScreen(height)), pointSize, paint);
    canvas.drawCircle(
        Offset(p4.getXScreen(width), p4.getYScreen(height)), pointSize, paint);
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
        "paths": [p1, p2, p3, p4],
        "constraints": {
          "velocity": pathMaxSpeed.round(),
          "accel": pathMaxAccel.round(),
        }
      };
}
