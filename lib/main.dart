import 'package:flutter/material.dart';
import 'package:ophd/data/pages_data.dart';
import 'package:ophd/models/page.dart';
import 'package:ophd/widgets/layout.dart';
import 'package:theme_provider/theme_provider.dart';
import 'color_schemes.g.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) =>
    ThemeProvider(
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
            initialRoute: '/about',
            routes: {
              for (PageDetails pd in pages)
                pd.pathname: (context) => Layout(pageDetails: pd),
            },
            onUnknownRoute: (settings) => MaterialPageRoute(
              builder: (context) => Layout(pageDetails: pages.first),
            )
          ),
        ),
      ),
    );
}

