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
          buildCard(context, _primaryResearch),
          buildCard(context, _researchLinks),
          buildCard(context, _contributors)
        ]
      ))
    );
  }

  static final Widget _primaryResearch =
    Builder(
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'My primary research interests are in the field of ',
                style: Theme.of(context).textTheme.bodyLarge,
                children: const <TextSpan>[
                  TextSpan(
                    text: 'Algorithms in the Real World',
                    style: TextStyle(
                      fontFamily: 'RobotoMono',
                    )
                  ),
                  TextSpan(
                    text: ', which involves a combination of computer science theory and experiments. My recent work has been in data structures and algorithms, and CS Education.'
                  )
                ]
              ),
            ),
          ],
        );
      }
    );

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
  ];

  static final Widget _researchLinks = Builder(
    builder: (context) {
      return Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Find my research at:', style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(width: 15),
              for (final link in _researchLinkList)
                buildIconButton(link['icon'], link['url'], link['label']),
            ],
          ),
        ],
      );
    }
  );

  static final List<Author> contributors = [
    Author(
      name: 'Michael Goodrich',
      publicationCount: 2,
      link: 'https://en.wikipedia.org/wiki/Michael_T._Goodrich',
    ),
    Author(
      name: 'Robert Tarjan',
      publicationCount: 1,
      link: 'https://en.wikipedia.org/wiki/Robert_Tarjan',
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

  static final Widget _contributors =
    Builder(
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'I have been fortunate to work with some amazing people:',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            WordCloud(contributors),
          ],
        );
      }
    );
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
  Author? selectedAuthor = null;

  @override
  Widget build(BuildContext context) {
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
}

