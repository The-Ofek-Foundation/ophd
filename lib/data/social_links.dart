import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ophd/models/social_link.dart';

final List<SocialLink> socials = [
  SocialLink(
    icon: FontAwesomeIcons.github,
    url: 'https://github.com/ofekih',
    label: 'GitHub',
    isMain: true,
    type: SocialType.code,
  ),
  SocialLink(
    icon: FontAwesomeIcons.linkedin,
    url: 'https://www.linkedin.com/in/ofek-gila/',
    label: 'LinkedIn',
    isMain: true,
    type: SocialType.contact,
  ),
  SocialLink(
    icon: FontAwesomeIcons.envelope,
    url: 'mailto:me@ofek.phd',
    label: 'Email',
    isMain: true,
    type: SocialType.contact,
  ),
  SocialLink(
    icon: FontAwesomeIcons.whatsapp,
    url: 'https://wa.me/14087056117',
    label: 'WhatsApp',
    isMain: false,
    type: SocialType.contact,
  ),
  SocialLink(
    icon: const AssetImage('assets/images/avatar_scholar_256.png'),
    url: 'https://scholar.google.com/citations?hl=en&user=t9s-uKcAAAAJ',
    label: 'Google Scholar',
    isMain: false,
    type: SocialType.research,
  ),
  SocialLink(
    icon: FontAwesomeIcons.orcid,
    url: 'https://orcid.org/0009-0005-5931-771X',
    label: 'ORCiD',
    isMain: true,
    type: SocialType.research,
  ),
  SocialLink(
    icon: Icons.article,
    url: 'https://blog.theofekfoundation.org/',
    label: 'Blog',
    isMain: true,
    type: SocialType.personal,
  ),
  SocialLink(
    icon: Icons.web,
    url: 'https://theofekfoundation.org',
    label: 'Website',
    isMain: true,
    type: SocialType.personal,
  ),
  SocialLink(
    icon: Icons.family_restroom,
    url: 'https://gila.family/',
    label: 'Family',
    isMain: true,
    type: SocialType.personal,
  ),
  SocialLink(
    icon: const AssetImage('assets/images/acm_icon_256.png'),
    url: 'https://dl.acm.org/profile/99660168076',
    label: 'ACM',
    isMain: false,
    type: SocialType.research,
  ),
  SocialLink(
    icon: const AssetImage('assets/images/arxiv_logo.jpg'),
    url: 'https://arxiv.org/search/cs?searchtype=author&query=Gila%2C+O',
    label: 'arXiv',
    isMain: false,
    type: SocialType.research,
  ),
  SocialLink(
    icon: const AssetImage('assets/images/dblp_icon_256.png'),
    url: 'https://dblp.org/pid/352/4182.html',
    label: 'dblp',
    isMain: false,
    type: SocialType.research,
  ),
];