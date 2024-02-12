
import 'dart:ui';

const double fieldWidth = 3.65;

class Point {
  double x = 0;
  double y = 0;

  Point(this.x, this.y);

  Point.fromOffset(Offset offset, Size size) : x = offset.dy * fieldWidth / size.width, y = offset.dx * fieldWidth / size.height;

  Point.fromJson(Map<String, dynamic> json) : x = json['x'] as double, y = json['y'] as double;

  Map<String, dynamic> toJson() => {
    'x': x,
    'y': y,
  };

  double getXScreen(double width) {
    return y * width / fieldWidth;
  }

  double getYScreen(double height) {
    return x * height / fieldWidth;
  }

  double getX() {
    return x;
  }

  double getY() {
    return y;
  }

  void move(double x, double y, double width, double height) {
    this.x += y * fieldWidth / width;
    this.y += x * fieldWidth / height;
  }
}