import 'package:flutter/material.dart';

import '../utils/screen_utils.dart';

class EducationPage extends StatelessWidget {
  const EducationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildCard(context, _buildEducationBlock(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildEducationBlock(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Image(image: AssetImage('assets/images/UCI_logo_256.png')), // To align with the logo above.
          title: const Text('Current Studies'),
          subtitle: const Text('PhD in CS Theory (Algorithms in the Real World), UCI, ongoing'),
          trailing: buildIconButton(const AssetImage('assets/images/CATOC.png'), 'https://ics.uci.edu/~theory/', 'UCI Theory Group'),
        ),
        ListTile(
          leading: const SizedBox(width: 110, height: 40),
          title: const Text('University of California, Irvine'),
          subtitle: RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: const <TextSpan>[
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
  }
}
