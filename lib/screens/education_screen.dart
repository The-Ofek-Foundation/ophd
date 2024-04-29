import 'package:flutter/material.dart';
import 'package:ophd/widgets/clickable_image.dart';
import 'package:ophd/widgets/launchable_icon_button.dart';
import 'package:ophd/widgets/leading_trailing_mid.dart';
import 'package:ophd/widgets/standard_card.dart';

class EducationPage extends StatelessWidget {
  const EducationPage({Key? key}) : super(key: key);

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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SelectableText.rich(
          TextSpan(
            text: 'I was raised in Cupertino, CA, and graduated from ',
            style: Theme.of(context).textTheme.bodyLarge,
            children: const [
              TextSpan(
                text: 'Monta Vista High School',
                style: TextStyle(
                  fontFamily: 'RobotoMono',
                )
              ),
              TextSpan(
                text: '. My passion for programming ignited during my freshman year with my first programming course. I continued to engage with AP Computer Science A as both a student and teaching assistant. In 2017, I started at ',
              ),
              TextSpan(
                text: 'the University of California, Irvine',
                style: TextStyle(
                  fontFamily: 'RobotoMono',
                )
              ),
              TextSpan(
                text: ', pursuing a double major in Computer Science and Physics, graduating in 2021. Currently, I am pursuing a PhD at UCI.',
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildEducationBlock(BuildContext context, {double width = 500}) {
    // ignore: non_constant_identifier_names
    UCILogo({double? width}) => ClickableImage(
      image: const AssetImage('assets/images/UCI_logo_256.png'),
      link: "https://uci.edu/",
      tooltip: "UCI Homepage",
      width: width,
    );

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Column(
          children: [
            if (constraints.maxWidth <= width)
              UCILogo(),
            if (constraints.maxWidth <= width)
              const SizedBox(height: 8),
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
                  SelectableText('Current Studies', style: Theme.of(context).textTheme.bodyLarge),
                  const SelectableText('PhD in CS Theory (Algorithms in the Real World), UCI, ongoing'),
                  const SelectableText('Masters attained on the way'),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  SelectableText('Undergraduate Studies', style: Theme.of(context).textTheme.bodyLarge),
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

  const DegreeWidget({Key? key, required this.degree, required this.honors, required this.GPA}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SelectableText.rich(
      TextSpan(
        children: [
          TextSpan(text: '$degree '),
          TextSpan(text: '($honors)', style: const TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: ' – GPA: $GPA'),
        ],
      ),
      style: const TextStyle(fontStyle: FontStyle.italic),
    );
  }
}
