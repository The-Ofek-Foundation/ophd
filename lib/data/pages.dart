import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ophd/data/social_links.dart';
import 'package:ophd/models/page.dart';
import 'package:ophd/models/social_link.dart';
import 'package:ophd/screens/about_screen.dart';
import 'package:ophd/screens/education_screen.dart';
import 'package:ophd/screens/industry_screen.dart';
import 'package:ophd/screens/lab_screen.dart';
import 'package:ophd/screens/publication_screen.dart';
import 'package:ophd/screens/research_screen.dart';

final List<PageDetails> pages = [
  PageDetails(
    icon: Icons.account_circle,
    label: 'About',
    page: AboutPage(socials: socials.where((social) => social.isMain).toList()),
    pathname: '/about',
    index: 0
  ),
  PageDetails(
    icon: Icons.science,
    label: 'Research',
    page: const ResearchPage(),
    pathname: '/research',
    index: 1
  ),
  PageDetails(
    icon: FontAwesomeIcons.scroll,
    label: 'Publications',
    page: const PublicationPage(),
    pathname: '/publications',
    index: 2
  ),
  PageDetails(
    icon: Icons.school,
    label: 'Education',
    page: const EducationPage(),
    pathname: '/education',
    index: 3
  ),
  PageDetails(
    icon: Icons.work,
    label: 'Industry',
    page: const IndustryPage(),
    pathname: '/industry',
    index: 4
  ),
  PageDetails(
    icon: Icons.groups,
    label: 'Lab',
    page: const LabPage(),
    pathname: '/lab',
    index: 5
  ),
  PageDetails(
    icon: Icons.contact_mail,
    label: 'Contact',
    page: AboutPage(socials: socials.where((social) => social.types.contains(SocialType.contact)).toList()),
    pathname: '/contact',
    index: 6
  ),
];

final Map<String, PageDetails> pagesMap = Map.fromEntries(
  pages.map((page) => MapEntry(page.pathname, page))
);