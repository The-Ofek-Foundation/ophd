import '../models/paper.dart';
import 'authors_data.dart';

final List<Paper> papers = [
  Paper(
    title: 'Highway Preferential Attachment Models for Geographic Routing',
    authors: ['ofek', 'evrim', 'mikeg'].map((a) => authors[a]!).toList(),
    link: 'https://arxiv.org/pdf/2403.08105.pdf',
    description: 'Temp',
    date: DateTime(2023, 12, 9),
    conference: 'COCOA',
    conferenceLink: 'https://theory.utdallas.edu/COCOA2023/',
    awards: ['Best Paper']
  ),
  Paper(
    title: 'Zip-zip Trees: Making Zip Trees More Balanced, Biased, Compact, or Persistent',
    authors: ['ofek', 'mikeg', 'bob'].map((a) => authors[a]!).toList(),
    link: 'https://arxiv.org/pdf/2307.07660.pdf',
    description: 'We define simple variants of zip trees, called \\emph{zip-zip trees}, which provide several advantages over zip trees, including overcoming a bias that favors smaller keys over larger ones. We analyze zip-zip trees theoretically and empirically, showing, e.g., that the expected depth of a node in an \$n\$-node zip-zip tree is  at most \$1.3863\\log n-1+o(1)\$, which matches the expected depth of treaps and binary search trees built by uniformly random insertions.  Unlike these other data structures, however, zip-zip trees achieve their bounds using only \$O(\\log\\log n)\$ bits of metadata per node, w.h.p., as compared to the \$\Theta(\\log n)\$ bits per node required by treaps. In addition, we describe a ``just-in-time'' zip-zip tree variant, which needs just an expected \$O(1)\$ number of bits of metadata per node. Moreover, we can define zip-zip trees to be strongly history independent, whereas treaps  are generally only weakly history independent. We also introduce \\emph{biased zip-zip trees}, which have an explicit bias based on key weights, so the expected depth of a key, \$k\$, with weight, \$w_k\$, is \$O(\\log (W/w_k))\$, where \$W\$ is the weight of all keys in the weighted zip-zip tree. Finally, we show that one can easily make zip-zip trees partially persistent with only \$O(n)\$ space overhead w.h.p.',
    date: DateTime(2023, 7, 28),
    conference: 'WADS',
    conferenceLink: 'https://wadscccg2023.encs.concordia.ca/#wads-2023',
    awards: ['Best Paper'],
    imagePath: 'assets/images/wads_best_paper.jpg',
  ),
  Paper(
    title: 'Beyond Big O: Teaching Experimental Algorithmics',
    authors: ['mikes', 'mikeg', 'ofek', 'miked'].map((a) => authors[a]!).toList(),
    link: 'https://www.ccsc.org/publications/journals/SW2022.pdf#page=23',
    description: 'We present a supplement to traditionally-taught topics with experimental explorations of algorithms.',
    date: DateTime(2022, 4, 1),
    conference: 'Journal of Computing Sciences in Colleges',
    conferenceLink: 'https://www.ccsc.org/publications/journals/SW2022.pdf',
  )
];