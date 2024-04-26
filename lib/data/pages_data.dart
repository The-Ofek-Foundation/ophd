import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:ophd/models/page.dart';
import 'package:ophd/screens/about_screen.dart';
import 'package:ophd/screens/education_screen.dart';
import 'package:ophd/screens/publication_screen.dart';
import 'package:ophd/screens/research_screen.dart';

final List<PageDetails> pages = [
  PageDetails(
    icon: Icons.account_circle,
    label: 'About',
    page: const AboutPage(),
    route: '/',
    index: 0
  ),
  PageDetails(
    icon: Icons.science,
    label: 'Research',
    page: const ResearchPage(),
    route: '/research',
    index: 1
  ),
  PageDetails(
    icon: FontAwesomeIcons.scroll,
    label: 'Publications',
    page: const PublicationPage(),
    route: '/publications',
    index: 2
  ),
  PageDetails(
    icon: Icons.school,
    label: 'Education',
    page: const EducationPage(),
    route: '/education',
    index: 3
  ),
  PageDetails(
    icon: Icons.contact_mail,
    label: 'Contact',
    page: const AboutPage(),
    route: '/contact',
    index: 4
  ),
];