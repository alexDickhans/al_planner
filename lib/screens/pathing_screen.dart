import 'dart:convert';

import 'package:al_planner/screens/path_drawer.dart';
import 'package:flutter/material.dart';

import '../utils/bezier.dart';
import '../utils/point.dart';

class Command {
  double t = 0;
  String name = "";
  TextEditingController? textEditingController;

  Command(this.t, this.name) {
    textEditingController = TextEditingController(text: name);
  }
}

class PathingScreen extends StatefulWidget {
  const PathingScreen({super.key});

  @override
  State<PathingScreen> createState() => _PathingScreenState();
}

class _PathingScreenState extends State<PathingScreen> {
  List<Bezier> beziers = [];
  List<Command> commands = [];
  double defaultMaxSpeed = maxSpeed;
  double defaultMaxAccel = maxAccel;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          AspectRatio(
              aspectRatio: 16 / 9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return GestureDetector(
                          onPanUpdate: (details) {
                            var newBeziers = beziers;
                            for (var bezier in newBeziers) {
                              bezier.move(details, context.size!);
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
                                      details.localPosition, context.size!),
                                  maxSpeed,
                                  maxAccel));
                            });
                          },
                          child: CustomPaint(
                            foregroundPainter: PathDrawer(beziers),
                            child: Image.asset('assets/field.png'),
                          ));
                    },
                  )),
                  Expanded(
                    child: buildVelConstraints(),
                  ),
                ],
              )),
          Column(children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  commands.add(Command(0.0, "change"));
                });
              },
              child: const Icon(Icons.add),
            ),
            SizedBox(
              width: 800,
              height: 300,
              child: ListView.builder(
                  itemCount: commands.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            flex: 2,
                            child: Slider(
                                label: commands[index].t.toString(),
                                max: beziers.length.toDouble(),
                                value: commands[index].t,
                                onChanged: (double value) {
                                  setState(() {
                                    commands[index].t = value;
                                  });
                                })),
                        Expanded(
                            child: TextField(
                          controller: commands[index].textEditingController,
                          onChanged: (value) {
                            setState(() {
                              commands[index].name = value;
                              print(value);
                            });
                          },
                        )),
                      ],
                    );
                  }),
            ),
          ]),
          TextField(),
        ],
      ),
    );
  }

  Container buildVelConstraints() {
    return Container(
      color: Colors.blue,
      child: SizedBox(
        height: 300,
        width: 100,
        child: Column(
          children: [
            const Text(
              "Velocity, Accel",
              style: TextStyle(fontSize: 30),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Default: "),
                Expanded(
                  child: Slider(
                    value: defaultMaxSpeed,
                    min: 0,
                    max: maxSpeed,
                    onChanged: (double value) {
                      setState(() {
                        defaultMaxSpeed = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: Slider(
                    value: defaultMaxAccel,
                    min: 0,
                    max: maxAccel,
                    onChanged: (double value) {
                      setState(() {
                        defaultMaxAccel = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            SingleChildScrollView(
              child: SizedBox(
                height: 400,
                width: 400,
                child: ListView.builder(
                    itemCount: beziers.length,
                    itemBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: 30,
                        width: 400,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Switch(
                              value: beziers[index].reversed,
                              onChanged: (bool value) {
                                setState(() {
                                  beziers[index].reversed = value;
                                });
                              },
                            ),
                            Expanded(
                              child: Slider(
                                value: beziers[index].pathMaxSpeed,
                                min: 0,
                                max: maxSpeed,
                                onChanged: (double value) {
                                  setState(() {
                                    beziers[index].pathMaxSpeed = value;
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: Slider(
                                value: beziers[index].pathMaxAccel,
                                min: 0,
                                max: maxAccel,
                                onChanged: (double value) {
                                  setState(() {
                                    beziers[index].pathMaxAccel = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getData() {
    return "";
  }

  void setData(String data) {
    setState(() {
      final parsedData = jsonDecode(data) as Map<String, dynamic>;
    });
  }
}
