import 'package:al_planner/screens/home_screen.dart';
import 'package:al_planner/screens/pathing_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme:ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.orange, backgroundColor: const Color(0xfffcf8f2), cardColor: const Color(0xfff3c681)),
      ),
      home: const HomeScreen(),
    );
  }
}
