import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ophd/data/papers_data.dart';
import 'package:ophd/models/author.dart';
import 'package:ophd/models/paper.dart';

import '../utils/screen_utils.dart';

class PublicationPage extends StatelessWidget {
  const PublicationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // buildCard(context, _buildOverviewBlock(context)),
            for (final paper in papers)
              buildCard(context, _buildPaperBlock(context, paper)),
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
            text: 'I have published several papers in the field of computer science. My most recent publication is titled "A Novel Approach to Computer Science" and was published in the Journal of Computer Science in 2021. You can find a list of my publications below:',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildPaperBlock(BuildContext context, Paper paper, {double width = 800}) {
    Widget body = MarkdownBody(data: paper.description, selectable: true,);
    
    Widget? image = paper.imagePath != null ? ExpandableImage(
      imagePath: paper.imagePath!,
    ) : null;
    
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: SelectableText(paper.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8.0, // space between each author name
                    children: paper.authors.map((Author author) {
                      return InkWell(
                        onTap: author.isme ? null : () => launchURL(author.link),
                        child: Text(
                          author.name,
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: author.isme ? Theme.of(context).colorScheme.tertiary : Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  Wrap(
                    spacing: 8,
                    children: [
                      InkWell(
                        child: Text(
                          constraints.maxWidth > width ? '${paper.conference} (${paper.conferenceShort})' : (constraints.maxWidth / 2 > width / 3 ? paper.conference : paper.conferenceShort) ,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        onTap: () => launchURL(paper.conferenceLink),
                      ),
                      InkWell(
                        child: Text(
                          _formatDate(paper.date),
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyMedium!.color!,
                          ),
                        ),
                      ),
                    ]
                  )
                ],
              ),
              trailing: buildIconButton(FontAwesomeIcons.scroll, paper.link, 'Read Paper')
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: constraints.maxWidth > width || image == null ?
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: body,
                    ),
                    if (image != null)
                      const SizedBox(width: 16.0), // Add some space between the text and the image (if it exists
                    if (image != null)
                      Expanded(
                        flex: 2,
                        child: image,
                      ),
                  ],
                ) : Column(
                  children: [
                    body,
                    const SizedBox(height: 16.0),
                    image,
                  ],
                )
            ),
            if (paper.awards != null && paper.awards!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Wrap(
                  spacing: 8.0, // space between chips
                  children: paper.awards!.map((award) => Chip(
                    label: Text(award),
                    avatar: Icon(Icons.star, color: Theme.of(context).colorScheme.tertiary),
                  )).toList(),
                ),
              ),
          ]
        );
      },
    );
  }
}

String _formatDate(DateTime date) {
  return DateFormat('MMM d, yyyy').format(date);
}
