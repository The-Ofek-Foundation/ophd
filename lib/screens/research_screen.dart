import 'package:flutter/material.dart';

import '../utils/screen_utils.dart';

class ResearchPage extends StatelessWidget {
  const ResearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(child: Column(
        children: [
          buildCard(_primaryResearch)
        ]
      ))
    );
  }

  static final Widget _primaryResearch =
    Builder(
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'My primary research interests are in the field of ',
                style: Theme.of(context).textTheme.bodyLarge,
                children: const <TextSpan>[
                  TextSpan(
                    text: 'Algorithms in the Real World',
                    style: TextStyle(
                      fontFamily: 'RobotoMono',
                    )
                  ),
                  TextSpan(
                    text: ', which involves a combination of computer science theory and experiments. My recent work has been in data structures and algorithms, and CS Education.'
                  )
                ]
              ),
            ),
          ],
        );
      }
    );
}