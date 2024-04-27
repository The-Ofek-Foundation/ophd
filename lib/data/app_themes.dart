import 'package:flutter/material.dart';
import 'package:ophd/color_schemes.g.dart';
import 'package:theme_provider/theme_provider.dart';

final List<AppTheme> themes = [
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
];
