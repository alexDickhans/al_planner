import 'dart:ffi';

import 'package:al_planner/screens/pathing_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<File> _fileOptions = <File>[];
  String currentJson = "";

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _openDirectory(String? selectedDirectory) {
    if (selectedDirectory == null) {
      return;
    }
    setState(() {
      _fileOptions.clear();
    });

    Directory directory = Directory(selectedDirectory);

    directory.list().listen((event) {
      if(extension(event.path) == '.json') {
        setState(() {
          _fileOptions.add(File(event.path));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.secondary),
      body: PlatformMenuBar(
          menus: <PlatformMenuItem>[
            PlatformMenu(label: "AL Planner", menus: <PlatformMenuItem>[
              if (PlatformProvidedMenuItem.hasMenu(
                  PlatformProvidedMenuItemType.about))
                const PlatformProvidedMenuItem(
                    type: PlatformProvidedMenuItemType.about),
              if (PlatformProvidedMenuItem.hasMenu(
                  PlatformProvidedMenuItemType.quit))
                const PlatformProvidedMenuItem(
                    type: PlatformProvidedMenuItemType.quit),
            ]),
            PlatformMenu(label: "File", menus: [
              PlatformMenuItem(
                  label: "Open Project",
                  onSelected: () {
                    FilePicker.platform
                        .getDirectoryPath()
                        .then((selectedDirectory) {
                      _openDirectory(selectedDirectory);
                    });
                  },
                  shortcut: const SingleActivator(LogicalKeyboardKey.keyO,
                      meta: true)),
              PlatformMenuItem(
                  label: "Save file",
                  onSelected: () {
                    if (_fileOptions.isNotEmpty) {
                      File file = _fileOptions[_selectedIndex];
                      file.writeAsStringSync(currentJson, flush: true);
                    }
                  },
                  shortcut: const SingleActivator(LogicalKeyboardKey.keyS,
                      meta: true)),
              PlatformMenuItem(
                  label: "Save as",
                  onSelected: () {
                    FilePicker.platform
                        .saveFile(
                          dialogTitle: 'Please select an output file:',
                          fileName: 'output-file.json',
                        )
                        .then((outputFile) => {
                              if (outputFile == null)
                                {
                                  // User canceled the picker
                                }
                            });
                  },
                  shortcut: const SingleActivator(LogicalKeyboardKey.keyS,
                      meta: true, shift: true)),
            ]),
          ],
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              if (_fileOptions.isEmpty) {
                return const Text("Choose File!",
                    style: TextStyle(fontSize: 80));
              }
              return PathingScreen(_fileOptions[_selectedIndex],
                  (String value) => currentJson = value);
            },
          )),
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
