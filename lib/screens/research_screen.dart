import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_scatter/flutter_scatter.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graphview/GraphView.dart';
import 'package:ophd/api/fetch_publications.dart';
import 'package:ophd/api/fetch_researchers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:ophd/data/authors.dart';
import 'package:ophd/data/okabe_ito.dart';
import 'package:ophd/data/papers.dart';
import 'package:ophd/data/social_links.dart';
import 'package:ophd/models/author.dart';
import 'package:ophd/models/publication.dart';
import 'package:ophd/models/researcher.dart';
import 'package:ophd/models/social_link.dart';
import 'package:ophd/utils/screen_utils.dart';
import 'package:ophd/widgets/card_header_icon.dart';
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
  List<Publication>? publications;
  Map<Researcher, Set<Publication>> researcherToPublications = {};
  Map<Researcher, Map<Researcher, int>> researcherToWeightedCollaborators = {};
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

    // First fetch researchers, then fetch publications with the researchers data
    fetchResearchers().then((resData) {
      setState(() {
        allResearchers = resData;
      });
      return fetchPublications(allResearchers: allResearchers);
    }).then((pubData) {
      setState(() {
        publications = pubData;
        researcherToPublications = _getResearcherToPublications();
        // Update the weighted collaborators map
        final researchers = <Researcher>{...allResearchers!.students};
        researchers.addAll(selectedProfessors);
        researcherToWeightedCollaborators = _getResearcherToWeightedCollaborators(researchers);
        graph = _getGraph(widget.context);
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

  Map<Researcher, Set<Publication>> _getResearcherToPublications() {
    final Map<Researcher, Set<Publication>> researcherToPublications = {};

    for (final Publication publication in publications!) {
      if (publication.researchers == null) {
        continue;
      }

      for (final Researcher researcher in publication.researchers!) {
        researcherToPublications.putIfAbsent(researcher, () => <Publication>{});
        researcherToPublications[researcher]!.add(publication);
      }
    }

    return researcherToPublications;
  }

  Map<Researcher, int> _getWeightedCollaborators(Researcher researcher) {
    final Map<Researcher, int> weightedCollaborators = {};

    for (final Publication publication in researcherToPublications[researcher]!) {
      for (final Researcher collaborator in publication.researchers!) {
        if (collaborator != researcher) {
          weightedCollaborators.update(collaborator, (value) => value + 1, ifAbsent: () => 1);
        }
      }
    }
    return weightedCollaborators;
  }

  Map<Researcher, Map<Researcher, int>> _getResearcherToWeightedCollaborators(Set<Researcher> researchers) {
    final Map<Researcher, Map<Researcher, int>> researcherToWeightedCollaborators = {};

    for (final Researcher researcher in researcherToPublications.keys) {
      if (!researchers.contains(researcher)) {
        continue;
      }

      final Map<Researcher, int> weightedCollaborators = {};

      for (final Publication publication in researcherToPublications[researcher]!) {
        for (final Researcher collaborator in publication.researchers!) {
          // only add collaborator if they are in the selected researchers
          if (collaborator != researcher && researchers.contains(collaborator)) {
            weightedCollaborators.update(collaborator, (value) => value + 1, ifAbsent: () => 1);
          }
        }
      }

      researcherToWeightedCollaborators[researcher] = weightedCollaborators;
    }

    return researcherToWeightedCollaborators;
  }

  Graph _getGraph(BuildContext context) {
    final Graph graph = Graph();

    // Create map from researcher to node
    final Map<Researcher, Node> researcherToNode = {};

    // List<Researcher> allResearcherList = [...researchers.students, ...researchers.professors];
    Set<Researcher> allResearcherSetWithDups = <Researcher>{...allResearchers!.students};
    allResearcherSetWithDups.addAll(selectedProfessors);
    Set<Researcher> allResearcherSet = {};

    // Use the cached researcherToWeightedCollaborators map instead of recalculating it
    for (final Researcher researcher in allResearcherSetWithDups) {
      if (researcherToWeightedCollaborators[researcher] != null && researcherToWeightedCollaborators[researcher]!.isNotEmpty) {
        allResearcherSet.add(researcher);
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
      final weightedCollaborators = researcherToWeightedCollaborators[researcher] ?? {};
      for (final MapEntry<Researcher, int> entry in weightedCollaborators.entries) {
        final Researcher collaborator = entry.key;
        final int weight = entry.value;
        final Node? target = researcherToNode[collaborator];
        if (target != null) {
          // only add edge if source is alphabetically less than target
          if (source.key!.value.name.compareTo(target.key!.value.name) < 0) {
            graph.addEdge(source, target,
              paint: Paint()
                ..color = Theme.of(context).colorScheme.primary
                ..strokeWidth = log(weight + 1) / log(2) + 1
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
      // Update the weighted collaborators map when professors are selected/deselected
      final researchers = <Researcher>{...allResearchers!.students};
      researchers.addAll(selectedProfessors);
      researcherToWeightedCollaborators = _getResearcherToWeightedCollaborators(researchers);
      graph = _getGraph(widget.context);
      unconnectedStudents = _getUnconnectedStudents(graph!, allResearchers!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const CardHeaderIcon(
                icon: Icons.account_tree,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText(
                      AppLocalizations.of(context)!.labGraphTitle,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    SelectableText(
                      AppLocalizations.of(context)!.labGraphSubtitle,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                        fontFamily: 'RobotoMono',
                      ),
                    ),
                  ],
                ),
              ),
              RefreshButton(
                tooltip: AppLocalizations.of(context)!.label("Sync"),
                onPressed: () async {
                  await updateDatabase();
                  refetchResearchers();
                },
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 800,
            ),
            child: SelectableText.rich(
              TextSpan(
                children: [
                  TextSpan(text: AppLocalizations.of(context)!.labGraphDescriptionStart),
                  TextSpan(
                    text: AppLocalizations.of(context)!.labGraphDescriptionLink,
                    style: TextStyle(color: Theme.of(context).colorScheme.primary),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => launchURL('https://ics.uci.edu/~theory/'),
                  ),
                  TextSpan(text: AppLocalizations.of(context)!.labGraphDescriptionEnd),
                ],
              ),
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.start,
            ),
          ),
          const SizedBox(height: 16),
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else if (errorMessage != null)
            Center(child: SelectableText('Error: $errorMessage'))
          else
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(77),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant,
                      width: 1,
                    ),
                  ),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.start,
                    children: [
                      for (ProfessorResearcher researcher in allResearchers!.professors)
                        FilterChip(
                          label: Text(researcher.name),
                          selected: selectedProfessors.contains(researcher),
                          checkmarkColor: Colors.white,
                          avatar: CircleAvatar(
                            backgroundColor: professorColors[researcher],
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
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(77),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant,
                      width: 1,
                    ),
                  ),
                  child: LayoutBuilder(
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
                              Researcher researcher = node.key!.value as Researcher;
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
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(77),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectableText(
                        AppLocalizations.of(context)!.unconnectedLabMembersTitle,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SelectableText(
                        AppLocalizations.of(context)!.unconnectedLabMembersSubtitle(unconnectedStudents.length),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        alignment: WrapAlignment.start,
                        runAlignment: WrapAlignment.start,
                        children: [
                          for (StudentResearcher student in unconnectedStudents)
                            ActionChip(
                              label: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(student.name),
                                  if (student.hasDoctorate) ...[
                                    const SizedBox(width: 4),
                                    const Icon(
                                      Icons.school,
                                      size: 16,
                                    ),
                                  ]
                                ],
                              ),
                              onPressed: () => _showStudentDetails(context, student),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(77),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SelectableText(
                          AppLocalizations.of(context)!.labGraphInfo,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget displayProfessor(BuildContext context, ProfessorResearcher professor) {
    final int degree = researcherToWeightedCollaborators[professor]?.length ?? 0;
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
          researcherToPublications: researcherToPublications,
          weightedCollaborators: _getWeightedCollaborators(professor),
        );
      },
    );
  }

  Widget displayResearcher(context, Researcher i) {
    if (i is! StudentResearcher) return Container(); // Skip non-students

    return ActionChip(
      backgroundColor: i.name == 'Ofek Gila' ?
        Theme.of(context).colorScheme.tertiary :
        Theme.of(context).colorScheme.tertiaryContainer,
      labelStyle: TextStyle(
        color: i.name == 'Ofek Gila' ?
          Theme.of(context).colorScheme.onTertiary :
          Theme.of(context).colorScheme.onTertiaryContainer,
      ),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(i.name),
          if (i.hasDoctorate) ...[
            const SizedBox(width: 4),
            Icon(
              Icons.school,
              size: 16,
              color: i.name == 'Ofek Gila' ?
                Theme.of(context).colorScheme.onTertiary :
                Theme.of(context).colorScheme.onTertiaryContainer,
            ),
          ]
        ],
      ),
      onPressed: () => _showStudentDetails(context, i),
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
          researcherToPublications: researcherToPublications,
          weightedCollaborators: _getWeightedCollaborators(student),
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
  final Map<Researcher, Set<Publication>> researcherToPublications;
  // final Map<Researcher, Map<Researcher, int>> researcherToWeightedCollaborators;
  final Map<Researcher, int> weightedCollaborators;

  const ResearcherDetailsModal({
    super.key,
    required this.researcher,
    this.backgroundColor,
    required this.avatarIcon,
    required this.allResearchers,
    required this.researcherToPublications,
    required this.weightedCollaborators,
  });

  List<Widget> _buildDetails(BuildContext context) {
    final List<Widget> details = [];

    final collaborators = weightedCollaborators.keys.toList();
    final facultyCollaborators = collaborators.whereType<ProfessorResearcher>().length;
    final studentCollaborators = collaborators.whereType<StudentResearcher>().length;

    // Add researcher-specific details
    if (researcher is StudentResearcher) {
      final student = researcher as StudentResearcher;
      if (student.advisors != null && student.advisors!.isNotEmpty) {
        details.add(_buildInfoCard(
          context,
          Icons.supervisor_account,
          student.advisors!.length == 1 ? 'Advisor' : 'Advisors',
          student.advisors!.map((a) => a.name).join(", "),
        ));
      }

      if (student.hasDoctorate) {
        details.add(_buildInfoCard(
          context,
          Icons.school,
          'Graduation Year',
          student.year != null ? '${student.year} (PhD)' : 'Unknown (PhD)',
        ));
      }

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

    // Add publications by type if available
    final publications = _getResearcherPublications();
    if (publications.isNotEmpty) {
      final publicationsByType = _getPublicationsByType(publications);
      if (publicationsByType.isNotEmpty) {
        details.add(_buildInfoCard(
          context,
          Icons.category,
          'Publications by Type',
          '',
          customContent: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: publicationsByType.entries.map((entry) =>
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SelectableText(_formatPublicationType(entry.key)),
                    ),
                    SelectableText(
                      entry.value.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
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
    if (collaborators.isNotEmpty) {
      details.add(_buildInfoCard(
        context,
        Icons.people_alt,
        'Research Collaborations',
        '',
        customContent: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (facultyCollaborators > 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SelectableText('Faculty Co-authors'),
                    ),
                    SelectableText(
                      facultyCollaborators.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            if (studentCollaborators > 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SelectableText('Student Co-authors'),
                    ),
                    SelectableText(
                      studentCollaborators.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ));

      // Add top collaborators
      final topCollaborators = _getTopCollaborators(publications);
      if (topCollaborators.isNotEmpty) {
        details.add(_buildInfoCard(
          context,
          Icons.star,
          'Top Lab Collaborators',
          '',
          customContent: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: topCollaborators.entries.take(3).map((entry) =>
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SelectableText(entry.key.name),
                    ),
                    SelectableText(
                      '${entry.value} paper${entry.value == 1 ? '' : 's'}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              )
            ).toList(),
          ),
        ));
      }

      // Add recent collaborators
      final recentCollaborators = _getRecentCollaborators(publications);
      if (recentCollaborators.isNotEmpty) {
        details.add(_buildInfoCard(
          context,
          Icons.update,
          'Recent Lab Collaborators',
          '',
          customContent: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: recentCollaborators.take(3).map((collabData) =>
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SelectableText((collabData['researcher'] as Researcher).name),
                    ),
                    SelectableText(
                      (collabData['year'] as int).toString(),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              )
            ).toList(),
          ),
        ));
      }
    }

    // Add recent publications if available
    if (publications.isNotEmpty) {
      details.add(_buildInfoCard(
        context,
        Icons.article,
        'Recent Publications',
        '',
        customContent: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: publications.take(3).map((pub) =>
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SelectableText(
                          pub.title,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SelectableText(
                        pub.year.toString(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  SelectableText(
                    pub.authors.map((a) => a.name.replaceAll(RegExp(r'\s\d+$'), '')).join(', '),
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 1,
                  ),
                ],
              ),
            )
          ).toList(),
        ),
      ));
    }

    return details;
  }

  List<Publication> _getResearcherPublications() {
    // Get publications directly from the passed map
    final publications = researcherToPublications[researcher] ?? {};

    // Remove duplicates based on normalized titles
    final uniquePublications = _removeDuplicatePublications(publications.toList());

    // Sort by year (descending) and then by mdate if available
    uniquePublications.sort((a, b) {
      // First sort by year (descending)
      final yearComparison = b.year.compareTo(a.year);
      if (yearComparison != 0) {
        return yearComparison;
      }

      // If years are the same, sort by mdate (descending)
      return b.mdate.seconds.compareTo(a.mdate.seconds);
    });

    return uniquePublications;
  }

  /// Removes duplicate publications based on normalized titles
  List<Publication> _removeDuplicatePublications(List<Publication> publications) {
    // Map to track seen normalized titles
    final seenTitles = <String, Publication>{};

    for (final pub in publications) {
      // Normalize the title: lowercase and remove non-alphanumeric characters
      final normalizedTitle = _normalizeTitle(pub.title);

      // If we haven't seen this title before, or if this publication is newer (by mdate)
      // than the one we've seen, keep this one
      if (!seenTitles.containsKey(normalizedTitle) ||
          pub.mdate.seconds > seenTitles[normalizedTitle]!.mdate.seconds) {
        seenTitles[normalizedTitle] = pub;
      }
    }

    // Return the unique publications
    return seenTitles.values.toList();
  }

  /// Normalizes a title by converting to lowercase and removing non-alphanumeric characters
  String _normalizeTitle(String title) {
    return title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
  }

  /// Returns a map of publication types to counts
  Map<PublicationType, int> _getPublicationsByType(List<Publication> publications) {
    final typeCount = <PublicationType, int>{};

    for (final pub in publications) {
      typeCount.update(pub.type, (count) => count + 1, ifAbsent: () => 1);
    }

    // Sort by count (descending)
    final sortedEntries = typeCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Map.fromEntries(sortedEntries);
  }

  /// Formats a publication type for display
  String _formatPublicationType(PublicationType type) {
    switch (type) {
      case PublicationType.article:
        return 'Journal Articles';
      case PublicationType.inproceedings:
        return 'Conference Papers';
      case PublicationType.proceedings:
        return 'Proceedings';
      case PublicationType.book:
        return 'Books';
      case PublicationType.incollection:
        return 'Book Chapters';
      case PublicationType.phdthesis:
        return 'PhD Theses';
      case PublicationType.unknown:
        return 'Other Publications';
    }
  }

  /// Returns a list of recent lab collaborators with their most recent collaboration year
  List<Map<String, dynamic>> _getRecentCollaborators(List<Publication> publications) {
    // Sort publications by date (most recent first)
    final sortedPubs = List<Publication>.from(publications)
      ..sort((a, b) => b.mdate.seconds.compareTo(a.mdate.seconds));

    // Map to track the most recent collaborators we've seen
    final recentCollaborators = <String, Map<String, dynamic>>{};

    // Loop through publications in order of recency
    for (final pub in sortedPubs) {
      // Skip if this publication doesn't have researchers listed
      if (pub.researchers == null || pub.researchers!.isEmpty) continue;

      // Find collaborators in this publication
      for (final labMember in pub.researchers!) {
        // Skip if this is the researcher we're looking at
        if (labMember.name == researcher.name) continue;

        if (!recentCollaborators.containsKey(labMember.name)) {
          recentCollaborators[labMember.name] = {
            'researcher': labMember,
            'year': pub.year,
          };

          if (recentCollaborators.length >= 5) break;
        }
      }

      if (recentCollaborators.length >= 5) break;
    }

    return recentCollaborators.values.toList();
  }

  /// Returns a map of top collaborators sorted by number of shared papers
  Map<dynamic, int> _getTopCollaborators(List<Publication> publications) {
    // Filter to only include lab collaborators (researchers in the system)
    final labCollaborators = <dynamic, int>{};
    for (final entry in weightedCollaborators.entries) {
      labCollaborators[entry.key] = entry.value;
    }

    // Sort by count (descending)
    final sortedEntries = labCollaborators.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Map.fromEntries(sortedEntries);
  }

  Widget _buildInfoCard(BuildContext context, IconData icon, String label, String value, {Widget? customContent}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(77),
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
    final bool hasPhd = researcher is StudentResearcher ? (researcher as StudentResearcher).hasDoctorate : true;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800, maxHeight: 700),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header - Fixed at the top
            Row(
              children: [
                CardHeaderIcon(
                  icon: hasPhd ? FontAwesomeIcons.userGraduate : avatarIcon,
                  backgroundColor: backgroundColor,
                  size: hasPhd ? 32 : 40,
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
                if (researcher.dblpPid.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: IconButton.filledTonal(
                      style: IconButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      icon: SvgPicture.asset(
                        'assets/images/dblp_icon.svg',
                        width: 24,
                        height: 24,
                      ),
                      tooltip: 'View on DBLP',
                      onPressed: () => launchURL('https://dblp.org/pid/${researcher.dblpPid}'),
                    ),
                  ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(),
            ),

            // Content - Scrollable
            Expanded(
              child: SingleChildScrollView(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Determine the number of columns based on available width
                    final crossAxisCount = constraints.maxWidth > 600 ? 2 : 1;

                    return MasonryGridView.count(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _buildDetails(context).length,
                      itemBuilder: (context, index) {
                        return _buildDetails(context)[index];
                      },
                    );
                  },
                ),
              ),
            ),

            // Footer - Fixed at the bottom
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
