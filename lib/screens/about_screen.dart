import 'package:flutter/material.dart';
import 'package:ophd/generated/l10n/app_localizations.dart';

import 'package:ophd/models/social_link.dart';
import 'package:ophd/widgets/launchable_icon_button.dart';
import 'package:ophd/widgets/standard_card.dart';

class AboutPage extends StatelessWidget {
  final List<SocialLink> socials;

  const AboutPage({super.key, required this.socials});

  Widget _buildFaceBlock(BuildContext context) {
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
        SelectableText(
          AppLocalizations.of(context)!.ofekGila,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SelectableText(
          AppLocalizations.of(context)!.mySubtitle,
          style: const TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 10,
          children: [
            for (SocialLink social in socials)
              LaunchableSocialButton(social: social)
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StandardCard(child: _buildFaceBlock(context))
    );
  }
}
