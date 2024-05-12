import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_scatter/flutter_scatter.dart';
import 'package:graphview/GraphView.dart';
import 'package:ophd/api/fetch_researchers.dart';

import 'package:ophd/data/authors.dart';
import 'package:ophd/data/papers.dart';
import 'package:ophd/data/social_links.dart';
import 'package:ophd/models/author.dart';
import 'package:ophd/models/researcher.dart';
import 'package:ophd/models/social_link.dart';
import 'package:ophd/utils/screen_utils.dart';
import 'package:ophd/widgets/launchable_icon_button.dart';
import 'package:ophd/widgets/standard_card.dart';

class ResearchPage extends StatelessWidget {
  const ResearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(child: Column(
        children: [
          CardWrapper(child: _buildPrimaryResearchBlock(context)),
          CardWrapper(child: _buildContributorsBlock(context)),
          CardWrapper(child: _buildErdosNumberBlock(context)),
          CardWrapper(child: LabGraph(context)),
        ]
      ))
    );
  }

  Widget _buildPrimaryResearchBlock(context) {
    const TextSpan researchInterest = TextSpan(
      text: 'Algorithms in the Real World',
        style: TextStyle(
          fontFamily: 'RobotoMono',
        )
    );

    return Column(
      children: [
        SelectableText.rich(
          const TextSpan(
            text: 'My primary research interests are in the field of ',
            children: [
              researchInterest,
              TextSpan(
                text: ', which involves a combination of computer science theory and experiments.',
              ),
              TextSpan(
                text: ' My recent work has specifically been in randomized data structures, including randomized graph models and randomized binary search trees.'
              ),
              TextSpan(
                text: ' View my work in any of my links below, or in the publications tab on this website.',
              )
            ]
          ),
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (SocialLink social in socials.where((social) => social.types.contains(SocialType.research)))
              LaunchableSocialButton(social: social),
          ],
        )
      ],
    );
  }

  Widget _buildContributorsBlock(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SelectableText(
          'I have been fortunate to work with some amazing people:',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 20),
        const WordCloud(),
        const SizedBox(height: 20),
        SelectableText(
          'A special thanks to my advisor, Michael Goodrich, for his continuing mentorship and support.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        )
      ],
    );
  }

  Widget _buildErdosNumberBlock(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SelectableText.rich(
          TextSpan(
            text: 'My ',
            style: Theme.of(context).textTheme.bodyLarge,
            children: [
              TextSpan(
                text: 'Erdős number',
                style: const TextStyle(
                  color: Colors.blue,  // You can change color as per your requirement
                  fontFamily: 'RobotoMono',
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    const url = 'https://en.wikipedia.org/wiki/Erd%C5%91s_number';
                    launchURL(url);
                  },
              ),
              TextSpan(
                text: ' is 3, via the following path:',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
        _buildPathElement(context, 'Paul Erdős', 'https://en.wikipedia.org/wiki/Paul_Erdős', 'Stephan Hedetniemi', 'On the equality of the Grundy and ochromatic numbers of graphs', 'https://www.sciencedirect.com/science/article/pii/S0012365X03001845'),
        _buildPathElement(context, 'Stephan Hedetniemi', 'https://people.computing.clemson.edu/~hedet/Stephen_Hedetniemi/Stephen_T._Hedetniemi,_Professor.html', 'Bob Tarjan', 'B-matchings in trees', 'https://epubs.siam.org/doi/abs/10.1137/0205009?journalCode=smjcat'),
        _buildPathElement(context, 'Bob Tarjan', 'https://en.wikipedia.org/wiki/Robert_Tarjan', 'Ofek Gila', 'Zip-zip Trees: Making Zip Trees More Balanced, Biased, Compact, or Persistent', 'https://arxiv.org/abs/2307.07660'),
      ],
    );
  }

  Widget _buildPathElement(BuildContext context, String name1, String personUrl1, String name2, String paper, String paperUrl) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SelectableText.rich(
        TextSpan(
          children: [
            TextSpan(
              text: name1,
              style: const TextStyle(color: Colors.blue),
              recognizer: TapGestureRecognizer()
                ..onTap = () => launchURL(personUrl1),
            ),
            TextSpan(
              text: ' & ',
              style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color),
            ),
            TextSpan(
              text: name2,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            TextSpan(
              text: ' – ',
              style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color),
            ),
            TextSpan(
              text: paper,
              style: const TextStyle(color: Colors.blue),
              recognizer: TapGestureRecognizer()
                ..onTap = () => launchURL(paperUrl),
            ),
          ],
        ),
      ),
    );
  }
}

