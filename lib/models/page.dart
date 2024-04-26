import 'package:flutter/material.dart';

class PageDetails {
  final IconData icon;
  final String label;
  final Widget page;
  final String route;
  final int index;

  PageDetails({
    required this.icon,
    required this.label,
    required this.page,
    required this.route,
    required this.index,
  });
}
