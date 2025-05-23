import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  // --- OKABE-ITO INSPIRED CHART COLORS (7 Colors) ---
  // Light Mode
  static const Color okabeItoOrangeLight = Color(0xFFE69F00);
  static const Color okabeItoSkyBlueLight = Color(0xFF56B4E9);
  static const Color okabeItoBluishGreenLight = Color(0xFF009E73);
  static const Color okabeItoYellowLight = Color(0xFFF0E442);
  static const Color okabeItoBlueLight = Color(0xFF0072B2);
  static const Color okabeItoVermillionLight = Color(0xFFD55E00);
  static const Color okabeItoReddishPurpleLight = Color(0xFFCC79A7);

  // Dark Mode
  static const Color okabeItoOrangeDark = Color(0xFFF3A712);
  static const Color okabeItoSkyBlueDark = Color(0xFF65C2F0);
  static const Color okabeItoBluishGreenDark = Color(0xFF00B08A);
  static const Color okabeItoYellowDark = Color(0xFFF8EB56);
  static const Color okabeItoBlueDark = Color(0xFF0082C8);
  static const Color okabeItoVermillionDark = Color(0xFFE06C0F);
  static const Color okabeItoReddishPurpleDark = Color(0xFFD88BCF);

  List<Color> getOkabeItoChartColorList(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    if (brightness == Brightness.dark) {
      return [
        okabeItoReddishPurpleDark, // 7
        okabeItoBluishGreenDark, // 3
        okabeItoOrangeDark,      // 1
        okabeItoVermillionDark,  // 6
        okabeItoSkyBlueDark,     // 2
        okabeItoYellowDark,      // 4
        okabeItoBlueDark,        // 5
      ];
    } else {
      return [
        okabeItoReddishPurpleLight,
        okabeItoBluishGreenLight,
        okabeItoOrangeLight,
        okabeItoVermillionLight,
        okabeItoSkyBlueLight,
        okabeItoYellowLight,
        okabeItoBlueLight,
      ];
    }
  }

  // --- REVISED PASTEL OKABE-ITO INSPIRED CHART COLORS (7 Colors) ---
  // Light Mode - Pastel & Shifted
  static const Color pastelChartColor1Light = Color(0xFFF3C88C); // Soft Gold
  static const Color pastelChartColor2Light = Color(0xFF99D6F0); // Pastel Sky Blue
  static const Color pastelChartColor3Light = Color(0xFF87D9C2); // Minty Aqua
  static const Color pastelChartColor4Light = Color(0xFFFDF0A0); // Pale Yellow
  static const Color pastelChartColor5Light = Color(0xFF8EADDD); // Dusty Blue
  static const Color pastelChartColor6Light = Color(0xFFFFAAA5); // Pastel Coral
  static const Color pastelChartColor7Light = Color(0xFFE0B6D9); // Soft Lavender

  // Dark Mode - Pastel & Shifted (adjusted for dark backgrounds)
  static const Color pastelChartColor1Dark = Color(0xFFE7BC7F); // Soft Gold
  static const Color pastelChartColor2Dark = Color(0xFF8BC9E6); // Pastel Sky Blue
  static const Color pastelChartColor3Dark = Color(0xFF75C7B0); // Minty Aqua
  static const Color pastelChartColor4Dark = Color(0xFFFBEAA0); // Pale Yellow
  static const Color pastelChartColor5Dark = Color(0xFF82A0D3); // Dusty Blue
  static const Color pastelChartColor6Dark = Color(0xFFF89F99); // Pastel Coral
  static const Color pastelChartColor7Dark = Color(0xFFD8A9CF); // Soft Lavender

  static const Color onPastelChartColor = Color(0xFF000000); // Text color for pastel chart colors

  List<Color> getPastelChartColorList(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    if (brightness == Brightness.dark) {
      return [
        pastelChartColor7Dark,
        pastelChartColor3Dark,
        pastelChartColor1Dark,
        pastelChartColor6Dark,
        pastelChartColor2Dark,
        pastelChartColor4Dark,
        pastelChartColor5Dark,
      ];
    } else {
      return [
        pastelChartColor7Light,
        pastelChartColor3Light,
        pastelChartColor1Light,
        pastelChartColor6Light,
        pastelChartColor2Light,
        pastelChartColor4Light,
        pastelChartColor5Light,
      ];
    }
  }

  /// Returns a pastel chart color from the revised palette
  /// based on the given index.
  /// Uses modulus to cycle through colors if index exceeds the palette size (7).
  Color getPastelChartColorByIndex(BuildContext context, int index) {
    final chartColors = getPastelChartColorList(context);
    if (chartColors.isEmpty) {
      // Fallback, though it shouldn't happen with this setup.
      return Colors.grey;
    }
    return chartColors[index % chartColors.length];
  }

  Color getOkabeItoChartColorByIndex(BuildContext context, int index) {
    final chartColors = getOkabeItoChartColorList(context);
    if (chartColors.isEmpty) {
      // Fallback if the list is somehow empty, though it shouldn't be.
      return Colors.grey;
    }
    return chartColors[index % chartColors.length];
  }

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff146683),
      surfaceTint: Color(0xff146683),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffbfe9ff),
      onPrimaryContainer: Color(0xff004d65),
      secondary: Color(0xff166683),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffc0e8ff),
      onSecondaryContainer: Color(0xff004d66),
      tertiary: Color(0xff8e4958),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffffd9de),
      onTertiaryContainer: Color(0xff713341),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfff6fafe),
      onSurface: Color(0xff171c1f),
      onSurfaceVariant: Color(0xff40484c),
      outline: Color(0xff70787d),
      outlineVariant: Color(0xffc0c8cd),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2c3134),
      inversePrimary: Color(0xff8ccff0),
      primaryFixed: Color(0xffbfe9ff),
      onPrimaryFixed: Color(0xff001f2a),
      primaryFixedDim: Color(0xff8ccff0),
      onPrimaryFixedVariant: Color(0xff004d65),
      secondaryFixed: Color(0xffc0e8ff),
      onSecondaryFixed: Color(0xff001e2b),
      secondaryFixedDim: Color(0xff8dcff1),
      onSecondaryFixedVariant: Color(0xff004d66),
      tertiaryFixed: Color(0xffffd9de),
      onTertiaryFixed: Color(0xff3a0717),
      tertiaryFixedDim: Color(0xffffb2bf),
      onTertiaryFixedVariant: Color(0xff713341),
      surfaceDim: Color(0xffd6dade),
      surfaceBright: Color(0xfff6fafe),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff0f4f8),
      surfaceContainer: Color(0xffeaeef2),
      surfaceContainerHigh: Color(0xffe4e9ec),
      surfaceContainerHighest: Color(0xffdfe3e7),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff003b4f),
      surfaceTint: Color(0xff146683),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff2b7592),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff003b4f),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff2c7593),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff5d2231),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff9f5866),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff6fafe),
      onSurface: Color(0xff0d1215),
      onSurfaceVariant: Color(0xff30373c),
      outline: Color(0xff4c5458),
      outlineVariant: Color(0xff666e73),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2c3134),
      inversePrimary: Color(0xff8ccff0),
      primaryFixed: Color(0xff2b7592),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff005c78),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff2c7593),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff005c79),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff9f5866),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff82404f),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc3c7cb),
      surfaceBright: Color(0xfff6fafe),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff0f4f8),
      surfaceContainer: Color(0xffe4e9ec),
      surfaceContainerHigh: Color(0xffd9dde1),
      surfaceContainerHighest: Color(0xffced2d6),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff003041),
      surfaceTint: Color(0xff146683),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff004f68),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff003041),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff004f69),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff501827),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff743543),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff6fafe),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff262d31),
      outlineVariant: Color(0xff434a4f),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2c3134),
      inversePrimary: Color(0xff8ccff0),
      primaryFixed: Color(0xff004f68),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff00374a),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff004f69),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff00374a),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff743543),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff581f2d),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffb5b9bd),
      surfaceBright: Color(0xfff6fafe),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffedf1f5),
      surfaceContainer: Color(0xffdfe3e7),
      surfaceContainerHigh: Color(0xffd1d5d9),
      surfaceContainerHighest: Color(0xffc3c7cb),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff8ccff0),
      surfaceTint: Color(0xff8ccff0),
      onPrimary: Color(0xff003547),
      primaryContainer: Color(0xff004d65),
      onPrimaryContainer: Color(0xffbfe9ff),
      secondary: Color(0xff8dcff1),
      onSecondary: Color(0xff003547),
      secondaryContainer: Color(0xff004d66),
      onSecondaryContainer: Color(0xffc0e8ff),
      tertiary: Color(0xffffb2bf),
      onTertiary: Color(0xff561d2b),
      tertiaryContainer: Color(0xff713341),
      onTertiaryContainer: Color(0xffffd9de),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff0f1417),
      onSurface: Color(0xffdfe3e7),
      onSurfaceVariant: Color(0xffc0c8cd),
      outline: Color(0xff8a9297),
      outlineVariant: Color(0xff40484c),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdfe3e7),
      inversePrimary: Color(0xff146683),
      primaryFixed: Color(0xffbfe9ff),
      onPrimaryFixed: Color(0xff001f2a),
      primaryFixedDim: Color(0xff8ccff0),
      onPrimaryFixedVariant: Color(0xff004d65),
      secondaryFixed: Color(0xffc0e8ff),
      onSecondaryFixed: Color(0xff001e2b),
      secondaryFixedDim: Color(0xff8dcff1),
      onSecondaryFixedVariant: Color(0xff004d66),
      tertiaryFixed: Color(0xffffd9de),
      onTertiaryFixed: Color(0xff3a0717),
      tertiaryFixedDim: Color(0xffffb2bf),
      onTertiaryFixedVariant: Color(0xff713341),
      surfaceDim: Color(0xff0f1417),
      surfaceBright: Color(0xff353a3d),
      surfaceContainerLowest: Color(0xff0a0f12),
      surfaceContainerLow: Color(0xff171c1f),
      surfaceContainer: Color(0xff1b2023),
      surfaceContainerHigh: Color(0xff262b2e),
      surfaceContainerHighest: Color(0xff303538),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffafe4ff),
      surfaceTint: Color(0xff8ccff0),
      onPrimary: Color(0xff002938),
      primaryContainer: Color(0xff5499b8),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffb0e3ff),
      onSecondary: Color(0xff002938),
      secondaryContainer: Color(0xff5599b8),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffffd1d8),
      onTertiary: Color(0xff481221),
      tertiaryContainer: Color(0xffc87a89),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff0f1417),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffd6dde3),
      outline: Color(0xffabb3b8),
      outlineVariant: Color(0xff8a9196),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdfe3e7),
      inversePrimary: Color(0xff004e67),
      primaryFixed: Color(0xffbfe9ff),
      onPrimaryFixed: Color(0xff00131c),
      primaryFixedDim: Color(0xff8ccff0),
      onPrimaryFixedVariant: Color(0xff003b4f),
      secondaryFixed: Color(0xffc0e8ff),
      onSecondaryFixed: Color(0xff00131c),
      secondaryFixedDim: Color(0xff8dcff1),
      onSecondaryFixedVariant: Color(0xff003b4f),
      tertiaryFixed: Color(0xffffd9de),
      onTertiaryFixed: Color(0xff2c000d),
      tertiaryFixedDim: Color(0xffffb2bf),
      onTertiaryFixedVariant: Color(0xff5d2231),
      surfaceDim: Color(0xff0f1417),
      surfaceBright: Color(0xff404548),
      surfaceContainerLowest: Color(0xff04080a),
      surfaceContainerLow: Color(0xff191e21),
      surfaceContainer: Color(0xff24292b),
      surfaceContainerHigh: Color(0xff2e3336),
      surfaceContainerHighest: Color(0xff393e41),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffdff3ff),
      surfaceTint: Color(0xff8ccff0),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xff88cbec),
      onPrimaryContainer: Color(0xff000d14),
      secondary: Color(0xffdff3ff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xff89cbed),
      onSecondaryContainer: Color(0xff000d14),
      tertiary: Color(0xffffebed),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffffacbb),
      onTertiaryContainer: Color(0xff210008),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff0f1417),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffeaf1f6),
      outlineVariant: Color(0xffbcc4c9),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdfe3e7),
      inversePrimary: Color(0xff004e67),
      primaryFixed: Color(0xffbfe9ff),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xff8ccff0),
      onPrimaryFixedVariant: Color(0xff00131c),
      secondaryFixed: Color(0xffc0e8ff),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xff8dcff1),
      onSecondaryFixedVariant: Color(0xff00131c),
      tertiaryFixed: Color(0xffffd9de),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffffb2bf),
      onTertiaryFixedVariant: Color(0xff2c000d),
      surfaceDim: Color(0xff0f1417),
      surfaceBright: Color(0xff4c5154),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff1b2023),
      surfaceContainer: Color(0xff2c3134),
      surfaceContainerHigh: Color(0xff373c3f),
      surfaceContainerHighest: Color(0xff42474b),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
     useMaterial3: true,
     brightness: colorScheme.brightness,
     colorScheme: colorScheme,
     textTheme: textTheme.apply(
       bodyColor: colorScheme.onSurface,
       displayColor: colorScheme.onSurface,
     ),
     scaffoldBackgroundColor: colorScheme.surface,
     canvasColor: colorScheme.surface,
  );


  List<ExtendedColor> get extendedColors => [
  ];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}