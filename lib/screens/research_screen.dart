import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_scatter/flutter_scatter.dart';
import 'package:graphview/GraphView.dart';
import 'package:ophd/api/fetch_researchers.dart';

import 'package:ophd/data/authors.dart';
import 'package:ophd/data/okabe_ito.dart';
import 'package:ophd/data/papers.dart';
import 'package:ophd/data/social_links.dart';
import 'package:ophd/models/author.dart';
import 'package:ophd/models/researcher.dart';
import 'package:ophd/models/social_link.dart';
import 'package:ophd/utils/screen_utils.dart';
import 'package:ophd/widgets/launchable_icon_button.dart';
import 'package:ophd/widgets/refresh.dart';
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
          CardItself(child: LabGraph(context)),
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

class LabGraph extends StatefulWidget {
  final BuildContext context;

  const LabGraph(this.context, {super.key});

  @override
  State<LabGraph> createState() => _LabGraphState();
}

class _LabGraphState extends State<LabGraph> {
  Set<ProfessorResearcher> selectedProfessors = {};
  Map<ProfessorResearcher, Color> professorColors = {};
  Set<Color> remainingColors = okabe.toSet();
  AllResearchers? allResearchers;
  Set<StudentResearcher> unconnectedStudents = {};
  bool isLoading = true;
  String? errorMessage;
  Graph? graph;

  @override
  void initState() {
    super.initState();
    refetchResearchers();
  }

  void refetchResearchers() {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    fetchResearchers().then((data) {
      setState(() {
        allResearchers = data;
        graph = _getGraph(widget.context, allResearchers!);
        unconnectedStudents = _getUnconnectedStudents(graph!, allResearchers!);
        isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        errorMessage = error.toString();
        isLoading = false;
      });
    });
  }

  Graph _getGraph(BuildContext context, AllResearchers researchers) {
    final Graph graph = Graph();

    // Create map from researcher to node
    final Map<Researcher, Node> researcherToNode = {};

    // List<Researcher> allResearcherList = [...researchers.students, ...researchers.professors];
    Set<Researcher> allResearcherSetWithDups = <Researcher>{...researchers.students};
    allResearcherSetWithDups.addAll(selectedProfessors);
    Set<Researcher> allResearcherSet = {};

    for (final Researcher researcher in allResearcherSetWithDups) {
      // skip researchers who have no collaborators with other researchers
      // loop over collaborators and check if they are in the set
      for (final Researcher collaborator in researcher.collaborators) {
        if (allResearcherSetWithDups.contains(collaborator)) {
          allResearcherSet.add(researcher);
        }
      }
    }

    // Add nodes for each researcher
    for (final Researcher researcher in allResearcherSet) {
      final Node node = Node.Id(researcher);
      graph.addNode(node);
      researcherToNode[researcher] = node;
      // break;
    }

    // Add edges for each collaborator
    for (final Researcher researcher in allResearcherSet) {
      final Node source = researcherToNode[researcher]!;
      for (final Researcher collaborator in researcher.collaborators) {
        final Node? target = researcherToNode[collaborator];
        if (target != null) {
          // only add edge if source is alphabetically less than target
          if (source.key!.value.name.compareTo(target.key!.value.name) < 0) {
            graph.addEdge(source, target,
              paint: Paint()
                ..color = Theme.of(context).colorScheme.primary
                ..strokeWidth = 1.5
                ..style = PaintingStyle.stroke
            );
          }
        }
      }
    }

    return graph;
  }

  Set<StudentResearcher> _getUnconnectedStudents(Graph graph, AllResearchers researchers) {
    final Set<StudentResearcher> unconnectedStudents = researchers.students.toSet();

    for (var node in graph.nodes) {
      if (node.key!.value is StudentResearcher) {
        unconnectedStudents.remove(node.key!.value);
      }
    }

    return unconnectedStudents;
  }

