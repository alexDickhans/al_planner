import 'dart:convert';

import 'package:al_planner/screens/path_drawer.dart';
import 'package:al_planner/utils/double.dart';
import 'package:al_planner/utils/robot.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'dart:io';

import '../utils/bezier.dart';
import '../utils/point.dart';

class Command {
  double t = 0;
  String name = "";
  TextEditingController? textEditingController;

  Command(this.t, this.name) {
    textEditingController = TextEditingController(text: name);
  }

  Command.fromJson(Map<String, dynamic> json)
      : t = json['t'],
        name = json['name'] {
    textEditingController = TextEditingController(text: name);
  }

  Map<String, dynamic> toJson() => {
        't': t.toPrecision(3),
        'name': name,
      };
}

class PathingScreen extends StatefulWidget {
  File currentFile = File("");
  void Function(String) stringConsumer;
  bool liveRobot = false;

  PathingScreen(this.currentFile, this.stringConsumer, this.liveRobot,
      {super.key});

  @override
  State<PathingScreen> createState() => _PathingScreenState();
}

class _PathingScreenState extends State<PathingScreen> {
  List<Bezier> beziers = [];
  List<Command> commands = [];
  List<RobotPosition> robots = [];
  double defaultMaxSpeed = maxSpeed;
  double defaultMaxAccel = 120;
  TextEditingController editingController = TextEditingController(text: "");
  bool allVisible = true;
  double startSpeed = 0.0;
  double endSpeed = 0.0;

  void updateFile() {
    widget.currentFile.readAsString().then((value) => {setData(value)});
  }

  @override
  void initState() {
    super.initState();
    updateFile();

    if (widget.liveRobot) {
      SSEClient.subscribeToSSE(
          method: SSERequestType.GET,
          url: 'http://192.168.4.1/uart0',
          header: {
            "Accept": "text/event-stream",
          }).listen(
        (event) {
          // var jData = jsonDecode(event.data!);
          print('Id: ' + event.id!);
          print('Event: ' + event.event!);
          print(event.data!);
          var jData = jsonDecode(event.data!);
          setState(() {
            robots.clear();
            robots.add(RobotPosition(jData[0], jData[1], jData[2]));
          });
        },
      );
    }
  }

