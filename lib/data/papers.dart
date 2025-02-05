import 'package:ophd/data/authors.dart';
import 'package:ophd/data/conferences.dart';
import 'package:ophd/models/author.dart';
import 'package:ophd/models/paper.dart';

final List<Paper> papers = [
  Paper(
    title: 'Fast Geographic Routing in Fixed-Growth Graphs',
    authors: ['ofek', 'mikeg', 'abraham', 'vinesh'].map((a) => authors[a]!).toList(),
    link: 'tbd',
    description: 'placeholder',
    date: DateTime(2025, 6, 1),
    conference: CIAC2025,
    show: false,
  ),
  Paper(
    title: 'Investigating the Capabilities of Generative AI in Solving Data Structures, Algorithms, and Computability Problems',
    authors: ['ofek', 'mikes', 'nero', 'shahar', 'katrina', 'elijah', 'claire', 'albert'].map((a) => authors[a]!).toList(),
    link: 'https://ics.uci.edu/~mikes/papers/fp0628.pdf',
    description: 'placeholder',
    date: DateTime(2025, 2, 27),
    conference: SIGCSE2025,
    show: false
  ),
  Paper(
    title: 'Highway Preferential Attachment Models for Geographic Routing',
    authors: ['ofek', 'mikeg', 'evrim'].map((a) => authors[a]!).toList(),
    link: 'https://arxiv.org/pdf/2403.08105.pdf',
    description: highwayPreferentialAttachmentDescription,
    date: DateTime(2023, 12, 9),
    conference: COCOA2023,
    awards: ['Best Paper'],
    imagePath: 'assets/images/cocoa_nicole.jpg',
  ),
  Paper(
    title: 'Zip-zip Trees: Making Zip Trees More Balanced, Biased, Compact, or Persistent',
    authors: ['ofek', 'mikeg', 'bob'].map((a) => authors[a]!).toList(),
    link: 'https://arxiv.org/pdf/2307.07660.pdf',
    description: "The ***zip tree*** is a very simple and elegant balanced binary search tree that was invented by Bob Tarjan, Caleb Levy, and Stephen Timmel, in 2017. Mike Goodrich and I asked our students in an experimental algorithmics course to implement the zip tree shortly after it was published. Despite all its simplicity, it had a major flaw—it was unbalanced, with one side always deeper. While at a conference in Italy, Mike happened to run across Bob, where they started discussing various methods to make it more balanced. Coincidentally, they had very close-by plane seats on their flight back to New York, and discussed more. Mike, knowing my interest in zip-trees, invited me to join them, and over the next few weeks we discussed and discounted several ideas to improve the balance while keeping a very low amount of metadata. After only a few weeks, we settled on a very simple idea with an elegant proof, performed experiments to 'verify' our theoretical results, and wrote the paper on our new data structure, the ***zip-zip tree***. We also introduced a memory-saving variant called the ***just-in-time zip-zip tree***, and in a journal version introduced the ***external zip-zip tree***. I presented our results in Montreal, where we were presented with my first best paper award.",
    date: DateTime(2023, 7, 28),
    conference: WADS2023,
    awards: ['Best Paper'],
    imagePath: 'assets/images/wads_best_paper.jpg',
  ),
  Paper(
    title: 'Beyond Big O: Teaching Experimental Algorithmics',
    authors: ['mikes', 'mikeg', 'ofek', 'miked'].map((a) => authors[a]!).toList(),
    link: 'https://www.ccsc.org/publications/journals/SW2022.pdf#page=23',
    description: "This is the first paper I helped write. I was the TA for an experimental algorithmics course at UCI while Mike Shindler was working on this paper. I helped create questions to evaluate students' understanding, where we discussed how supplementing traditional algorithms courses with experimental algorithmics could lead to positive practical outcomes. The ongoing joke is that I was only added so that the authors would be able to say that they don't discriminate against non-Mikes. The conference was the first I attended, and was conveniently held at UCI that year.",
    date: DateTime(2022, 4, 1),
    conference: CCSC2022,
  )
];

final Map<String, List<Paper>> papersWithAuthor = {
  for (Author author in authors.values)
    author.name: papers.where((p) => p.authors.contains(author)).toList()
};

const String highwayPreferentialAttachmentDescription = '''
[Evrim Ozel], a fellow PhD student in my UCI lab, had recently published an experimental paper on a great geographical routing idea that combines elements of _preferential attachment_ (where people prefer to befriend popular people over nobodies), and a geographic model called _Kleinberg's model_, where people prefer to befriend people who are located closer to them. They showed that such a paper produces great empirical results, but were unable to either provide theoretical guarantees nor provide an efficient way to construct such a graph. I joined the team, and for around a year we were unable to make much progress. After nearly giving up hope (on several occasions), I had a breakthrough and was able to prove great theoretical results on a very closely related model. Our decision to submit to COCOA was in no way influenced by our desire to take a vacation in Hawaii. My girlfriend and I had a great time there, also with Mike and his wife, and we won the best paper award from over 70 accepted papers.

[Evrim Ozel]: https://ics.uci.edu/~eozel/
''';
