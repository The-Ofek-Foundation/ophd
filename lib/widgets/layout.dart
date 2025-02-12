import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ophd/data/pages.dart';
import 'package:ophd/models/page.dart';
import 'package:ophd/providers/locale_provider.dart';
import 'package:ophd/utils/replace_history_state.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Layout extends StatefulWidget {
  final PageDetails pageDetails;

  const Layout({super.key, required this.pageDetails});

  @override
  State<Layout> createState() => LayoutState(); 
}

class LayoutState extends State<Layout> {
  late PageDetails _pd;
  bool _isDarkMode = false;
  int _selectedContrast = 0;

  final List<IconData> _contrastIcons = [
    Icons.brightness_7,
    Icons.brightness_medium,
    Icons.brightness_5,
  ];

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

    replaceHistoryState(_pd.label, '/#${_pd.pathname}');
  }

  Widget _getLocaleSwitch() {
    final localeProvider = Provider.of<LocaleProvider>(context);
    return SizedBox(
      height: 30,
      width: 80,  // Make even more compact
      child: SegmentedButton<String>(
        segments: [
          ButtonSegment<String>(
            value: 'en',
            label: Tooltip(
              message: 'English',
              child: SizedBox(
                width: 24,
                height: 16,
                child: SvgPicture.asset(
                  'assets/images/Flag_of_the_United_States.svg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          ButtonSegment<String>(
            value: 'he',
            label: Tooltip(
              message: 'עברית',
              child: SizedBox(
                width: 24,
                height: 16,
                child: SvgPicture.asset(
                  'assets/images/Flag_of_Israel.svg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
        selected: {localeProvider.locale.languageCode},
        onSelectionChanged: (Set<String> selected) {
          localeProvider.setLocale(selected.first);
        },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return Theme.of(context).colorScheme.primaryContainer;
              }
              return null;
            },
          ),
          foregroundColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return Theme.of(context).colorScheme.onPrimaryContainer;
              }
              return null;
            },
          ),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
          padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 2)),
        ),
        showSelectedIcon: false,
      ),
    );
  }

  void _updateContrastFromTheme() {
    String currentThemeId = ThemeProvider.themeOf(context).id;
    if (currentThemeId.endsWith('-medium-contrast')) {
      _selectedContrast = 1;
    } else if (currentThemeId.endsWith('-high-contrast')) {
      _selectedContrast = 2;
    } else {
      _selectedContrast = 0; // Default to low contrast
    }
  }

  void _updateTheme(bool isDark, int contrast) {
    var controller = ThemeProvider.controllerOf(context);

    String baseTheme = isDark ? 'dark' : 'light';
    String contrastSuffice = contrast == 1 ? '-medium-contrast'
      : contrast == 2 ? '-high-contrast'
      : '';

    controller.setTheme('$baseTheme$contrastSuffice');

    setState(() {
      _isDarkMode = isDark;
      _selectedContrast = contrast;
    });
  }

  void _toggleThemeMode(bool isDark) {
    _updateTheme(isDark, _selectedContrast);
  }

  void _changeContrast() {
    int newContrast = (_selectedContrast + 1) % _contrastIcons.length;
    _updateTheme(_isDarkMode, newContrast);
  }

  Widget _getThemeSwitch() {
    _isDarkMode = ThemeProvider.themeOf(context).id.startsWith('dark');

    final WidgetStateProperty<Icon?> thumbIcon =
      WidgetStateProperty.resolveWith<Icon?>(
        (Set<WidgetState> states)  => 
          states.contains(WidgetState.selected) ? const Icon(Icons.dark_mode)
          : const Icon(Icons.light_mode),
    );

    return Tooltip(
      message: 'Toggle Dark Mode',
      child: Switch(
        value: _isDarkMode,
        onChanged: _toggleThemeMode,
        thumbIcon: thumbIcon,
      ),
    );
  }

  Widget _getContrastSelector() {
  _updateContrastFromTheme();

  return Tooltip(
    message: 'Change Contrast',
      child: Material(
        color: Theme.of(context).colorScheme.tertiary,
        shape: const CircleBorder(),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: _changeContrast,
          hoverColor: Theme.of(context).colorScheme.onTertiary.withAlpha(30),
          splashColor: Theme.of(context).colorScheme.onTertiary.withAlpha(128),
          child: SizedBox(
            width: 30,
            height: 30,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(
                  scale: animation,
                  child: child,
                );
              },
              child: Icon(
                _contrastIcons[_selectedContrast],
                key: ValueKey<IconData>(_contrastIcons[_selectedContrast]),
                color: Theme.of(context).colorScheme.onTertiary,
              ),
            ),
          ),
        ),
      ),
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
                              icon: pd.index == _pd.index ? Icon(pd.icon)
                              : Tooltip(
                                message: AppLocalizations.of(context)!.page(pd.label),
                                child: Icon(pd.icon)
                              ),
                              label: Text(AppLocalizations.of(context)!.page(pd.label)),
                            ),
                        ],
                      ),
                    ),
                    _getLocaleSwitch(),
                    const SizedBox(height: 5),
                    _getThemeSwitch(),
                    const SizedBox(height: 5),
                    _getContrastSelector(),
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
              title: SelectableText(AppLocalizations.of(context)!.title),
              backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
              actions: <Widget>[
                _getLocaleSwitch(),
                _getThemeSwitch(),
                _getContrastSelector(),
                const SizedBox(width: 5),
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