import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_scatter/flutter_scatter.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../utils/screen_utils.dart';

class ResearchPage extends StatelessWidget {
  const ResearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(child: Column(
        children: [
          buildCard(context, _buildPrimaryResearchBlock(context)),
          buildCard(context, _buildContributorsBlock(context)),
          buildCard(context, _buildErdosNumberBlock(context)),
        ]
      ))
    );
  }

  static final List<dynamic> _researchLinkList = [
    {
      'icon': const AssetImage('assets/images/avatar_scholar_256.png'),
      'url': 'https://scholar.google.com/citations?hl=en&user=t9s-uKcAAAAJ',
      'label': 'Google Scholar',
    },
    {
      'icon': FontAwesomeIcons.orcid,
      'url': 'https://orcid.org/0009-0005-5931-771X',
      'label': 'ORCID',
    },
    {
      'icon': const AssetImage('assets/images/acm_icon_256.png'),
      'url': 'https://dl.acm.org/profile/99660168076',
      'label': 'ACM',
    },
    {
      'icon': const AssetImage('assets/images/arxiv_logo.jpg'),
      'url': 'https://arxiv.org/search/cs?searchtype=author&query=Gila%2C+O',
      'label': 'arXiv',
    },
  ];

  Widget _buildPrimaryResearchBlock(context) {
    return SelectableText.rich(
      TextSpan(
        text: 'My primary research interests are in the field of ',
        style: Theme.of(context).textTheme.bodyLarge,
        children: [
          const TextSpan(
            text: 'Algorithms in the Real World',
            style: TextStyle(
              fontFamily: 'RobotoMono',
            )
          ),
          const TextSpan(
            text: ', which involves a combination of computer science theory and experiments. My recent work has specifically been in graph theory and binary search trees.'
          ),
          const TextSpan(
            text: ' Find my research at:'
          ),
          for (final link in _researchLinkList)
            WidgetSpan(child: buildIconButton(link['icon'], link['url'], link['label'])),
        ]
      ),
      textAlign: TextAlign.center,
    );
  }

  static final List<Author> contributors = [
    Author(
      name: 'Michael Goodrich',
      publicationCount: 3,
      link: 'https://en.wikipedia.org/wiki/Michael_T._Goodrich',
    ),
    Author(
      name: 'Robert Tarjan',
      publicationCount: 1,
      link: 'https://en.wikipedia.org/wiki/Robert_Tarjan',
    ),
    Author(
      name: 'Evrim Ozel',
      publicationCount: 1,
      link: 'https://www.ics.uci.edu/~eozel/',
    ),
    Author(
      name: 'Michael Shindler',
      publicationCount: 1,
      link: 'https://www.ics.uci.edu/~mikes/',
    ),
    Author(
      name: 'Michael Dillencourt',
      publicationCount: 1,
      link: 'https://www.ics.uci.edu/~dillenco/',
    ),
  ];

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
        WordCloud(contributors),
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
          // textAlign: TextAlign.center,
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
              text: ' - ',
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

class Author {
  final String name;
  final int publicationCount;
  final String link;

  Author({
    required this.name,
    required this.publicationCount,
    required this.link,
  });
}

class WordCloud extends StatefulWidget {
  final List<Author> authors;

  const WordCloud(this.authors, {Key? key}) : super(key: key);

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
            spacing: 8.0, // gap between adjacent chips
            runSpacing: 4.0, // gap between lines
            children: widget.authors.map((Author author) {
              return MouseRegion(
                onEnter: (event) => setState(() => selectedAuthor = author),
                onExit: (event) => setState(() => selectedAuthor = null),
                child: ActionChip(
                  label: AnimatedDefaultTextStyle(
                    style: TextStyle(fontSize: (author == selectedAuthor ? 12.0 : 10.0) + author.publicationCount * 10, color: author == selectedAuthor ? Theme.of(context).colorScheme.tertiary : Theme.of(context).colorScheme.onSecondaryContainer),
                    duration: const Duration(milliseconds: 200),
                    child: Text(author.name),
                  ),
                  onPressed: () async {
                    if (await canLaunchUrlString(author.link)) {
                      await launchUrlString(author.link);
                    } else {
                      throw 'Could not launch ${author.link}';
                    }
                  },
                ),
              );
            }).toList(),
          );
        } else {
          // Use Scatter for larger screen sizes
          return Scatter(
            delegate: ArchimedeanSpiralScatterDelegate(ratio: 0.1),
            children: widget.authors.map((Author author) {
              return InkResponse(
                onTap: () async {
                  if (await canLaunchUrlString(author.link)) {
                    await launchUrlString(author.link);
                  } else {
                    throw 'Could not launch ${author.link}';
                  }
                },
                onHover: (hovering) {
                  setState(() {
                    selectedAuthor = hovering ? author : null;
                  });
                },
                hoverColor: Colors.transparent,
                child: AnimatedDefaultTextStyle(
                  style: TextStyle(fontSize: (author == selectedAuthor ? 12.0 : 10.0) + author.publicationCount * 10, color: author == selectedAuthor ? Theme.of(context).colorScheme.tertiary : Theme.of(context).colorScheme.onSecondaryContainer),
                  duration: const Duration(milliseconds: 200),
                  child: Text(author.name),
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }
}
