import 'package:flutter/material.dart';

class CollapsibleLeading extends StatelessWidget {
  final Widget leading;
  final Widget header;
  final Widget child;
  final Widget? footer;
  final bool initiallyExpanded;

  const CollapsibleLeading({
    super.key,
    required this.leading,
    required this.header,
    required this.child,
    this.footer,
    this.initiallyExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 16, bottom: 8, top: 8),
          child: leading,
        ),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                title: header,
                initiallyExpanded: initiallyExpanded,
                children: [
                  child,
                ],
              ),
            ),
            if (footer != null)
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                child: Center(child: footer!),
              ),
          ],
        )),
      ],
    );
  }
}