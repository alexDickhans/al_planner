import 'package:flutter/material.dart';
import '../utils/bezier.dart';

class PathDrawer extends CustomPainter {

  List<Bezier> bezier;

  PathDrawer(this.bezier);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (var element in bezier) {
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

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}