  void _updateGraph() {
    setState(() {
      graph = _getGraph(widget.context, allResearchers!);
      unconnectedStudents = _getUnconnectedStudents(graph!, allResearchers!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SelectableText(
              'Graph of Lab Members',
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            RefreshButton(
              tooltip: AppLocalizations.of(context)!.label("Sync"),
              onPressed: () async  {
                await updateDatabase();
                refetchResearchers();
              }
            ),
          ],
        ),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 800,
          ),
          child: Center(
            child: SelectableText.rich(
              TextSpan(
                children: [
                  const TextSpan(text: 'Here is a graph of all the members of my lab, the '),
                  TextSpan(
                    text: 'theory lab',
                    style: const TextStyle(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => launchURL('https://ics.uci.edu/~theory/'),
                  ),
                  const TextSpan(text: ', at UCI. Edges correspond to co-authorship on research papers. Feel free to select faculty members to see their collaborations.'),
                ],
              ),
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (isLoading)
          const CircularProgressIndicator()
        else if (errorMessage != null)
          SelectableText('Error: $errorMessage')
        else
          Column(
            children: [
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.center,
                children: [
                  for (ProfessorResearcher researcher in allResearchers!.professors)
                    FilterChip(
                      label: Text(researcher.name),
                      selected: selectedProfessors.contains(researcher),
                      checkmarkColor: Colors.white,
                      avatar: CircleAvatar(
                        backgroundColor: professorColors[researcher],
                        // child: Text(researcher.name[0]),
                      ),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            selectedProfessors.add(researcher);
                            final Color color = remainingColors.first;
                            remainingColors.remove(color);
                            professorColors[researcher] = color;

                            if (remainingColors.isEmpty) {
                              remainingColors = okabe.toSet();
                            }
                          } else {
                            selectedProfessors.remove(researcher);
                            remainingColors.add(professorColors[researcher]!);
                            professorColors.remove(researcher);
                          }
                          _updateGraph();
                        });
                      },
                    ),
                ],
              ),
              const SizedBox(height: 16),
              LayoutBuilder(
                builder: (context, constraints) {
                  var width = max(constraints.maxWidth, 1000.0);
                  var height = 1000.0;
                  return SizedBox(
                    height: height,
                    child: InteractiveViewer(
                      constrained: false,
                      minScale: 1,
                      maxScale: 1,
                      child: GraphView(
                        key: ValueKey(graph),
                        graph: graph!,
                        algorithm: FruchtermanReingoldAlgorithm(),
                        animated: true,
                        width: width,
                        height: height,
                        builder: (Node node) {
                          // I can decide what widget should be shown here based on the id
                          Researcher researcher = node.key!.value as Researcher;

                          // check if node is a professor
                          if (researcher is ProfessorResearcher) {
                            return displayProfessor(context, researcher);
                          }

                          return displayResearcher(context, node.key!.value as Researcher);
                        },
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 800,
                ),
                child: SelectableText(
                  'The ${unconnectedStudents.length} lab members who have not (yet) collaborated with any other lab members or shown faculty are unfortunately not shown above, and are instead listed below.',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.center,
                children: [
                  for (StudentResearcher student in unconnectedStudents)
                    ActionChip(
                      label: Text(student.name),
                      onPressed: () => _showStudentDetails(context, student),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 800,
                ),
                child: SelectableText(
                  'If you are a lab member and have a missing connection, please try syncing the database from the reload button. If that doesn\'t work, it is possible that either your publication is too recent and does not (yet) appear in DBLP, I have an incorrect DBLP ID associated with you, or your publication is in an adjacent field and does not appear in DBLP. In either case, you can contact me to manually update the data.',
                  style: Theme.of(context).textTheme.labelLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget displayProfessor(BuildContext context, ProfessorResearcher professor) {
    final int degree = professor.collaborators.length;
    final double size = (log(degree) + 1) * 30.0;
    final Color color = professorColors[professor]!;

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showProfessorDetails(context, professor),
          customBorder: const CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
              ),
              child: Center(
                child: Text(
                  professor.name[0],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size / 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showProfessorDetails(BuildContext context, ProfessorResearcher professor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ResearcherDetailsModal(
          researcher: professor,
          backgroundColor: professorColors[professor],
          avatarIcon: Icons.school,
          allResearchers: allResearchers,
        );
      },
    );
  }

  Widget displayResearcher(context, Researcher i) {
    final shadowColor = i.name == 'Ofek Gila' ? Theme.of(context).colorScheme.tertiary : Theme.of(context).colorScheme.tertiaryContainer;
    final textColor = i.name == 'Ofek Gila' ? Theme.of(context).colorScheme.onTertiary : Theme.of(context).colorScheme.onTertiaryContainer;

    return InkWell(
      onTap: i is StudentResearcher ? () => _showStudentDetails(context, i) : null,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(color: shadowColor, spreadRadius: 1),
          ],
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                i.name,
                style: TextStyle(color: textColor),
              ),
              if (i.hasDoctorate && i is StudentResearcher) ...[
                const SizedBox(width: 4),
                Icon(
                  Icons.school,
                  size: 16,
                  color: textColor,
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  void _showStudentDetails(BuildContext context, StudentResearcher student) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ResearcherDetailsModal(
          researcher: student,
          avatarIcon: Icons.person,
          allResearchers: allResearchers,
        );
      },
    );
  }
}

class ResearcherDetailsModal extends StatelessWidget {
  final Researcher researcher;
  final Color? backgroundColor;
  final IconData avatarIcon;
  final AllResearchers? allResearchers;

  const ResearcherDetailsModal({
    super.key,
    required this.researcher,
    this.backgroundColor,
    required this.avatarIcon,
    required this.allResearchers,
  });

  List<Widget> _buildDetails(BuildContext context) {
    final List<Widget> details = [];
    final facultyCollaborators = researcher.collaborators.whereType<ProfessorResearcher>().length;
    final studentCollaborators = researcher.collaborators.whereType<StudentResearcher>().length;

    // Add researcher-specific details
    if (researcher is StudentResearcher) {
      final student = researcher as StudentResearcher;
      if (student.advisors != null && student.advisors!.isNotEmpty) {
        details.add(_buildInfoCard(
          context,
          Icons.supervisor_account,
          'Advisors',
          student.advisors!.map((a) => a.name).join(", "),
        ));
      }

      details.add(_buildInfoCard(
        context,
        Icons.school,
        'Graduation Status',
        student.hasDoctorate 
          ? (student.year != null ? '${student.year} (PhD)' : 'Unknown (PhD)')
          : 'PhD not yet awarded',
      ));

      if (student.thesisTitle != null) {
        details.add(_buildInfoCard(
          context,
          Icons.menu_book,
          'Thesis Title',
          student.thesisTitle!,
        ));
      }
    } else if (researcher is ProfessorResearcher) {
      final professor = researcher as ProfessorResearcher;
      final gradStudents = allResearchers!.students.where((s) => 
        s.advisors?.any((a) => a.name == professor.name) ?? false).toList()
        ..sort((a, b) => (a.year ?? 9999).compareTo(b.year ?? 9999));
      
      final currentStudents = gradStudents.where((s) => !s.hasDoctorate).length;
      final graduatedStudents = gradStudents.where((s) => s.hasDoctorate).toList();
      final yearRange = graduatedStudents.isEmpty ? null : 
        graduatedStudents.first.year == graduatedStudents.last.year ? 
        graduatedStudents.first.year.toString() :
        '${graduatedStudents.first.year} – ${graduatedStudents.last.year}';

      details.add(_buildInfoCard(
        context,
        Icons.groups,
        'Graduate Students',
        '${currentStudents > 0 ? 'Current: $currentStudents\n' : ''}'
        '${graduatedStudents.length} ${graduatedStudents.length == 1 ? 'student' : 'students'}'
        '${yearRange != null ? ' ($yearRange)' : ''}',
      ));

      if (graduatedStudents.isNotEmpty) {
        details.add(_buildInfoCard(
          context,
          Icons.history_edu,
          'Recent Graduates',
          '',
          customContent: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: graduatedStudents.reversed.take(3).map((s) => 
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SelectableText(s.name),
                    ),
                    SelectableText(
                      s.year.toString(),
                    ),
                  ],
                ),
              )
            ).toList(),
          ),
        ));
      }
    }

    // Add shared collaboration details
    if (researcher.collaborators.isNotEmpty) {
      details.add(_buildInfoCard(
        context,
        Icons.people_alt,
        'Research Collaborations',
        '${facultyCollaborators > 0 ? '$facultyCollaborators faculty' : ''}'
        '${facultyCollaborators > 0 && studentCollaborators > 0 ? ' and ' : ''}'
        '${studentCollaborators > 0 ? '$studentCollaborators student' : ''}'
        ' co-author${(studentCollaborators == 0 && facultyCollaborators == 1) || studentCollaborators == 1 ? '' : 's'} in the lab',
      ));
    }

    return details;
  }

  Widget _buildInfoCard(BuildContext context, IconData icon, String label, String value, {Widget? customContent}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 24,
            color: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 4),
                customContent ?? SelectableText(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: backgroundColor ?? Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    avatarIcon,
                    color: backgroundColor != null ? Colors.white : Theme.of(context).colorScheme.onSecondaryContainer,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectableText(
                        researcher.name,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (researcher is ProfessorResearcher)
                        SelectableText(
                          (researcher as ProfessorResearcher).title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                    ],
                  ),
                ),
                if (researcher.url != null)
                  IconButton.filledTonal(
                    style: IconButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    icon: const Icon(Icons.language),
                    tooltip: 'Visit website',
                    onPressed: () => launchURL(researcher.url!),
                  ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(),
            ),
            ..._buildDetails(context),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.tonalIcon(
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.check_circle),
                label: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
