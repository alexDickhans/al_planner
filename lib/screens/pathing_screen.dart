import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:al_planner/screens/path_drawer.dart';
import 'package:al_planner/src/rust/third_party/motion_profiling/path.dart' as path;
import 'package:al_planner/utils/double.dart';
import 'package:al_planner/utils/robot.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:simple_line_chart/simple_line_chart.dart';
import 'dart:io';

import '../utils/bezier.dart';
import '../utils/point.dart';

import '../src/rust/api/simple.dart';
import '../src/rust/frb_generated.dart';

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
  bool liveRobot = true;

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
  bool isSkills = false;
  double _time = 0.0;
  LineChartData _data = LineChartData(datasets: [Dataset(label: "Velocity", dataPoints: <DataPoint>[])]);
  LineChartData _data_angular = LineChartData(datasets: [Dataset(label: "Velocity", dataPoints: <DataPoint>[])]);

  // Define a Timer object
  bool _play = false;
  Duration _duration = const Duration();
  Duration lastTime = const Duration();

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
          }).listen((event) {
        print(event.data!);
        if (!event.data!.contains("#")) {
          var jData = jsonDecode(event.data!);
          print(jData);

          setState(() {
            robots.clear();
            for (var robot in jData) {
              robots.add(RobotPosition(robot[0], robot[1], robot[2]));
            }
          });
        }
      }, onError: (error) {}, onDone: () {});
    }


    _scheduleTick();
  }

  @override
  void didUpdateWidget(PathingScreen old) {
    super.didUpdateWidget(old);
    updateFile();
  }

  void startTimer() {
    if (_duration.inMilliseconds >= _time * 1000.0) {
      _duration = const Duration();
    }
    _play = true;
  }

  void _scheduleTick() {
    SchedulerBinding.instance.scheduleFrameCallback((timestamp) {frameCallback(timestamp);});
  }

  void frameCallback(Duration timeinfo) {
    Duration interval = timeinfo - lastTime;
    lastTime = timeinfo;

    if (_duration.inMilliseconds >= _time * 1000.0 || !_play) {
      // Countdown is finished
      setState(() {
        _play = false;
      });
      // Perform any desired action when the countdown is completed
    } else {
      // Update the countdown value and decrement by 1 second
      setState(() {
        _duration = _duration + interval;
        robots = [getPoseTime()];
      });
    }

    _scheduleTick();
  }

  RobotPosition getPoseTime() {
    var pose = getPose(t: _duration.inMilliseconds /1000.0);

    return RobotPosition(pose.x, pose.y, pose.theta);
  }

  void stopTimer() {
    _play = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFEFEFE),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: IconButton.filledTonal(
                        isSelected: isSkills,
                        icon: const Icon(Icons.groups),
                        selectedIcon: const Icon(Icons.person),
                        onPressed: () {
                          setState(() {
                            isSkills = !isSkills;
                          });
                        }),
                  ),
                  Expanded(
                    child: Slider(
                      value: startSpeed,
                      label: startSpeed.round().toString(),
                      divisions: 12,
                      min: -maxSpeed,
                      max: maxSpeed,
                      onChanged: (double value) {
                        setState(() {
                          startSpeed = value;
                          _buildTime();
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: Slider(
                      value: endSpeed,
                      label: endSpeed.round().toString(),
                      divisions: 12,
                      min: -maxSpeed,
                      max: maxSpeed,
                      onChanged: (double value) {
                        setState(() {
                          endSpeed = value;
                          _buildTime();
                        });
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: IconButton.filledTonal(
                        isSelected: _play,
                        icon: const Icon(Icons.play_arrow),
                        selectedIcon: const Icon(Icons.pause),
                        onPressed: () {
                          setState(() {
                            if (!_play) {
                              startTimer();
                            } else {
                              stopTimer();
                            }
                          });
                        }),
                  ),
                  Expanded(
                    child: Slider(
                      min: 0.0,
                        max: _time,
                        value: clampDouble(_duration.inMilliseconds / 1000.0, 0.0, _time),
                        onChanged: (value) {
                          setState(() {
                            _duration = Duration(milliseconds: (value * 1000.0).toInt());
                            robots = [getPoseTime()];
                          });
                        }),
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
                                  if (HardwareKeyboard.instance
                                      .isPhysicalKeyPressed(
                                          PhysicalKeyboardKey.shiftLeft)) {
                                    var newBeziers = beziers;

                                    newBeziers.removeWhere((element) {
                                      return element.isOver(
                                          details, context.size!);
                                    });

                                    setState(() {
                                      beziers = newBeziers;
                                      _buildTime();
                                    });
                                  }
                                },
                                onPanUpdate: (details) {
                                  if (HardwareKeyboard.instance
                                      .isPhysicalKeyPressed(
                                          PhysicalKeyboardKey.shiftLeft)) {
                                    var newBeziers = beziers;

                                    newBeziers.removeWhere((element) {
                                      return element.isOver(
                                          details, context.size!);
                                    });

                                    setState(() {
                                      beziers = newBeziers;
                                      _buildTime();
                                    });
                                  } else {
                                    setState(() {
                                      for (var i = 0; i < beziers.length; i++) {
                                        switch (beziers[i].move(details, context.size!)) {
                                          case 2:
                                            if (i > 0) {
                                              var mag = beziers[i-1].p4.minus(beziers[i-1].p3).magnitude();
                                              var unit = beziers[i].p1.minus(beziers[i].p2).norm().times(beziers[i-1].reversed ^ beziers[i].reversed ? -1.0 : 1.0);
                                              beziers[i-1].p3 = beziers[i-1].p4.plus(unit.times(mag));
                                            }
                                            break;
                                          case 3:
                                            if (i < beziers.length - 1) {
                                              var mag = beziers[i+1].p1.minus(beziers[i+1].p2).magnitude();
                                              var unit = beziers[i].p4.minus(beziers[i].p3).norm().times(beziers[i+1].reversed ^ beziers[i].reversed ? -1.0 : 1.0);
                                              beziers[i+1].p2 = beziers[i+1].p1.plus(unit.times(mag));
                                            }
                                            break;
                                          default:
                                        }
                                      }
                                      _buildTime();
                                    });
                                  }
                                },
                                onDoubleTapDown: (details) {
                                  setState(() {
                                    beziers.add(Bezier(
                                        beziers.isEmpty
                                            ? Point(1.6, 1.6)
                                            : beziers[beziers.length - 1].p4,
                                        beziers.isEmpty
                                            ? Point(0.0, 0.0) :
                                        beziers[beziers.length -1].p3.plus(beziers[beziers.length -1].p3.minus(beziers[beziers.length - 1].p4).times(-2.0)),
                                        beziers.isEmpty
                                            ? Point(0.4, 0.4)
                                            : Point.fromOffset(
                                            details.localPosition, context.size!).midpoint(beziers[beziers.length -1].p3.plus(beziers[beziers.length -1].p3.minus(beziers[beziers.length - 1].p4).times(-2.0))),
                                        Point.fromOffset(
                                            details.localPosition, context.size!),
                                        defaultMaxSpeed,
                                        defaultMaxAccel,
                                        false));
                                    _buildTime();
                                  });
                                },
                                child: CustomPaint(
                                  foregroundPainter: PathDrawer(beziers, robots,
                                      commands.map((e) => e.t).toList()),
                                  child: isSkills
                                      ? Image.asset('assets/skills.png')
                                      : Image.asset('assets/match.png'),
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
              LineChart(
                // chart is styled
                style: LineChartStyle.fromTheme(context),
                seriesHeight: 300,
                // chart has data
                data: _data,
                controller: LineChartController()),
              LineChart(
                // chart is styled
                  style: LineChartStyle.fromTheme(context),
                  seriesHeight: 300,
                  // chart has data
                  data: _data_angular,
                  controller: LineChartController()),
              Column(children: [
                IconButton.filledTonal(
                  onPressed: () {
                    setState(() {
                      commands.add(Command(0.0, "change"));
                    });
                  },
                  icon: const Icon(Icons.add),
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
                                        commands
                                            .sort((a, b) => a.t.compareTo(b.t));
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
      ),
    );
  }

  void _buildTime() {
    _time = getDuration(path: path.Path(
        startSpeed: startSpeed/39.37,
        endSpeed: endSpeed/39.37,
        segments: beziers.map((bezier) => bezier.toPathSegment()).toList(),
        commands: [])).toDouble() / 1000.0;
    
    var velocity = <DataPoint>[];
    var angularVelocity = <DataPoint>[];

    for (int i = 0; i < 20 * beziers.length; i++) {
      var time = i * _time / (20 * beziers.length);

      velocity.add(DataPoint(x: time, y: getVelocity(t: time)));
      angularVelocity.add(DataPoint(x: time, y: getAngularVelocity(t: time)));
    }

    _data = LineChartData(datasets: [Dataset(label: "Velocity", dataPoints: velocity), ]);
    _data_angular = LineChartData(datasets: [Dataset(label: " Angular Velocity", dataPoints: angularVelocity)]);
  }

  Container buildVelConstraints(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Color(0xfff5eddf),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: SizedBox(
        height: 1000,
        width: 100,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Text(
                "Velocity, Accel. Time: $_time",
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 30),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton.filledTonal(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    isSelected: allVisible,
                    icon: const Icon(Icons.visibility_off_outlined),
                    selectedIcon: const Icon(Icons.visibility),
                    onPressed: () {
                      setState(() {
                        allVisible = !allVisible;

                        for (var bezier in beziers) {
                          bezier.visible = allVisible;
                        }
                      });
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      "Default: ",
                      textScaler: TextScaler.linear(2),
                    ),
                  ),
                  Expanded(
                    child: Slider(
                      divisions: maxSpeed.toInt(),
                      label: defaultMaxSpeed.round().toString(),
                      value: defaultMaxSpeed,
                      min: 1.0,
                      max: maxSpeed,
                      onChanged: (double value) {
                        setState(() {
                          defaultMaxSpeed = value;
                          for (var element in beziers) {
                            element.pathMaxSpeed = value;
                          }
                          _buildTime();
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: Slider(
                      divisions: maxAccel.toInt(),
                      label: defaultMaxAccel.round().toString(),
                      value: defaultMaxAccel,
                      min: 1.0,
                      max: maxAccel,
                      onChanged: (double value) {
                        setState(() {
                          defaultMaxAccel = value;
                          for (var element in beziers) {
                            element.pathMaxAccel = value;
                          }
                          _buildTime();
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
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: SizedBox(
                            height: 45,
                            width: 600,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: MouseRegion(
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
                                    child: IconButton.filledTonal(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      isSelected: beziers[index].visible,
                                      icon: const Icon(
                                          Icons.visibility_off_outlined),
                                      selectedIcon:
                                          const Icon(Icons.visibility),
                                      onPressed: () {
                                        setState(() {
                                          beziers[index].visible =
                                              !beziers[index].visible;
                                          allVisible = beziers.any((element) {
                                            return element.visible;
                                          });
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: IconButton.filledTonal(
                                    isSelected: beziers[index].stopEnd,
                                    icon: const Icon(Icons.arrow_right_alt),
                                    selectedIcon:
                                        const Icon(Icons.keyboard_tab),
                                    onPressed: () {
                                      setState(() {
                                        beziers[index].stopEnd =
                                            !beziers[index].stopEnd;
                                        _buildTime();
                                      });
                                    },
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: IconButton.filledTonal(
                                    isSelected: beziers[index].reversed,
                                    icon: const Icon(Icons.arrow_forward),
                                    selectedIcon: const Icon(Icons.arrow_back),
                                    onPressed: () {
                                      setState(() {
                                        beziers[index].reversed =
                                            !beziers[index].reversed;
                                        _buildTime();
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: Slider(
                                    divisions: maxSpeed.toInt(),
                                    label: beziers[index]
                                        .pathMaxSpeed
                                        .round()
                                        .toString(),
                                    value: beziers[index].pathMaxSpeed,
                                    min: 1.0,
                                    max: maxSpeed,
                                    onChanged: (double value) {
                                      setState(() {
                                        beziers[index].pathMaxSpeed = value;
                                        _buildTime();
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
                                    min: 1.0,
                                    max: maxAccel,
                                    onChanged: (double value) {
                                      setState(() {
                                        beziers[index].pathMaxAccel = value;
                                        _buildTime();
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
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
      "start_speed": startSpeed,
      "end_speed": endSpeed,
      "segments": beziers,
      "commands": commands,
    };
  }

  void setData(String data) {
    setState(() {
      final parsedData = jsonDecode(data) as Map<String, dynamic>;

      startSpeed = parsedData.containsKey("start_speed")
          ? parsedData["start_speed"]
          : 0.0;
      endSpeed =
          parsedData.containsKey("end_speed") ? parsedData["end_speed"] : 0.0;

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

      _buildTime();
    });
  }
}
