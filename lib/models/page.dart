import 'package:flutter/material.dart';

class PageDetails {
  final IconData icon;
  final String label;
  final Widget page;
  final String pathname;
  final int index;

  PageDetails({
    required this.icon,
    required this.label,
    required this.page,
    required this.pathname,
    required this.index,
  });
}
