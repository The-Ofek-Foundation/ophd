import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ophd/data/papers.dart';
import 'package:ophd/models/author.dart';
import 'package:ophd/models/paper.dart';
import 'package:ophd/utils/screen_utils.dart';
import 'package:ophd/widgets/clickable_markdown.dart';
import 'package:ophd/widgets/expandable_image.dart';
import 'package:ophd/widgets/launchable_icon_button.dart';
import 'package:ophd/widgets/standard_card.dart';

class PublicationPage extends StatelessWidget {
  const PublicationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildTheoryOverview(context),
            for (final paper in papers)
              if (paper.researchCategory == ResearchCategory.theory)
                CardWrapper(child: _buildPaperBlock(context, paper)),
            _buildEducationOverview(context),
            for (final paper in papers)
              if (paper.researchCategory == ResearchCategory.education)
                CardWrapper(child: _buildPaperBlock(context, paper)),
          ],
        ),
      ),
    );
  }

  Widget _buildTheoryOverview(BuildContext context) {
    return CardWrapper(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SelectableText(
            'Theoretical Computer Science Papers',
            style: Theme.of(context).textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          SelectableText(
            'The vast majority of my research time is spent in theoretical computer science research, with a focus on randomized algorithms and data structures. Here is a selection of my work.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPaperBlock(BuildContext context, Paper paper, {double width = 800}) {
    Widget body = ClickableMarkdown(data: paper.description);
    
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
                    spacing: 8.0,
                    children: paper.authors.map((Author author) {
                      return InkWell(
                        onTap: author.isMe ? null : () => launchURL(author.link),
                        child: Text(
                          AppLocalizations.of(context)!.name(author.i10nKey),
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: author.isMe ? Theme.of(context).colorScheme.tertiary : Theme.of(context).colorScheme.primary,
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
                          constraints.maxWidth > width ? '${paper.conference.fullName} (${paper.conference.shortName})' : (constraints.maxWidth / 2 > width / 3 ? paper.conference.fullName : paper.conference.shortName) ,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        onTap: () => launchURL(paper.conference.link),
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
              trailing: LaunchableIconButton(
                icon: FontAwesomeIcons.scroll,
                url: paper.link,
                tooltip: 'Paper',
              ),
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
                      const SizedBox(width: 16.0),
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
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Wrap(
                  spacing: 8.0,
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

  Widget _buildEducationOverview(BuildContext context) {
    return CardWrapper(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SelectableText(
            'Computer Science Education Papers',
            style: Theme.of(context).textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          SelectableText(
            'During my time as a UCI PhD student, I have had the opportunity to tag along on some CS ed research projects.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

String _formatDate(DateTime date) {
  return DateFormat('MMM d, yyyy').format(date);
}
