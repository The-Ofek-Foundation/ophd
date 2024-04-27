import 'package:flutter/material.dart';

import 'package:ophd/models/social_link.dart';
import 'package:ophd/widgets/launchable_icon_button.dart';
import 'package:ophd/widgets/standard_card.dart';

class AboutPage extends StatelessWidget {
  final List<SocialLink> socials;

  const AboutPage({Key? key, required this.socials}) : super(key: key);

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
        const SelectableText(
          'Ofek Gila',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SelectableText(
          'Ph.D. Student, Computer Science @ UCI',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 10,
          children: [
            for (SocialLink link in socials)
              LaunchableIconButton(
                icon: link.icon,
                url: link.url,
                tooltip: link.label,
              )
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StandardCard(child: _buildFaceBlock())
    );
  }
}
