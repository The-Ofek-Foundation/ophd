import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
  
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // add rounded image assets/images/profile.jpg
        ClipRRect(
          borderRadius: BorderRadius.circular(125),
          child: Image.asset(
            'assets/images/profile.jpg',
            width: 250,
            height: 250,
          ),
        ),
        Text(
          'Ofek Gila',
          style: Theme.of(context).textTheme.displayLarge,
        ),
        Text(
          'Ph.D. Student, Computer Science @ UCI',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        // add social links using font awesome
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(FontAwesomeIcons.github),
              onPressed: () => launchUrlString('https://github.com/ofekih'),
              tooltip: 'GitHub',
            ),
            IconButton(
              icon: const Icon(FontAwesomeIcons.linkedin),
              onPressed: () => launchUrlString('https://www.linkedin.com/in/ofek-gila/'),
              tooltip: 'LinkedIn',
            ),
            IconButton(
              icon: const Icon(FontAwesomeIcons.envelope),
              onPressed: () => launchUrlString('mailto:me@ofek.phd'),
              tooltip: 'Email',
            ),
            IconButton(
              icon: const Icon(FontAwesomeIcons.whatsapp),
              onPressed: () => launchUrlString('https://wa.me/14087056117'),
              tooltip: 'WhatsApp',
            ),
            IconButton(
              icon: const Icon(Icons.article),
              onPressed: () => launchUrlString('https://blog.theofekfoundation.org/'),
              tooltip: 'Blog',
            ),
            IconButton(
              icon: const Icon(Icons.web),
              onPressed: () => launchUrlString('https://theofekfoundation.org'),
              tooltip: 'Website',
            ),
            // family tree
            IconButton(
              icon: const Icon(Icons.family_restroom),
              onPressed: () => launchUrlString('https://gila.family/'),
              tooltip: 'Family',
            ),
          ],
        ),        
      ],
    );
  }
}