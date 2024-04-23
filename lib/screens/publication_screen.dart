import 'package:flutter/material.dart';
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

  Widget _buildPaperBlock(BuildContext context, Paper paper) {
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
                  onTap: author.link != null ? () => launchURL(author.link!) : null,
                  child: Text(
                    author.name,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: author.link != null ? Theme.of(context).colorScheme.primary : Theme.of(context).textTheme.bodyMedium!.color!,
                    ),
                  ),
                );
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodySmall, // Use bodySmall for uniformity in font size and color
                  children: [
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle, // Aligns the widget with the middle of the text baseline
                      child: InkWell(
                        child: Text(
                          paper.conference,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyMedium!.color!, // Make it stand out as clickable
                          ),
                        ),
                        onTap: () => launchURL(paper.conferenceLink),
                      ),
                    ),
                    TextSpan(
                      text: ", ${_formatDate(paper.date)}",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        trailing: buildIconButton(FontAwesomeIcons.scroll, paper.link, 'Read Paper')
      ),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(paper.description),
      ),
      if (paper.imagePath != null)
        Image.network(paper.imagePath!),
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
}

}

String _formatDate(DateTime date) {
  return DateFormat('MMM d, yyyy').format(date);
}
