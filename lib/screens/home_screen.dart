import 'dart:ffi';

import 'package:al_planner/screens/pathing_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'dart:io';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  static const List<File> _fileOptions = <File>[];
  String currentJson = "";

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.secondary),
      body: PlatformMenuBar(
        menus: <PlatformMenuItem> [
          PlatformMenu(
              label: "AL Planner",
              menus: <PlatformMenuItem>[
                if (PlatformProvidedMenuItem.hasMenu(PlatformProvidedMenuItemType.about))
                  const PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.about),
                if (PlatformProvidedMenuItem.hasMenu(PlatformProvidedMenuItemType.quit))
                  const PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.quit),
              ]
          ),
          PlatformMenu(
              label: "File",
              menus: [
                PlatformMenuItem(label: "Open Project",
                onSelected: () {

                },
                shortcut: const SingleActivator(LogicalKeyboardKey.keyO,
                    meta: true)),
                PlatformMenuItem(label: "Save file",
                    onSelected: () {
                      if (_fileOptions.isNotEmpty) {
                        File file = _fileOptions[_selectedIndex];
                        file.writeAsStringSync(currentJson, flush: true);
                      }
                    },
                    shortcut: const SingleActivator(LogicalKeyboardKey.keyS,
                        meta: true)
                ),
              ]
          ),
        ],
        child: PathingScreen(_fileOptions[_selectedIndex], (String value) => currentJson = value),
      ),
      drawer: Drawer(
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(basename(_fileOptions[index].path)),
              selected: _selectedIndex == index,
              onTap: () {
                _onItemTapped(index);
              },
            );
          },
          itemCount: _fileOptions.length,
        ),
      ),
    );
  }
}
