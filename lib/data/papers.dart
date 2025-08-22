import 'package:ophd/data/authors.dart';
import 'package:ophd/data/conferences.dart';
import 'package:ophd/models/author.dart';
import 'package:ophd/models/paper.dart';

final List<Paper> papers = [
  Paper(
    title: 'The Marco Polo Problem: A Combinatorial Approach to Geometric Localization',
    authors: ['ofek', 'mikeg', 'zahra', 'dan', 'shayan'].map((a) => authors[a]!).toList(),
    link: 'https://arxiv.org/pdf/2504.17955',
    description: 'Right after my advancement to candidacy in June 2024, Professor Daniel Hirschberg posed a simple geometric problem to myself and others in my cohort. We didn\'t think much of it, but he spent much time over the summer break not only developing several iteratively better strategies. While he had no intention to publish these results, after some nagging I convinced him to let me try to get this published. With the help of my co-authors, we were able to refine the results, extend them in several ways, run experiments, and create not one but two papers out of this (and counting, potentially). While these results were not necessarily the hardest nor the most impressive/practical out of my papers, they solicited the most questions and discussion out of any of my conference presentations by far.',
    date: DateTime(2025, 8, 15),
    conference: CCCG2025,
    researchCategory: ResearchCategory.theory,
    imagePath: 'assets/images/cccg_mp.jpg',
    slidesPath: 'assets/pdfs/Marco1.pdf',
  ),
  Paper(
    title: 'The Rectilinear Marco Polo Problem',
    authors: ['ofek', 'mikeg', 'zahra', 'dan', 'shayan'].map((a) => authors[a]!).toList(),
    link: 'https://arxiv.org/pdf/2508.14820',
    description: 'This paper contains results that were discovered concurrently to the previous work (above). After summer break, when Dan presented his results to me, he also presented results for square probes rather than circular probes (which we then reframed as L1, L2, and L∞ norms). I thought that while those results were neat, they were rather clunky, so Dan challenged me to improve them. After less than 5 minutes, I came up with an entirely different approach which was optimal for 2D (see the 2D domino algorithm). Several minutes afterwards I came up with the 3D extension (originally with a bug). Extending to greater dimensions proved very hard, but after some effort, we (mostly Shayan and Zahra) were able to not only develop many new techniques (most of which did not make it into the final paper), but also a technique that would extend to k-dimensional space in general. We spent much more work trying to reduce the number of queries further, but most of it did not make its way to the final results. Strategies that greatly reduced the distance traveled, however, did. Programming this strategy (the Central Binary Search strategy) was the first time I programmed an algorithm that runs in higher (spatial) dimensions. That was an experience although the end result is rather clean.',
    date: DateTime(2025, 8, 15),
    conference: CCCG2025,
    researchCategory: ResearchCategory.theory,
    slidesPath: 'assets/pdfs/RectLin.pdf',
  ),
  Paper(
    title: 'Zip-Tries: Simple Dynamic Data Structures for Strings',
    authors: ['david', 'ofek', 'mikeg', 'ryuto'].map((a) => authors[a]!).toList(),
    link: 'https://arxiv.org/pdf/2505.04953',
    description: zipTriesDescription,
    date: DateTime(2025, 8, 1),
    conference: ACDA2025,
    researchCategory: ResearchCategory.theory,
    awards: ['Best Student Presentation'],
    slidesPath: 'assets/pdfs/ZipTries.pdf',
  ),
  Paper(
    title: 'Fast Geographic Routing in Fixed-Growth Graphs',
    authors: ['ofek', 'mikeg', 'abraham', 'vinesh'].map((a) => authors[a]!).toList(),
    link: 'https://arxiv.org/pdf/2502.03663',
    description: 'After my previous paper with Evrim and Mike about fast geographic routing, we searched for a way to prove more general results that extend beyond perfect lattice graphs, and could explain the good performance on road networks (which are certainly not perfect, infinite lattices). We ultimately decided on a graph property we call _fixed-growth_, and show that any graph with this property (such as lattices) can add a highway to it and achieve great greedy routing and diameter results. We were able to prove tight bounds for all our results. We then applied our findings to road networks and were able to route much better, especially in states whose road networks least resembled 2D lattices (such as Alaska). Evrim finished his PhD before we were able to prove most of our results, so the work was picked up by two new lab members, Vinesh and Abraham.',
    date: DateTime(2025, 6, 12),
    conference: CIAC2025,
    researchCategory: ResearchCategory.theory,
    slidesPath: 'assets/pdfs/FastGeographicRouting.pdf',
  ),
  Paper(
    title: 'Investigating the Capabilities of Generative AI in Solving Data Structures, Algorithms, and Computability Problems',
    authors: ['nero', 'shahar', 'yubin', 'katrina', 'elijah', 'claire', 'albert', 'ofek', 'mikes'].map((a) => authors[a]!).toList(),
    link: 'https://ics.uci.edu/~mikes/papers/fp0628.pdf',
    description: 'This paper aims to determine to which extent "current" generative AI models (GPT-4o) are able to solve CS theory problems. The short answer—in some areas well, not so well in others, but when they\'re not well they still BS well enough to fool people. I think this is more of a testament that humans are incompetent rather than that gen AI is particularly smart. Of course the state of the art of gen AI improved dramatically since.',
    date: DateTime(2025, 2, 27),
    conference: SIGCSE2025,
    researchCategory: ResearchCategory.education,
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
    researchCategory: ResearchCategory.theory,
    slidesPath: 'assets/pdfs/HighwayPref.pdf',
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
    researchCategory: ResearchCategory.theory,
    slidesPath: 'assets/pdfs/ZipZip.pdf',
  ),
  Paper(
    title: 'Beyond Big O: Teaching Experimental Algorithmics',
    authors: ['mikes', 'mikeg', 'ofek', 'miked'].map((a) => authors[a]!).toList(),
    link: 'https://www.ccsc.org/publications/journals/SW2022.pdf#page=23',
    description: "This is the first paper I helped write. I was the TA for an experimental algorithmics course at UCI while Mike Shindler was working on this paper. I helped create questions to evaluate students' understanding, where we discussed how supplementing traditional algorithms courses with experimental algorithmics could lead to positive practical outcomes. The ongoing joke is that I was only added so that the authors would be able to say that they don't discriminate against non-Mikes. The conference was the first I attended, and was conveniently held at UCI that year.",
    date: DateTime(2022, 4, 1),
    conference: CCSC2022,
    researchCategory: ResearchCategory.education,
  )
];

