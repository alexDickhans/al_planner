
import 'dart:ui';

import 'package:al_planner/utils/point.dart';

class RobotPosition {
  double x, y, angle;

  RobotPosition(this.x, this.y, this.angle);

  Offset getRobotScreenPosition(Size size) {
    return Offset(size.width/2 - y*size.height/fieldWidth, size.height/2 + x*size.height/fieldWidth);
  }
}