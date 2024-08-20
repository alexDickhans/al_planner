import 'dart:math';
import 'dart:ui';
import 'package:al_planner/utils/double.dart';
import 'package:format/format.dart';
import 'package:al_planner/src/rust/third_party/motion_profiling/path.dart' as path;

const double fieldWidth = 3.65;

class Point {
  double x = 0;
  double y = 0;

  Point(this.x, this.y);

  Point.fromOffset(Offset offset, Size size)
      : x = -offset.dy * fieldWidth / size.width + fieldWidth / 2,
        y = -offset.dx * fieldWidth / size.height + fieldWidth / 2;

  Point.fromJson(Map<String, dynamic> json)
      : x = json['x'] as double,
        y = json['y'] as double;

  Map<String, dynamic> toJson() => {
        'x': x.toPrecision(3),
        'y': y.toPrecision(3),
      };

  double getXScreen(double width) {
    return -y * width / fieldWidth + width / 2;
  }

  double getYScreen(double height) {
    return -x * height / fieldWidth + height / 2;
  }

  Offset getOffset(Size size) {
    return Offset(getXScreen(size.width), getYScreen(size.height));
  }

  double getX() {
    return x;
  }

  double getY() {
    return y;
  }

  Point lerp(Point a, double t) {
    return Point(x * (1.0 - t) + a.x * t, y * (1.0 - t) + a.y * t);
  }

  void move(double x, double y, double width, double height) {
    this.x -= y * fieldWidth / width;
    this.y -= x * fieldWidth / height;
  }

  @override
  String toString() {
    return "x: {:.1f}, y: {:.1f}".format(x, y);
  }

  path.Point toPoint() {
    return path.Point(x: x, y: y);
  }

  Point minus(Point rhs) {
    return Point(x - rhs.x, y - rhs.y);
  }

  Point plus(Point rhs) {
    return Point(x + rhs.x, y + rhs.y);
  }

  Point times(double mult) {
    return Point(x * mult, y * mult);
  }

  Point midpoint(Point rhs) {
    return Point((rhs.x + x) / 2.0, (rhs.y + y) / 2.0);
  }

  double magnitude() {
    return sqrt(pow(x, 2) + pow(y, 2));
  }

  Point norm() {
    var mag = magnitude();
    return Point(x/mag, y/mag);
  }

}
