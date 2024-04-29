import 'package:flutter/material.dart';

class IndustryPage extends StatelessWidget {
  const IndustryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text('Coming soon'),
          ],
        ),
      ),
    );
  }
}
