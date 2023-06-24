import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../utils/screen_utils.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  static final List<dynamic> _socialLinks = [
    {
      'icon': FontAwesomeIcons.github,
      'url': 'https://github.com/ofekih',
      'label': 'GitHub',
    },
    {
      'icon': FontAwesomeIcons.linkedin,
      'url': 'https://www.linkedin.com/in/ofek-gila/',
      'label': 'LinkedIn',
    },
    {
      'icon': FontAwesomeIcons.envelope,
      'url': 'mailto:me@ofek.phd',
      'label': 'Email',
    },
    {
      'icon': FontAwesomeIcons.whatsapp,
      'url': 'https://wa.me/14087056117',
      'label': 'WhatsApp',
    },
    {
      'icon': Icons.article,
      'url': 'https://blog.theofekfoundation.org/',
      'label': 'Blog',
    },
    {
      'icon': Icons.web,
      'url': 'https://theofekfoundation.org',
      'label': 'Website',
    },
    {
      'icon': Icons.family_restroom,
      'url': 'https://gila.family/',
      'label': 'Family',
    },
  ];

  Widget _buildFaceBlock() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(125),
          child: Image.asset(
            'assets/images/profile.jpg',
            width: 250,
            height: 250,
          ),
        ),
        const Text(
          'Ofek Gila',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const Text(
          'Ph.D. Student, Computer Science @ UCI',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 10,
          children: [
            for (var link in _socialLinks)
              buildIconButton(link['icon'], link['url'], link['label']),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildCardIfWideEnough(_buildFaceBlock())
    );
  }
}
