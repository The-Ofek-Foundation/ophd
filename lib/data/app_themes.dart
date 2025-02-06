import 'package:flutter/material.dart';
import 'package:ophd/theme.dart';
import 'package:theme_provider/theme_provider.dart';

final List<AppTheme> themes = [
  AppTheme(
    id: 'light',
    description: 'Light Theme',
    data: MaterialTheme(TextTheme()).light(),
  ),
  AppTheme(
    id: 'light-medium-contrast',
    description: 'Light Theme Medium Contrast',
    data: MaterialTheme(TextTheme()).lightMediumContrast(),
  ),
  AppTheme(
    id: 'light-high-contrast',
    description: 'Light Theme High Contrast',
    data: MaterialTheme(TextTheme()).lightHighContrast(),
  ),
  AppTheme(
    id: 'dark',
    description: 'Dark Theme',
    data: MaterialTheme(TextTheme()).dark(),
  ),
  AppTheme(
    id: 'dark-medium-contrast',
    description: 'Dark Theme Medium Contrast',
    data: MaterialTheme(TextTheme()).darkMediumContrast(),
  ),
  AppTheme(
    id: 'dark-high-contrast',
    description: 'Dark Theme High Contrast',
    data: MaterialTheme(TextTheme()).darkHighContrast(),
  ),
];
