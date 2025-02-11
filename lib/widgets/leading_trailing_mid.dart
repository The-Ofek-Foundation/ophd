import 'package:flutter/material.dart';

class LeadingTrailingMid extends StatelessWidget {
  final Widget? leading;
  final Widget? trailing;
  final Widget title;
  final Widget child;

  const LeadingTrailingMid({
    super.key,
    this.leading,
    this.trailing,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (leading != null)
          Padding(
            padding: EdgeInsets.only(
              left: isRTL ? 16 : 0,
              right: isRTL ? 0 : 16,
              bottom: 8,
              top: 8
            ),
            child: leading!,
          ),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: title),
                if (trailing != null)
                  Padding(
                    padding: EdgeInsets.only(left: isRTL ? 0 : 10, right: isRTL ? 10 : 0),
                    child: trailing!,
                  ),
              ],
            ),
            child,
          ],
        )),
      ],
    );
  }
}