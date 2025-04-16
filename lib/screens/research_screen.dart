import 'package:flutter/material.dart';
import 'package:ophd/generated/l10n/app_localizations.dart';
import 'package:flutter_scatter/flutter_scatter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:ophd/data/authors.dart';
import 'package:ophd/data/papers.dart';
import 'package:ophd/data/social_links.dart';
import 'package:ophd/models/author.dart';
import 'package:ophd/models/social_link.dart';
import 'package:ophd/utils/screen_utils.dart';
import 'package:ophd/widgets/card_header_icon.dart';
import 'package:ophd/widgets/launchable_icon_button.dart';
import 'package:ophd/widgets/standard_card.dart';

class ResearchPage extends StatelessWidget {
  const ResearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(child: Column(
        children: [
          CardWrapper(child: _buildPrimaryResearchBlock(context)),
          CardWrapper(child: _buildContributorsBlock(context)),
          CardWrapper(child: _buildErdosNumberBlock(context)),
        ]
      ))
    );
  }

  Widget _buildPrimaryResearchBlock(context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const CardHeaderIcon(
              icon: FontAwesomeIcons.flask,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText(
                    AppLocalizations.of(context)!.researchPrimary,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  SelectableText(
                    AppLocalizations.of(context)!.researchPrimarySubtitle,
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
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Divider(),
        ),
        SelectableText(
          AppLocalizations.of(context)!.researchDescription,
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            for (SocialLink social in socials.where((social) => social.types.contains(SocialType.research))) ...[
              LaunchableSocialButton(social: social),
              const SizedBox(width: 8),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildContributorsBlock(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const CardHeaderIcon(
              icon: Icons.groups,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText(
                    AppLocalizations.of(context)!.researchCollaborators,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  SelectableText(
                    AppLocalizations.of(context)!.researchCollaboratorsSubtitle(
                      AppLocalizations.of(context)!.name('mikeg')
                    ),
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
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Divider(),
        ),
        const WordCloud(),
      ],
    );
  }

  Widget _buildErdosNumberBlock(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const CardHeaderIcon(
              icon: Icons.people_alt_outlined,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText(
                    AppLocalizations.of(context)!.erdosNumber,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => launchURL('https://en.wikipedia.org/wiki/Erd%C5%91s_number'),
                      child: Text(
                        AppLocalizations.of(context)!.erdosNumberSubtitle,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Divider(),
        ),
        Column(
          children: [
            _buildErdosPathElement(context, 'paul', 'https://en.wikipedia.org/wiki/Paul_Erdős', 'hedet', 'On the equality of the Grundy and ochromatic numbers of graphs', 'https://www.sciencedirect.com/science/article/pii/S0012365X03001845'),
            _buildErdosPathElement(context, 'hedet', 'https://people.computing.clemson.edu/~hedet/Stephen_Hedetniemi/Stephen_T._Hedetniemi,_Professor.html', 'bob', 'B-matchings in trees', 'https://epubs.siam.org/doi/abs/10.1137/0205009?journalCode=smjcat'),
            _buildErdosPathElement(context, 'bob', 'https://en.wikipedia.org/wiki/Robert_Tarjan', 'ofek', 'Zip-zip Trees: Making Zip Trees More Balanced, Biased, Compact, or Persistent', 'https://link.springer.com/chapter/10.1007/978-3-031-38906-1_31'),
          ],
        ),
      ],
    );
  }

  Widget _buildErdosPathElement(BuildContext context, String name1Key, String personUrl1, String name2Key, String paper, String paperUrl) {
    final localizations = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(77),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    SelectableText(
                      localizations.name(name1Key),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SelectableText(' & '),
                    SelectableText(localizations.name(name2Key)),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.open_in_new, size: 16),
                onPressed: () => launchURL(personUrl1),
                tooltip: localizations.link('viewPage', localizations.name(name1Key)),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: SelectableText(
                  paper,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(FontAwesomeIcons.scroll, size: 16),
                onPressed: () => launchURL(paperUrl),
                tooltip: localizations.link('viewPaper', ''),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WordCloud extends StatefulWidget {
  const WordCloud({super.key});

  @override
  WordCloudState createState() => WordCloudState();
}

class WordCloudState extends State<WordCloud> {
  Author? selectedAuthor;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < 600) {
          // Use Wrap for smaller screen sizes
          return Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: [
              for (Author author in authors.values.where((author) => !author.isMe && author.show))
                MouseRegion(
                onEnter: (event) => setState(() => selectedAuthor = author),
                onExit: (event) => setState(() => selectedAuthor = null),
                child: ActionChip(
                  label: AnimatedDefaultTextStyle(
                    style: TextStyle(fontSize: (author == selectedAuthor ? 12.0 : 10.0) + papersWithAuthor[author.name]!.length * 10, color: author == selectedAuthor ? Theme.of(context).colorScheme.tertiary : Theme.of(context).colorScheme.secondary),
                    duration: const Duration(milliseconds: 200),
                    child: Text(author.name),
                  ),
                  onPressed: () async => launchURL(author.link),
                ),
              ),
            ]
          );
        } else {
          // Use Scatter for larger screen sizes
          return Scatter(
            delegate: ArchimedeanSpiralScatterDelegate(ratio: 0.1),
            children: [
              for (Author author in authors.values.where((author) => !author.isMe && author.show))
                InkResponse(
                onTap: () async  => launchURL(author.link),
                onHover: (hovering) {
                  setState(() {
                    selectedAuthor = hovering ? author : null;
                  });
                },
                hoverColor: Colors.transparent,
                child: AnimatedDefaultTextStyle(
                  style: TextStyle(fontSize: (author == selectedAuthor ? 12.0 : 10.0) + papersWithAuthor[author.name]!.length * 10, color: author == selectedAuthor ? Theme.of(context).colorScheme.tertiary : Theme.of(context).colorScheme.secondary),
                  duration: const Duration(milliseconds: 200),
                  child: Text(AppLocalizations.of(context)!.name(author.i10nKey)),
                ),
              )
            ]
          );
        }
      },
    );
  }
}