  @override
  void didUpdateWidget(PathingScreen old) {
    super.didUpdateWidget(old);
    updateFile();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: startSpeed,
                    label: startSpeed.round().toString(),
                    divisions: 12,
                    min: -72.0,
                    max: 72.0,
                    onChanged: (double value) {
                      setState(() {
                        startSpeed = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: Slider(
                    value: endSpeed,
                    label: endSpeed.round().toString(),
                    divisions: 12,
                    min: -72.0,
                    max: 72.0,
                    onChanged: (double value) {
                      setState(() {
                        endSpeed = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            AspectRatio(
                aspectRatio: 16 / 9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: SizedBox(child: LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
                          return GestureDetector(
                              onTapDown: (details) {
                                if (RawKeyboard.instance.keysPressed
                                    .contains(LogicalKeyboardKey.shiftLeft)) {
                                  var newBeziers = beziers;

                                  newBeziers.removeWhere((element) {
                                    return element.isOver(
                                        details, context.size!);
                                  });

                                  setState(() {
                                    beziers = newBeziers;
                                  });
                                }
                              },
                              onPanUpdate: (details) {
                                if (RawKeyboard.instance.keysPressed
                                    .contains(LogicalKeyboardKey.shiftLeft)) {
                                  var newBeziers = beziers;

                                  newBeziers.removeWhere((element) {
                                    return element.isOver(
                                        details, context.size!);
                                  });

                                  setState(() {
                                    beziers = newBeziers;
                                  });
                                } else {
                                  var newBeziers = beziers;

                                  for (var bezier in newBeziers) {
                                    if (bezier.move(details, context.size!)) {
                                      break;
                                    }
                                  }

                                  setState(() {
                                    beziers = newBeziers;
                                  });
                                }
                              },
                              onDoubleTapDown: (details) {
                                setState(() {
                                  beziers.add(Bezier(
                                      beziers.isEmpty
                                          ? Point(1.6, 1.6)
                                          : beziers[beziers.length - 1].p4,
                                      Point(1.6, 2.0),
                                      Point(2.0, 2.0),
                                      Point.fromOffset(
                                          details.localPosition, context.size!),
                                      defaultMaxSpeed,
                                      defaultMaxAccel,
                                      false));
                                });
                              },
                              child: CustomPaint(
                                foregroundPainter: PathDrawer(beziers, robots, commands.map((e) => e.t).toList()),
                                child: Image.asset('assets/field.png'),
                              ));
                        },
                      )),
                    ),
                    Expanded(
                      child: Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: buildVelConstraints(context)),
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
                width: 1600,
                height: 300,
                child: ListView.builder(
                    itemCount: commands.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RawMaterialButton(
                              constraints: const BoxConstraints(
                                  minWidth: 36.0, minHeight: 36.0),
                              shape: RoundedRectangleBorder(
                                  side: BorderSide.none,
                                  borderRadius: BorderRadius.circular(20)),
                              fillColor: const Color(0xFFFF9700),
                              onPressed: () {
                                setState(() {
                                  commands.removeAt(index);
                                });
                              },
                              child: const Icon(Icons.remove)),
                          Expanded(
                              flex: 2,
                              child: Slider(
                                  divisions: 1000,
                                  label: commands[index]
                                      .t
                                      .toPrecision(3)
                                      .toString(),
                                  max: beziers.length.toDouble(),
                                  onChangeEnd: (_) {
                                    setState(() {
                                      commands.sort((a, b) => a.t.compareTo(b.t));
                                    });
                                  },
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
                              });
                            },
                          )),
                        ],
                      );
                    }),
              ),
            ]),
            Container(
              padding: const EdgeInsets.only(bottom: 100),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  editingController.text = getData();
                  return TextField(
                    keyboardType: TextInputType.multiline,
                    controller: editingController,
                    onSubmitted: (value) {
                      setData(value);
                    },
                    // onTapOutside: (value) {
                    //   setData(value);
                    // },
                    maxLines: 1200,
                    minLines: 5,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Container buildVelConstraints(BuildContext context) {
    return Container(
      // color: Theme.of(context).focusColor,
      decoration: const BoxDecoration(
          color: Color(0xfff5e6cf),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: SizedBox(
        height: 1000,
        width: 100,
        child: Padding(
          padding: EdgeInsets.all(10),
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
                  Switch(
                      value: allVisible,
                      onChanged: (value) {
                        setState(() {
                          allVisible = value;

                          for (var bezier in beziers) {
                            bezier.visible = value;
                          }
                        });
                      }),
                  Expanded(
                    child: Slider(
                      divisions: maxSpeed.toInt(),
                      label: defaultMaxSpeed.round().toString(),
                      value: defaultMaxSpeed,
                      min: 0,
                      max: maxSpeed,
                      onChanged: (double value) {
                        setState(() {
                          defaultMaxSpeed = value;
                          for (var element in beziers) {
                            element.pathMaxSpeed = value;
                          }
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: Slider(
                      divisions: maxAccel.toInt(),
                      label: defaultMaxAccel.round().toString(),
                      value: defaultMaxAccel,
                      min: 0,
                      max: maxAccel,
                      onChanged: (double value) {
                        setState(() {
                          defaultMaxAccel = value;
                          for (var element in beziers) {
                            element.pathMaxAccel = value;
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
              SingleChildScrollView(
                child: SizedBox(
                  height: 300,
                  width: 600,
                  child: ListView.builder(
                      itemCount: beziers.length,
                      itemBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: 30,
                          width: 600,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MouseRegion(
                                onEnter: (value) {
                                  setState(() {
                                    beziers[index].focused = true;
                                  });
                                },
                                onExit: (value) {
                                  setState(() {
                                    beziers[index].focused = false;
                                  });
                                },
                                child: Switch(
                                  value: beziers[index].visible,
                                  onChanged: (bool value) {
                                    setState(() {
                                      beziers[index].visible = value;
                                      allVisible = beziers.any((element) {
                                        return element.visible;
                                      });
                                    });
                                  },
                                ),
                              ),
                              Switch(
                                value: beziers[index].stopEnd,
                                onChanged: (bool value) {
                                  setState(() {
                                    beziers[index].stopEnd = value;
                                  });
                                },
                              ),
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
                                  divisions: maxSpeed.toInt(),
                                  label: beziers[index]
                                      .pathMaxSpeed
                                      .round()
                                      .toString(),
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
                                  divisions: maxAccel.toInt(),
                                  label: beziers[index]
                                      .pathMaxAccel
                                      .round()
                                      .toString(),
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
      ),
    );
  }

  String getData() {
    String encoded = const JsonEncoder.withIndent('  ').convert(toJson());
    widget.stringConsumer.call(encoded);
    return encoded;
  }

  Map<String, dynamic> toJson() {
    return {
      "startSpeed": startSpeed,
      "endSpeed": endSpeed,
      "segments": beziers,
      "commands": commands,
    };
  }

  void setData(String data) {
    setState(() {
      final parsedData = jsonDecode(data) as Map<String, dynamic>;

      startSpeed = parsedData.containsKey("startSpeed") ? parsedData["startSpeed"] : 0.0;
      endSpeed = parsedData.containsKey("endSpeed") ? parsedData["endSpeed"] : 0.0;

      List<Bezier> newBeziers = [];
      List<Command> newCommands = [];

      for (var bezier in parsedData['segments']) {
        newBeziers.add(Bezier.fromJson(bezier));
      }

      for (var command in parsedData['commands']) {
        newCommands.add(Command.fromJson(command));
      }

      beziers = newBeziers;
      commands = newCommands;
    });
  }
}
