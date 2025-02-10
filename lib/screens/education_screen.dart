// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ophd/widgets/clickable_image.dart';
import 'package:ophd/widgets/launchable_icon_button.dart';
import 'package:ophd/widgets/leading_trailing_mid.dart';
import 'package:ophd/widgets/standard_card.dart';
import 'package:ophd/widgets/card_header_icon.dart';

class EducationPage extends StatelessWidget {
  const EducationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            CardWrapper(child: _buildOverviewBlock(context)),
            CardWrapper(child: _buildEducationBlock(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewBlock(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const CardHeaderIcon(
              icon: Icons.history_edu,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText(
                    AppLocalizations.of(context)!.educationJourney,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  SelectableText(
                    AppLocalizations.of(context)!.educationJourneySubtitle,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontFamily: 'RobotoMono',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Divider(),
        ),
        SelectableText.rich(
          TextSpan(
            style: Theme.of(context).textTheme.bodyLarge,
            children: [
              TextSpan(text: localizations.educationStoryStart),
              TextSpan(
                text: localizations.montaVistaHS,
                style: TextStyle(
                  fontFamily: 'RobotoMono',
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              TextSpan(text: localizations.educationStoryMid),
              TextSpan(
                text: localizations.uci,
                style: TextStyle(
                  fontFamily: 'RobotoMono',
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              TextSpan(text: localizations.educationStoryEnd),
            ],
          ),
          textAlign: TextAlign.start,
        ),
      ],
    );
  }

  Widget _buildEducationBlock(BuildContext context, {double width = 500}) {
    final localizations = AppLocalizations.of(context)!;
    
    UCILogo({double? width}) => ClickableImage(
      image: const AssetImage('assets/images/UCI_logo_256.png'),
      link: "https://uci.edu/",
      tooltip: localizations.uciHomepage,
      width: width,
    );

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CardHeaderIcon(
                  icon: Icons.school,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectableText(
                        localizations.educationBackground,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      SelectableText(
                        localizations.educationBackgroundSubtitle,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                          fontFamily: 'RobotoMono',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(),
            ),
            if (constraints.maxWidth <= width)
              UCILogo(),
            if (constraints.maxWidth <= width)
              const SizedBox(height: 16),
            LeadingTrailingMid(
              leading: constraints.maxWidth > width ? UCILogo(width: 100) : null,
              trailing: LaunchableIconButton(
                icon: const AssetImage('assets/images/CATOC.png'),
                url: 'https://ics.uci.edu/~theory/',
                tooltip: localizations.uciTheoryGroup,
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText(
                    localizations.educationCurrentStudies,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SelectableText(
                    localizations.educationCurrentStudiesDetails,
                  ),
                  SelectableText(
                    localizations.educationMasterNote,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  SelectableText(
                    localizations.educationUndergrad,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  DegreeWidget(
                    degree: localizations.degree(localizations.physics),
                    honors: 'Summa Cum Laude',
                    GPA: 3.92,
                  ),
                  DegreeWidget(
                    degree: localizations.degree(localizations.computerScience),
                    honors: 'Magna Cum Laude',
                    GPA: 3.98,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class DegreeWidget extends StatelessWidget {
  final String degree;
  final String honors;
  final double GPA;

  const DegreeWidget({super.key, required this.degree, required this.honors, required this.GPA});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final String localizedHonors = honors == 'Summa Cum Laude' ? localizations.summa : localizations.magna;
    
    return SelectableText.rich(
      TextSpan(
        children: [
          TextSpan(text: '$degree '),
          TextSpan(
            text: '($localizedHonors)',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          TextSpan(text: ' – GPA: $GPA'),
        ],
      ),
      style: TextStyle(
        fontStyle: FontStyle.italic,
        color: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}
