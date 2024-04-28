import 'package:flutter/material.dart';

class OuterPadding extends StatelessWidget {
  final Widget child;

  const OuterPadding({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width * 0.7;

    if (maxWidth < 500) maxWidth = 500;
    if (maxWidth > 1000) maxWidth = 1000;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}

class ContentWrapper extends StatelessWidget {
  final Widget child;
  final bool withinCard;

  const ContentWrapper({Key? key, required this.child, required this.withinCard}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (withinCard) {
      return Padding(padding: const EdgeInsets.all(16), child: child);
    } else {
      return OuterPadding(child: child);
    }
  }
}

class CardWrapper extends StatelessWidget {
  final Widget child;

  const CardWrapper({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OuterPadding( 
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: ContentWrapper(withinCard: true, child: child) // Pass through
      )
    );
  }
}

class StandardCard extends StatelessWidget {
  final Widget child;
  final double width;

  const StandardCard({
    Key? key,
    required this.child,
    this.width = 500,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: SingleChildScrollView(
            child: constraints.maxWidth > width ? CardWrapper(child: child) : ContentWrapper(withinCard: false, child: child),
          ),
        );
      },
    );
  }
}