class WordCloud extends StatefulWidget {
  const WordCloud({Key? key}) : super(key: key);

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
              for (Author author in authors.values.where((author) => !author.isMe))
                MouseRegion(
                onEnter: (event) => setState(() => selectedAuthor = author),
                onExit: (event) => setState(() => selectedAuthor = null),
                child: ActionChip(
                  label: AnimatedDefaultTextStyle(
                    style: TextStyle(fontSize: (author == selectedAuthor ? 12.0 : 10.0) + papersWithAuthor[author.name]!.length * 10, color: author == selectedAuthor ? Theme.of(context).colorScheme.tertiary : Theme.of(context).colorScheme.onSecondaryContainer),
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
              for (Author author in authors.values.where((author) => !author.isMe))
                InkResponse(
                onTap: () async  => launchURL(author.link),
                onHover: (hovering) {
                  setState(() {
                    selectedAuthor = hovering ? author : null;
                  });
                },
                hoverColor: Colors.transparent,
                child: AnimatedDefaultTextStyle(
                  style: TextStyle(fontSize: (author == selectedAuthor ? 12.0 : 10.0) + papersWithAuthor[author.name]!.length * 10, color: author == selectedAuthor ? Theme.of(context).colorScheme.tertiary : Theme.of(context).colorScheme.onSecondaryContainer),
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

class LabGraph extends StatelessWidget {
  final BuildContext context;

  const LabGraph(this.context, {super.key});

  Graph _getGraph(context, AllResearchers researchers) {
    final Graph graph = Graph();

    // Create map from researcher to node
    final Map<Researcher, Node> researcherToNode = {};

    // List<Researcher> allResearcherList = [...researchers.students, ...researchers.professors];
    List<Researcher> allResearcherList = [...researchers.students];

    // Add nodes for each researcher
    for (final Researcher researcher in allResearcherList) {
      final Node node = Node.Id(researcher);
      graph.addNode(node);
      researcherToNode[researcher] = node;
    }

    // Add edges for each collaborator
    for (final Researcher researcher in allResearcherList) {
      final Node source = researcherToNode[researcher]!;
      for (final Researcher collaborator in researcher.collaborators) {
        final Node? target = researcherToNode[collaborator];
        if (target != null) {
          graph.addEdge(source, target,
            paint: Paint()
              ..color = Theme.of(context).colorScheme.primary
              ..strokeWidth = 1.5
              ..style = PaintingStyle.stroke
          
          );
        }
      }
    }

    return graph;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Graph of Lab Members', style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 16),
        FutureBuilder(
          future: fetchResearchers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return SizedBox(
                height: 1000,
                child: InteractiveViewer(
                  constrained: false,
                  minScale: 0.01,
                  maxScale: 10.0,
                  child: GraphView(
                    graph: _getGraph(context, snapshot.data!),
                    algorithm: FruchtermanReingoldAlgorithm(),
                    animated: true,
                    builder: (Node node) {
                      // I can decide what widget should be shown here based on the id
                      return displayResearcher(context, node.key!.value as Researcher);
                    },
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Widget displayResearcher(context, Researcher i) {
    final shadowColor = i.name == 'Ofek Gila' ? Theme.of(context).colorScheme.tertiary : Theme.of(context).colorScheme.tertiaryContainer;
    final textColor = i.name == 'Ofek Gila' ? Theme.of(context).colorScheme.onTertiary : Theme.of(context).colorScheme.onTertiaryContainer;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(color: shadowColor, spreadRadius: 1),
        ],
      ),
      child: Center(
        child: Text(
          i.name,
          style: TextStyle(color: textColor),
        ),
      )
    );
  }
}
