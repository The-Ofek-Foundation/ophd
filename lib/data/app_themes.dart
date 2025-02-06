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
    id: 'dark',
    description: 'Dark Theme',
    data: MaterialTheme(TextTheme()).dark(),
  ),
];
