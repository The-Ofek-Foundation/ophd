import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ophd/screens/research_screen.dart';
import 'package:theme_provider/theme_provider.dart';
import 'color_schemes.g.dart';

import 'package:ophd/screens/education_screen.dart';
import 'package:ophd/screens/about_screen.dart';
import 'package:ophd/screens/publication_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      saveThemesOnChange: true,
      loadThemeOnInit: false,
      onInitCallback: (controller, previouslySavedThemeFuture) async {
        final view = View.of(context);
        String? savedTheme = await previouslySavedThemeFuture;
        if (savedTheme != null) {
          controller.setTheme(savedTheme);
        } else {
          Brightness platformBrightness =
              // ignore: use_build_context_synchronously
              view.platformDispatcher.platformBrightness;
          if (platformBrightness == Brightness.dark) {
            controller.setTheme('dark');
          } else {
            controller.setTheme('light');
          }
          controller.forgetSavedTheme();
        }
      },
      themes: <AppTheme>[
        AppTheme(
          id: 'light',
          description: 'Light Theme',
          data: ThemeData(
            useMaterial3: true,
            colorScheme: lightColorScheme,
          ),
        ),
        AppTheme(
          id: 'dark',
          description: 'Dark Theme',
          data: ThemeData(
            useMaterial3: true,
            colorScheme: darkColorScheme,
          ),
        ),
      ],
      child: ThemeConsumer(
        child: Builder(
          builder: (themeContext) => MaterialApp(
            theme: ThemeProvider.themeOf(themeContext).data,
            title: 'Ofek PhD Portfolio',
            home: const MyLayout(),
          ),
        ),
      ),
    );
  }
}

class MyLayout extends StatefulWidget {
  const MyLayout({super.key});

  @override
  State<MyLayout> createState() => _MyLayoutState();
}

class _MyLayoutState extends State<MyLayout> {
  int _selectedIndex = 0;
  bool _isDarkMode = false;

  final List<dynamic> pageIconsAndLabels = [
    {
      'icon': const Icon(Icons.account_circle),
      'label': const Text('About'),
      'page': const AboutPage(),
    },
    {
      'icon': const Icon(Icons.science),
      'label': const Text('Research'),
      'page': const ResearchPage(),
    },
    {
      // 'icon': const Icon(Icons.history_edu),
      'icon': const Icon(FontAwesomeIcons.scroll),
      'label': const Text('Publications'),
      'page': const PublicationPage(),
    },
    {
      'icon': const Icon(Icons.school),
      'label': const Text('Education'),
      'page': const EducationPage(),
    },
    {
      'icon': const Icon(Icons.contact_mail),
      'label': const Text('Contact'),
      'page': const AboutPage(),
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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

    return Switch(
      value: _isDarkMode,
      onChanged: _toggleThemeMode,
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
                        selectedIndex: _selectedIndex,
                        onDestinationSelected: _onItemTapped,
                        labelType: NavigationRailLabelType.selected,
                        destinations: [
                          for (var iconAndLabel in pageIconsAndLabels)
                            NavigationRailDestination(
                              icon: iconAndLabel['icon'],
                              label: iconAndLabel['label'],
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
                  child: Center(child: _getPageAtIndex(_selectedIndex)),
                )
              ],
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
            title: const Text('Ofek PhD Portfolio'),
            // add color
            backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
            actions: <Widget>[
              _getThemeSwitch()
            ],
          ),
            body: Center(
              child: _getPageAtIndex(_selectedIndex),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                for (var iconAndLabel in pageIconsAndLabels)
                  BottomNavigationBarItem(
                    icon: iconAndLabel['icon'],
                    label: iconAndLabel['label'].data,
                  ),
              ],
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              selectedItemColor: Theme.of(context).colorScheme.primary,
              unselectedItemColor: Theme.of(context).colorScheme.secondary,
              
            ),
          );
        }
      },
    );
  }

  Widget _getPageAtIndex(int index) {
    if (index < pageIconsAndLabels.length) {
      return pageIconsAndLabels[index]['page'];
    } else {
      return const Text('Page not found');
    }
  }
}