final Map<String, List<Paper>> papersWithAuthor = {
  for (Author author in authors.values)
    author.name: papers.where((p) => p.authors.contains(author)).toList()
};

const String zipTriesDescription = '''
This paper drilled down the importance of thoroughly checking the history and literature before spending too much time on a problem. And this happened three times during my research! The first time it happened was when, after David and Mike asked me to consider a quad-trie data structure, I ended up re-inventing the string skip-list with its bidirectional searches. The second time was when Mike invented a novel method using a perfect binary search tree to compute the MSB (most significant bit) operation using linear work and constant span (under PRAM), when arguably simpler solutions existed for decades for an identical problem (called left-most prisoner). Finally, when working on applying this problem to the zip-tree, I ended up reinventing a paradigm of adapting data structures that work for one-dimensional data to work for higher dimensional data. Despite these missteps, we ended up creating a data structure which is in my opinion very simple (we have code!) and very fast, and therefore I believe it has great potential for practical applications.

We saw the potential for this data structure to work well under parallel processing, so we brought along our resident parallel processing expert, Ryuto, to help us out. Together with his help, we were able to not only make our zip-trie parallel, but were also able to show great theoretical PRAM results for the string B-tree, that to the extent of our knowledge are state-of-the-art. I am not sure how practical these results are currently, since the cost to invoke the GPU is very high, and modern GPUs do not contain _that_ many concurrent threads, but hopefully by the time you are reading this the above statements are no longer true and our algorithms are competitive for long strings. We also provide code to benchmark our data structures for yourself using your own (NVIDIA) GPUs. For now, I recommend the sequential algorithms.
''';

const String highwayPreferentialAttachmentDescription = '''
[Evrim Ozel], a fellow PhD student in my UCI lab, had recently published an experimental paper on a great geographical routing idea that combines elements of _preferential attachment_ (where people prefer to befriend popular people over nobodies), and a geographic model called _Kleinberg's model_, where people prefer to befriend people who are located closer to them. They showed that such a paper produces great empirical results, but were unable to either provide theoretical guarantees nor provide an efficient way to construct such a graph. I joined the team, and for around a year we were unable to make much progress. After nearly giving up hope (on several occasions), I had a breakthrough and was able to prove great theoretical results on a very closely related model. Our decision to submit to COCOA was in no way influenced by our desire to take a vacation in Hawaii. My girlfriend and I had a great time there, also with Mike and his wife, and we won the best paper award from over 70 accepted papers.

[Evrim Ozel]: https://ics.uci.edu/~eozel/
''';
