
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:ophd/data/pages.dart';
import 'package:ophd/models/page.dart';
import 'package:theme_provider/theme_provider.dart';

class Layout extends StatefulWidget {
  final PageDetails pageDetails;

  const Layout({Key? key, required this.pageDetails}) : super(key: key);

  @override
  State<Layout> createState() => _LayoutState(); 
}

class _LayoutState extends State<Layout> {
  late PageDetails _pd;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _pd = widget.pageDetails;
  }

  void _onItemTapped(int index) {
    if (_pd.index == index) return;

    setState(() {
      _pd = pages[index];
    });

    window.history.replaceState(null, _pd.label, '/#${_pd.pathname}'); 
  }

  void _toggleThemeMode(bool isDarkTheme) {
    var controller = ThemeProvider.controllerOf(context);

    controller.setTheme(isDarkTheme ? 'dark' : 'light');
    setState(() {
      _isDarkMode = isDarkTheme;
    });
  }

  Widget _getThemeSwitch() {
    _isDarkMode = ThemeProvider.themeOf(context).id == 'dark';

    final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return const Icon(Icons.dark_mode);
          }
          return const Icon(Icons.light_mode);
        },
      );

    return Switch(
      value: _isDarkMode,
      onChanged: _toggleThemeMode,
      thumbIcon: thumbIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return Scaffold(
            body: Row(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: NavigationRail(
                        selectedIndex: _pd.index,
                        onDestinationSelected: _onItemTapped,
                        labelType: NavigationRailLabelType.selected,
                        destinations: [
                          for (PageDetails pd in pages)
                            NavigationRailDestination(
                              icon: Icon(pd.icon),
                              label: Text(pd.label),
                            ),
                        ],
                      ),
                    ),
                    _getThemeSwitch(),
                    const SizedBox(height: 10),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(
                  child: Center(child: _pd.page),
                )
              ],
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
            title: const Text('Ofek PhD Portfolio'),
            backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
            actions: <Widget>[
              _getThemeSwitch()
            ],
          ),
            body: Center(
              child: _pd.page,
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                for (PageDetails pd in pages)
                  BottomNavigationBarItem(
                    icon: Icon(pd.icon),
                    label: pd.label,
                  ),
              ],
              currentIndex: _pd.index,
              onTap: _onItemTapped,
              selectedItemColor: Theme.of(context).colorScheme.primary,
              unselectedItemColor: Theme.of(context).colorScheme.secondary,
            ),
          );
        }
      },
    );
  }
}