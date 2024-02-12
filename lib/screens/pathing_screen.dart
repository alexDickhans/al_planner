import 'package:al_planner/screens/path_drawer.dart';
import 'package:flutter/material.dart';

import '../utils/bezier.dart';
import '../utils/point.dart';

class PathingScreen extends StatefulWidget {
  const PathingScreen({super.key});

  @override
  State<PathingScreen> createState() => _PathingScreenState();
}

class _PathingScreenState extends State<PathingScreen> {
  late List<Bezier> beziers = [];

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 1.5/1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
                onPanUpdate: (details) {
                  var newBeziers = beziers;
                  for (var bezier in newBeziers) {
                    bezier.move(details, MediaQuery.of(context).size);
                  }
                  print(details.toString());
                  setState(() {
                    beziers = newBeziers;
                  });
                },
                onDoubleTapDown: (details) {
                  print(details.localPosition.toString());
                  // print();print

                  setState(() {
                    beziers.add(Bezier(
                        Point(0.0, 0.0),
                        Point(1.0, 0.0),
                        Point(1.0, 1.0),
                        Point.fromOffset(
                            details.localPosition, MediaQuery.sizeOf(context))));
                  });
                },
                child: CustomPaint(
                  foregroundPainter: PathDrawer(beziers),
                  child: Image.asset('assets/field.png'),
                )
            ),
          ],
        )
    );
  }
}
