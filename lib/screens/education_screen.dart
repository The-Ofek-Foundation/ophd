import 'package:flutter/material.dart';
import 'package:ophd/widgets/launchable_icon_button.dart';
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
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Column(
          children: [
            if (constraints.maxWidth <= width)
              const Image(image: AssetImage('assets/images/UCI_logo_256.png')),
            ListTile(
              leading: constraints.maxWidth > width ? const Image(image: AssetImage('assets/images/UCI_logo_256.png')) : null,
              title: const SelectableText('Current Studies'),
              subtitle: const SelectableText('PhD in CS Theory (Algorithms in the Real World), UCI, ongoing'),
              // trailing: buildIconButton(const AssetImage('assets/images/CATOC.png'), 'https://ics.uci.edu/~theory/', 'UCI Theory Group'),
              trailing: const LaunchableIconButton(
                icon: AssetImage('assets/images/CATOC.png'),
                url: 'https://ics.uci.edu/~theory/',
                tooltip: 'UCI Theory Group',
              ),
            ),
            ListTile(
              leading: constraints.maxWidth > width ? const SizedBox(width: 110, height: 40) : null,
              title: const SelectableText('University of California, Irvine'),
              subtitle: const SelectableText.rich(
                TextSpan(
                  style: TextStyle(fontStyle: FontStyle.italic),
                  children: <TextSpan>[
                    TextSpan(text: 'BS in Physics, 2021', style: TextStyle(fontStyle: FontStyle.italic)),
                    TextSpan(text: ' (Magna Cum Laude)', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: ' and '),
                    TextSpan(text: 'BS in Computer Science, 2021', style: TextStyle(fontStyle: FontStyle.italic)),
                    TextSpan(text: ' (Summa Cum Laude)', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
