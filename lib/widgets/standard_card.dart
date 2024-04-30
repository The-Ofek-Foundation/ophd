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

class CardItself extends StatelessWidget {
  final Widget child;

  const CardItself({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ContentWrapper(withinCard: true, child: child),
    );
  }
}

class CardWrapper extends StatelessWidget {
  final Widget child;

  const CardWrapper({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OuterPadding( 
      child: CardItself(child: child),
    );
  }
}

class HighlightedCard extends StatelessWidget {
  final Widget child;
  final bool highlighted;

  const HighlightedCard({Key? key, required this.child, required this.highlighted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OuterPadding(
      child: Container(
        decoration: highlighted ? BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.light ?
                Theme.of(context).colorScheme.secondary :
                Theme.of(context).colorScheme.tertiary,
              blurRadius: 16,
              spreadRadius: 1,
              offset: const Offset(0, 0),
            ),
          ],
        ) : null,
        child: CardItself(child: child),
      ),
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

