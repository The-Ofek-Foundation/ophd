import '../models/paper.dart';
import 'authors_data.dart';

final List<Paper> papers = [
  Paper(
    title: 'Zip-zip Trees: Making Zip Trees More Balanced, Biased, Compact, or Persistent',
    authors: ['ofek', 'mikeg', 'bob'].map((a) => authors[a]!).toList(),
    link: 'https://arxiv.org/pdf/2307.07660.pdf',
    description: 'Temp',
    date: DateTime(2023, 7, 28),
    conference: 'WADS',
    conferenceLink: 'https://wadscccg2023.encs.concordia.ca/#wads-2023',
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