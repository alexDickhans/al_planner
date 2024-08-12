import 'dart:ui';
import 'package:al_planner/utils/double.dart';
import 'package:format/format.dart';

const double fieldWidth = 3.65;

class Point {
  double x = 0;
  double y = 0;

  Point(this.x, this.y);

  Point.fromOffset(Offset offset, Size size)
      : x = offset.dy * fieldWidth / size.width,
        y = offset.dx * fieldWidth / size.height;

  Point.fromJson(Map<String, dynamic> json)
      : x = json['x'] as double,
        y = json['y'] as double;

  Map<String, dynamic> toJson() => {
        'x': x.toPrecision(3),
        'y': y.toPrecision(3),
      };

  double getXScreen(double width) {
    return y * width / fieldWidth;
  }

  double getYScreen(double height) {
    return x * height / fieldWidth;
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
    this.x += y * fieldWidth / width;
    this.y += x * fieldWidth / height;
  }

  @override
  String toString() {
    return "x: {:.1f}, y: {:.1f}".format(x * 39.37, y * 39.37);
  }
}
