import 'package:flutter/material.dart';
import 'package:ophd/generated/l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ophd/data/papers.dart';
import 'package:ophd/models/author.dart';
import 'package:ophd/models/paper.dart';
import 'package:ophd/utils/screen_utils.dart';
import 'package:ophd/widgets/card_header_icon.dart';
import 'package:ophd/widgets/clickable_markdown.dart';
import 'package:ophd/widgets/expandable_image.dart';
import 'package:ophd/widgets/launchable_icon_button.dart';
import 'package:ophd/widgets/standard_card.dart';
import 'package:diacritic/diacritic.dart';

class PublicationPage extends StatelessWidget {
  const PublicationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            CardWrapper(child: _buildTheoryOverview(context)),
            for (final paper in papers)
              if (paper.researchCategory == ResearchCategory.theory)
              CardWrapper(child: _buildPaperBlock(context, paper)),
            CardWrapper(child: _buildEducationOverview(context)),
            for (final paper in papers)
              if (paper.researchCategory == ResearchCategory.education)
                CardWrapper(child: _buildPaperBlock(context, paper)),
          ],
        ),
      ),
    );
  }

  Widget _buildTheoryOverview(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const CardHeaderIcon(
          icon: FontAwesomeIcons.book,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectableText(
                AppLocalizations.of(context)!.publicationsTheory,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              SelectableText(
                AppLocalizations.of(context)!.publicationsTheorySubtitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                  fontFamily: 'RobotoMono',
                ),
              ),
            ],
          ),
        ),
      ],
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
                          constraints.maxWidth > width ?
                            '${AppLocalizations.of(context)!.conference(paper.conference.shortName)} (${paper.conference.shortName})' :
                            (constraints.maxWidth / 2 > width / 3 ?
                              AppLocalizations.of(context)!.conference(paper.conference.shortName) :
                              paper.conference.shortName),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        onTap: () => launchURL(paper.conference.link),
                      ),
                      InkWell(
                        child: Text(
                          _formatDate(context, paper.date),
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyMedium!.color!,
                          ),
                        ),
                      ),
                      // City and Venue Row
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () => launchURL(_mapsUrl(paper.conference.city)),
                            child: Text(
                              AppLocalizations.of(context)!.city(_normalizeKey(paper.conference.city)),
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text('·', style: TextStyle(color: Theme.of(context).textTheme.bodyMedium!.color!)),
                          const SizedBox(width: 6),
                          InkWell(
                            onTap: () => launchURL(paper.conference.venueLink),
                            child: Text(
                              AppLocalizations.of(context)!.venue(_normalizeKey(paper.conference.venue)),
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]
                  )
                ],
              ),
              trailing: Wrap(
                spacing: 8,
                children: [
                  if (paper.slidesPath != null)
                    _SlidesButton(url: paper.slidesPath!),
                  LaunchableIconButton(
                    icon: FontAwesomeIcons.scroll,
                    url: paper.link,
                    tooltip: 'Paper',
                  ),
                ],
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
                    label: Text(AppLocalizations.of(context)!.award(_normalizeKey(award))),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const CardHeaderIcon(
              icon: Icons.school,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText(
                    AppLocalizations.of(context)!.publicationsEducation,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  SelectableText(
                    AppLocalizations.of(context)!.publicationsEducationSubtitle,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontFamily: 'RobotoMono',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 16),
        SelectableText(
          AppLocalizations.of(context)!.publicationsEducationIntro,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }

  String _formatDate(BuildContext context, DateTime date) {
    final locale = Localizations.localeOf(context).languageCode;
    if (locale == 'he') {
      // Use Unicode control characters to handle bidirectional text correctly
      // LRM (Left-to-Right Mark) for numbers, RLM (Right-to-Left Mark) for Hebrew text
      final day = date.day.toString();
      final month = DateFormat.MMMM(locale).format(date);
      final year = date.year.toString();
      return '\u200E$day \u200Fב$month, \u200E$year';
    }
    return DateFormat('MMM d, yyyy', locale).format(date);
  }

  String _mapsUrl(String city) {
    final query = Uri.encodeComponent(city);
    return 'https://www.google.com/maps/search/?api=1&query=$query';
  }

  String _normalizeKey(String input) => removeDiacritics(input)
      .replaceAll(RegExp(r'[.,\-]'), ' ')
      .replaceAll(RegExp(r"['’]"), '')
      .trim()
      .replaceAll(RegExp(r'\s+'), '_');
}

class _SlidesButton extends StatelessWidget {
  final String url;
  const _SlidesButton({required this.url});

  @override
  Widget build(BuildContext context) {
    final isAsset = url.startsWith('assets/');
    if (isAsset) {
      return LaunchableIconButton(
        icon: Icons.co_present,
        url: url,
        tooltip: 'Slides',
        fileType: 'application/pdf',
      );
    }
    return LaunchableIconButton(
      icon: FontAwesomeIcons.filePdf,
      url: url,
      tooltip: 'Slides',
    );
  }
}
