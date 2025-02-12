import 'package:flutter/material.dart';
import 'package:ophd/data/app_themes.dart';
import 'package:ophd/data/pages.dart';
import 'package:ophd/models/page.dart';
import 'package:ophd/providers/locale_provider.dart';
import 'package:ophd/widgets/layout.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) =>
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: ThemeProvider(
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
        themes: themes,
        child: ThemeConsumer(
          child: Builder(
            builder: (themeContext) => Consumer<LocaleProvider>(
              builder: (context, localeProvider, _) => MaterialApp(
                theme: ThemeProvider.themeOf(themeContext).data,
                title: "Ofek PhD Portfolio",
                initialRoute: '/about',
                routes: {
                  for (PageDetails pd in pages)
                    pd.pathname: (context) => Layout(pageDetails: pd),
                },
                onUnknownRoute: (settings) => MaterialPageRoute(
                  builder: (context) => Layout(pageDetails: pages.first),
                ),
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                locale: localeProvider.locale,
              ),
            ),
          ),
        ),
      ),
    );
}
