// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
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
                    'Educational Journey',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  SelectableText(
                    'From High School to Graduate Studies',
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
            text: 'I was raised in Cupertino, CA, and graduated from ',
            style: Theme.of(context).textTheme.bodyLarge,
            children: [
              TextSpan(
                text: 'Monta Vista High School',
                style: TextStyle(
                  fontFamily: 'RobotoMono',
                  color: Theme.of(context).colorScheme.primary,
                )
              ),
              const TextSpan(
                text: '. My passion for programming ignited during my freshman year with my first programming course. I continued to engage with AP Computer Science A as both a student and teaching assistant. In 2017, I started at ',
              ),
              TextSpan(
                text: 'the University of California, Irvine',
                style: TextStyle(
                  fontFamily: 'RobotoMono',
                  color: Theme.of(context).colorScheme.primary,
                )
              ),
              const TextSpan(
                text: ', pursuing a double major in Computer Science and Physics, graduating in 2021. Currently, I am pursuing a PhD at UCI.',
              ),
            ],
          ),
          textAlign: TextAlign.start,
        ),
      ],
    );
  }

  Widget _buildEducationBlock(BuildContext context, {double width = 500}) {
    UCILogo({double? width}) => ClickableImage(
      image: const AssetImage('assets/images/UCI_logo_256.png'),
      link: "https://uci.edu/",
      tooltip: "UCI Homepage",
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
                        'Academic Background',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      SelectableText(
                        'Computer Science and Physics at UCI',
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
              trailing: const LaunchableIconButton(
                icon: AssetImage('assets/images/CATOC.png'),
                url: 'https://ics.uci.edu/~theory/',
                tooltip: 'UCI Theory Group',
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText('Current Studies', 
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SelectableText('PhD in CS Theory (Algorithms in the Real World), UCI, ongoing'),
                  const SelectableText('Masters attained on the way'),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  SelectableText('Undergraduate Studies',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const DegreeWidget(
                    degree: 'BS in Physics, 2021',
                    honors: 'Summa Cum Laude',
                    GPA: 3.92,
                  ),
                  const DegreeWidget(
                    degree: 'BS in Computer Science, 2021',
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
    return SelectableText.rich(
      TextSpan(
        children: [
          TextSpan(text: '$degree '),
          TextSpan(
            text: '($honors)',
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
