import 'package:al_planner/screens/pathing_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    PathingScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).appBarTheme.foregroundColor,),
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
                  // Open file gui
                },
                shortcut: const SingleActivator(LogicalKeyboardKey.keyO,
                    meta: true)),

              ]
          ),
        ],
        child: _widgetOptions[_selectedIndex],
      ),
      backgroundColor: Theme.of(context).colorScheme.background.withOpacity(0.6),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              title: const Text('Path drawing'),
              selected: _selectedIndex == 0,
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
