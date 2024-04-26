import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:ophd/data/pages_data.dart';
import 'package:ophd/models/page.dart';
import 'package:theme_provider/theme_provider.dart';
import 'color_schemes.g.dart';

void main() {
  usePathUrlStrategy();
  runApp(const MyApp());
}

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
            routes: {
              for (PageDetails pd in pages)
                pd.route: (context) => MyLayout(pageDetails: pd),
            }
          ),
        ),
      ),
    );
  }
}

class MyLayout extends StatefulWidget {
  final PageDetails pageDetails;

  const MyLayout({Key? key, required this.pageDetails}) : super(key: key);

  @override
  State<MyLayout> createState() => _MyLayoutState(); 
}

class _MyLayoutState extends State<MyLayout> {
  PageDetails _pd = pages[0];
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

    Navigator.pushNamed(context, _pd.route);
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
