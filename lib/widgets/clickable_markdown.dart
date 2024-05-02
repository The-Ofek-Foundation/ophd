import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:ophd/utils/screen_utils.dart';

class ClickableMarkdown extends StatelessWidget {
  final String data;
  final bool selectable;
  final WrapAlignment textAlign;

  const ClickableMarkdown({Key? key, required this.data, this.selectable = true, this.textAlign = WrapAlignment.start}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: data,
      selectable: selectable,
      onTapLink: (text, href, title) => launchURL(href!),
      styleSheet: MarkdownStyleSheet(textAlign: textAlign)
    );
  }
}