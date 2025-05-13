import 'dart:convert';
import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ophd/data/lab_screen_cache.dart';
import 'package:ophd/generated/l10n/app_localizations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graphview/GraphView.dart';
import 'package:ophd/api/fetch_publications.dart';
import 'package:ophd/api/fetch_researchers.dart';
import 'package:ophd/models/publication.dart';
import 'package:ophd/models/researcher.dart';
import 'package:ophd/theme.dart';
import 'package:ophd/utils/lab_utils.dart';
import 'package:ophd/utils/screen_utils.dart';
import 'package:ophd/widgets/card_header_icon.dart';
import 'package:ophd/widgets/refresh.dart';
import 'package:ophd/widgets/standard_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LabScreenCache {
  static void printSampleDataForCache(AllResearchers allResearchers, Map<Researcher, Set<Publication>> researcherToPublicationsMap) {
    // first, sample 5 researchers of each type
    final sampleResearchers = <Researcher>{};
    sampleResearchers.addAll(allResearchers.students.where(LabUtils.isCurrentStudent).take(5));
    sampleResearchers.addAll(allResearchers.students.where(LabUtils.isNonPostDocGraduated).take(5));
    sampleResearchers.addAll(allResearchers.students.where(LabUtils.isPostDoc).take(5));
    sampleResearchers.addAll(allResearchers.professors.where(LabUtils.isCurrentFaculty).take(5));
    sampleResearchers.addAll(allResearchers.professors.where(LabUtils.isEmeritusFaculty).take(5));

    final sampleAllResearchers = AllResearchers(students: sampleResearchers.whereType<StudentResearcher>().toList(), professors: sampleResearchers.whereType<ProfessorResearcher>().toList());

    // then, sample 1 publication for each researcher
    final samplePublications = <Publication>{};
    for (final researcher in sampleResearchers) {
      final publications = researcherToPublicationsMap[researcher];
      if (publications != null &&publications.isNotEmpty) {
        samplePublications.add(publications.first);
      }
    }

    // ignore: avoid_print
    print(jsonEncode(sampleAllResearchers.toJson()));
    // ignore: avoid_print
    print(jsonEncode(samplePublications.map((p) => p.toJson()).toList()));
  }

  static AllResearchers getSampleAllResearchers() {
    return AllResearchers.fromJson(jsonDecode(allResearcherCache));
  }

  static List<Publication> getSamplePublications(AllResearchers allResearchers) {
    final publications = (jsonDecode(publicationCache) as List<dynamic>).map((p) => Publication.fromJson(p)).toList();

    linkPublicationsToResearchers(publications, allResearchers);

    return publications;
  }
}

class LabPage extends StatefulWidget {
  const LabPage({super.key});

  @override
  State<LabPage> createState() => _LabPageState();
}

class _LabPageState extends State<LabPage> {
  AllResearchers? allResearchers;
  List<Publication>? publications;
  // Map from researcher to their publications, containing duplicates
  Map<Researcher, Set<Publication>>? researcherToPublicationsMap;
  bool isLoading = true;
  String? errorMessage;
  final bool debug = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData({bool forceUpdate = false}) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    if (debug && !forceUpdate) {
      final allResearchers = LabScreenCache.getSampleAllResearchers();
      final publications = LabScreenCache.getSamplePublications(allResearchers);
      setState(() {
        this.allResearchers = allResearchers;
        this.publications = publications;
        researcherToPublicationsMap = LabUtils.getResearcherToPublicationsMap(publications);
        isLoading = false;
      });
      return;
    }

    try {
      // First fetch researchers
      final researcherData = await fetchResearchers();
      setState(() {
        allResearchers = researcherData;
      });

      // Then fetch publications with the researchers data
      final publicationData = await fetchPublications(allResearchers: allResearchers);
      setState(() {
        publications = publicationData;
        researcherToPublicationsMap = LabUtils.getResearcherToPublicationsMap(publications!);
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use sample data for skeleton loading
    final sampleAllResearchers = isLoading && errorMessage == null ? LabScreenCache.getSampleAllResearchers() : allResearchers!;
    final samplePublications = isLoading && errorMessage == null ? LabScreenCache.getSamplePublications(sampleAllResearchers) : publications!;
    final sampleResearcherToPublicationsMap = isLoading && errorMessage == null ?
        LabUtils.getResearcherToPublicationsMap(samplePublications) : researcherToPublicationsMap!;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            CardWrapper(child: _buildLabInfoBlock(context)),
            // Show skeleton or actual content
            const SizedBox(height: 20),
            CardWrapper(child: _buildDisclaimerBlock(context)),
            const SizedBox(height: 20),
            Skeletonizer(
              enabled: isLoading,
              child: CardItself(
                child: isLoading || errorMessage == null ? LabGraph(
                  allResearchers: sampleAllResearchers,
                  publications: samplePublications,
                  researcherToPublicationsMap: sampleResearcherToPublicationsMap,
                  onRefresh: _loadData,
                ) : const SizedBox(),
              ),
            ),
            const SizedBox(height: 20),
            Skeletonizer(
              enabled: isLoading,
              child: CardItself(
                child: isLoading || errorMessage == null ? LabHighlights(
                  allResearchers: sampleAllResearchers,
                  publications: samplePublications,
                  researcherToPublicationsMap: sampleResearcherToPublicationsMap,
                ) : const SizedBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabInfoBlock(BuildContext context) {
    return Column(
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
                    'UCI Theory Lab',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  SelectableText(
                    'Exploring theoretical computer science since 1975',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontFamily: 'RobotoMono',
                    ),
                  ),
                ],
              ),
            ),
            if (isLoading)
              RefreshButton(
                forceLoading: true,
                tooltip: 'Loading Lab Data',
                key: UniqueKey(),
              ),
            if (!isLoading && errorMessage == null)
              RefreshButton(
                onPressed: () async {
                  await updateDatabase();
                  await _loadData();
                },
                tooltip: 'Sync Database',
                key: UniqueKey(),
              ),
            if (debug)
              RefreshButton(
                onPressed: () async {
                  await _loadData(forceUpdate: true);
                },
                tooltip: 'Fetch Real Data',
                key: UniqueKey(),
              ),
          ],
        ),
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Divider(),
        ),
        if (errorMessage != null)
          Center(
            child: Column(
              children: [
                Icon(Icons.error_outline, color: Theme.of(context).colorScheme.error, size: 48),
                const SizedBox(height: 16),
                Text('Error: $errorMessage', style: TextStyle(color: Theme.of(context).colorScheme.error)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadData,
                  child: const Text('Try Again'),
                ),
              ],
            ),
          )
        else
          SelectableText(
            'This page showcases the Theory Lab at the University of California, Irvine. '
            'It includes a visualization of lab collaborations, highlights of research achievements, '
            'and statistics about publications, students, and faculty members over the years.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.start,
          ),
      ],
    );
  }

  Widget _buildDisclaimerBlock(BuildContext context) {
    // block that states that the data is from DBLP, that there may be missing stuff, etc.,
    return Column(
      children: [
        Row(
          children: [
            const CardHeaderIcon(
              icon: Icons.warning_amber,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText(
                    'Disclaimer',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  SelectableText(
                    'Data may not be 100% accurate',
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
        SelectableText.rich(
          TextSpan(
            children: [
              TextSpan(text: 'Knowledge of lab members is taken from '),
              TextSpan(
                text: 'David Eppstein\'s fabulous UCI computer science theory page',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => launchURL('https://ics.uci.edu/~theory/'),
              ),
              TextSpan(text: '. The rest of the data is taken from '),
              TextSpan(
                text: 'DBLP',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => launchURL('https://dblp.org/'),
              ),
              TextSpan(text: ', which is a database of computer science publications. DBLP was chosen because it assigns each researcher a unique ID automatically, it includes historical data, and it is fairly comprehensive. Alternatives, such as Google Scholar and ORCID, require the user to manually create their profile. DBLP is not perfect, however, being less comprehensive than Google Scholar, and not containing citation information which would have been nice to have. That being said, if there are any publications or changes you would like me to manually add, please contact me.'),
            ],
          ),
          style: Theme.of(context).textTheme.bodyLarge,
        )
      ],
    );
  }
}

class LabGraph extends StatefulWidget {
  final AllResearchers allResearchers;
  final List<Publication> publications;
  final Map<Researcher, Set<Publication>> researcherToPublicationsMap;
  final Function() onRefresh;

  const LabGraph({
    super.key,
    required this.allResearchers,
    required this.publications,
    required this.researcherToPublicationsMap,
    required this.onRefresh,
  });

  @override
  State<LabGraph> createState() => _LabGraphState();
}

class _LabGraphState extends State<LabGraph> {
  Set<ProfessorResearcher> selectedProfessors = {};
  Map<ProfessorResearcher, Color> professorColors = {};
  late Set<Color> remainingColors;
  Map<Researcher, Map<Researcher, int>> researcherToWeightedEdgesMap = {};
  Set<StudentResearcher> unconnectedStudents = {};
  bool isLoading = true;
  String? errorMessage;
  Graph? graph;

  @override
  void initState() {
    super.initState();

    // Schedule the rest of the initialization for after the first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeGraph();
    });
  }

  void _initializeGraph() {
    if (!mounted) return;

    setState(() {
      // Initialize the remainingColors set with Okabe-Ito colors
      final materialTheme = MaterialTheme(Theme.of(context).textTheme);
      remainingColors = materialTheme.getOkabeItoChartColorList(context).toSet();

      // Update the weighted collaborators map
      final researchers = <Researcher>{...widget.allResearchers.students};
      researchers.addAll(selectedProfessors);
      researcherToWeightedEdgesMap = _getResearcherToWeightedEdgesMap(researchers);
      graph = _getGraph(context);
      unconnectedStudents = _getUnconnectedStudents(graph!, widget.allResearchers);
      isLoading = false;
    });
  }

  Map<Researcher, Map<Researcher, int>> _getResearcherToWeightedEdgesMap(Set<Researcher> researchers) {
    final Map<Researcher, Map<Researcher, int>> researcherToWeightedCollaborators = {};

    for (final Researcher researcher in widget.researcherToPublicationsMap.keys) {
      if (!researchers.contains(researcher)) {
        continue;
      }

      final Map<Researcher, int> weightedCollaborators = {};

      for (final Publication publication in widget.researcherToPublicationsMap[researcher]!) {
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
    Set<Researcher> allResearcherSetWithDups = <Researcher>{...widget.allResearchers.students};
    allResearcherSetWithDups.addAll(selectedProfessors);
    Set<Researcher> allResearcherSet = {};

    // Use the cached researcherToWeightedCollaborators map instead of recalculating it
    for (final Researcher researcher in allResearcherSetWithDups) {
      if (researcherToWeightedEdgesMap[researcher] != null && researcherToWeightedEdgesMap[researcher]!.isNotEmpty) {
        allResearcherSet.add(researcher);
      }
    }

    // Add nodes for each researcher
    for (final Researcher researcher in allResearcherSet) {
      final Node node = Node.Id(researcher);
      graph.addNode(node);
      researcherToNode[researcher] = node;
    }

    // Add edges for each collaborator
    for (final Researcher researcher in allResearcherSet) {
      final Node source = researcherToNode[researcher]!;
      final weightedCollaborators = researcherToWeightedEdgesMap[researcher] ?? {};
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
      // Make sure remainingColors is initialized
      if (remainingColors.isEmpty) {
        final materialTheme = MaterialTheme(Theme.of(context).textTheme);
        remainingColors = materialTheme.getOkabeItoChartColorList(context).toSet();
      }

      // Update the weighted collaborators map when professors are selected/deselected
      final researchers = <Researcher>{...widget.allResearchers.students};
      researchers.addAll(selectedProfessors);
      researcherToWeightedEdgesMap = _getResearcherToWeightedEdgesMap(researchers);
      graph = _getGraph(context);
      unconnectedStudents = _getUnconnectedStudents(graph!, widget.allResearchers);
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
                  decoration: LabUtils.getCommonContainerDecoration(context),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.start,
                    children: [
                      for (ProfessorResearcher researcher in widget.allResearchers.professors)
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
                                  remainingColors = MaterialTheme(Theme.of(context).textTheme).getOkabeItoChartColorList(context).toSet();
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
                  decoration: LabUtils.getCommonContainerDecoration(context),
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
                  decoration: LabUtils.getCommonContainerDecoration(context),
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
                              onPressed: () => _showResearcherDetails(context, student),
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
    final int degree = researcherToWeightedEdgesMap[professor]?.length ?? 0;
    final double size = (log(degree) + 1) * 30.0;
    final Color color = professorColors[professor]!;

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showResearcherDetails(context, professor),
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

  void _showResearcherDetails(BuildContext context, Researcher researcher) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Special handling for Ofek Gila
        final bool isOfek = researcher.name == 'Ofek Gila';

        return ResearcherDetailsModal(
          researcher: researcher,
          backgroundColor: researcher is ProfessorResearcher ? professorColors[researcher] : null,
          avatarIcon: researcher is ProfessorResearcher ? Icons.school : Icons.person,
          // Use profile image for Ofek
          useProfileImage: isOfek,
          allResearchers: widget.allResearchers,
          researcherToPublications: widget.researcherToPublicationsMap,
          weightedCollaborators: LabUtils.getWeightedCollaborators(researcher, widget.researcherToPublicationsMap[researcher]),
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
      onPressed: () => _showResearcherDetails(context, i),
    );
  }
}

class ResearcherDetailsModal extends StatelessWidget {
  final Researcher researcher;
  final Color? backgroundColor;
  final IconData avatarIcon;
  final bool useProfileImage;
  final AllResearchers? allResearchers;
  final Map<Researcher, Set<Publication>> researcherToPublications;
  final Map<Researcher, int> weightedCollaborators;

  const ResearcherDetailsModal({
    super.key,
    required this.researcher,
    this.backgroundColor,
    required this.avatarIcon,
    this.useProfileImage = false,
    required this.allResearchers,
    required this.researcherToPublications,
    required this.weightedCollaborators,
  });

  Widget _buildNoDataCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: LabUtils.getCommonContainerDecoration(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            size: 24,
            color: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  AppLocalizations.of(context)!.noInformationAvailable,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 8),
                SelectableText(
                  AppLocalizations.of(context)!.noInformationAvailableDescription,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDetails(BuildContext context) {
    final List<Widget> details = [];

    final collaborators = weightedCollaborators.keys.toList();
    final facultyCollaborators = collaborators.whereType<ProfessorResearcher>().length;
    final studentCollaborators = collaborators.whereType<StudentResearcher>().length;

    // Get publications for this researcher
    final publications = LabUtils.getSortedPublications(researcherToPublications[researcher], true);
    final allPublications = LabUtils.getSortedPublications(researcherToPublications[researcher], false);

    // Check if we have any data to display
    bool hasAdvisorInfo = researcher is StudentResearcher &&
                          (researcher as StudentResearcher).advisors != null &&
                          (researcher as StudentResearcher).advisors!.isNotEmpty;
    bool hasGraduationInfo = researcher is StudentResearcher && (researcher as StudentResearcher).hasDoctorate;
    bool hasThesisInfo = researcher is StudentResearcher && (researcher as StudentResearcher).thesisTitle != null;
    bool hasStudentInfo = researcher is ProfessorResearcher && allResearchers != null;
    bool hasPublications = publications.isNotEmpty;
    bool hasCollaborators = collaborators.isNotEmpty;

    // If we don't have any data to display, show a message
    if (!hasAdvisorInfo && !hasGraduationInfo && !hasThesisInfo &&
        !hasStudentInfo && !hasPublications && !hasCollaborators) {
      details.add(_buildNoDataCard(context));
      return details;
    }

    // Add researcher-specific details
    if (researcher is StudentResearcher) {
      final student = researcher as StudentResearcher;
      if (student.advisors != null && student.advisors!.isNotEmpty) {
        details.add(LabUtils.buildLabelValueCard(
          context: context,
          icon: Icons.supervisor_account,
          title: AppLocalizations.of(context)!.advisor(student.advisors!.length),
          items: [MapEntry('', student.advisors!.map((a) => a.name).join(", "))],
          maxItems: 1,
          emphasizeNames: false,
        ));
      }

      if (student.hasDoctorate) {
        details.add(LabUtils.buildLabelValueCard(
          context: context,
          icon: Icons.school,
          title: AppLocalizations.of(context)!.graduationYear,
          items: [MapEntry('', student.year != null ? '${student.year!} (PhD)' : 'Unknown (PhD)')],
          maxItems: 1,
          emphasizeNames: false,
        ));
      }

      if (student.thesisTitle != null) {
        details.add(LabUtils.buildLabelValueCard(
          context: context,
          icon: Icons.menu_book,
          title: AppLocalizations.of(context)!.thesisTitle,
          items: [MapEntry(student.thesisTitle!, '')],
          maxItems: 1,
          emphasizeNames: false,
        ));
      }
    } else if (researcher is ProfessorResearcher) {
      final professor = researcher as ProfessorResearcher;
      final gradStudents = allResearchers!.students.where((s) =>
        s.advisors?.any((a) => a.name == professor.name) ?? false).toList()
        ..sort((a, b) => (a.year ?? 9999).compareTo(b.year ?? 9999));

      final graduatedStudents = gradStudents.where((s) => s.hasDoctorate).toList();
      final yearRange = graduatedStudents.isEmpty ? null :
        graduatedStudents.first.year == graduatedStudents.last.year ?
        graduatedStudents.first.year! : '${graduatedStudents.first.year!} – ${graduatedStudents.last.year!}';

      details.add(LabUtils.buildLabelValueCard(
        context: context,
        icon: Icons.groups,
        title: AppLocalizations.of(context)!.graduateStudents,
        items: [MapEntry(
          'Students',
          '${LabUtils.formatNumber(graduatedStudents.length)}${yearRange != null ? ' ($yearRange)' : ''}'
        )],
        maxItems: 1,
        emphasizeNames: false,
      ));

      if (graduatedStudents.isNotEmpty) {
        final items = graduatedStudents.reversed.take(3).map((s) =>
          MapEntry(s.name, s.year != null ? s.year!.toString() : 'Unknown')
        ).toList();

        details.add(LabUtils.buildLabelValueCard(
          context: context,
          icon: Icons.history_edu,
          title: AppLocalizations.of(context)!.recentGraduates,
          items: items,
        ));
      }
    }

    // Add publications by type if available
    if (publications.isNotEmpty) {
      final publicationsByType = LabUtils.getPublicationsByType(allPublications);
      if (publicationsByType.isNotEmpty) {
        final items = publicationsByType.entries.map((entry) =>
          MapEntry(LabUtils.formatPublicationType(context, entry.key), LabUtils.formatNumber(entry.value))
        ).toList();

        details.add(LabUtils.buildLabelValueCard(
          context: context,
          icon: Icons.category,
          title: AppLocalizations.of(context)!.publicationsByType,
          items: items,
          maxItems: publicationsByType.length, // Show all publication types
        ));
      }
    }

    // Add shared collaboration details
    if (collaborators.isNotEmpty) {
      final items = <MapEntry<String, String>>[];

      if (facultyCollaborators > 0) {
        items.add(MapEntry(AppLocalizations.of(context)!.facultyCoauthors, LabUtils.formatNumber(facultyCollaborators)));
      }

      if (studentCollaborators > 0) {
        items.add(MapEntry(AppLocalizations.of(context)!.studentCoauthors, LabUtils.formatNumber(studentCollaborators)));
      }

      details.add(LabUtils.buildLabelValueCard(
        context: context,
        icon: Icons.people_alt,
        title: AppLocalizations.of(context)!.researchCollaborations,
        items: items,
      ));

      // Add top collaborators
      if (weightedCollaborators.isNotEmpty) {
        final topCollaborationItems = weightedCollaborators.entries.take(3).map((entry) =>
          MapEntry(entry.key.name, '${LabUtils.formatNumber(entry.value)} ${AppLocalizations.of(context)!.paperCount(entry.value)}')
        ).toList();

        details.add(LabUtils.buildLabelValueCard(
          context: context,
          icon: Icons.star,
          title: AppLocalizations.of(context)!.topLabCollaborators,
          items: topCollaborationItems,
        ));
      }

      // Add recent collaborators
      final recentCollaborators = LabUtils.getRecentCollaborators(researcher, publications);
      if (recentCollaborators.isNotEmpty) {
        final recentCollaborationItems = recentCollaborators.take(3).map((collaborator) =>
          MapEntry(collaborator.researcher.name, collaborator.year.toString())
        ).toList();

        details.add(LabUtils.buildLabelValueCard(
          context: context,
          icon: Icons.update,
          title: AppLocalizations.of(context)!.recentLabCollaborators,
          items: recentCollaborationItems,
        ));
      }
    }

    // Add recent publications if available
    if (publications.isNotEmpty) {
      details.add(LabUtils.buildPublicationsCard(
        context: context,
        icon: Icons.article,
        title: AppLocalizations.of(context)!.recentPublications,
        publications: publications.take(3).toList(),
      ));
    }

    return details;
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
                useProfileImage
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/images/profile.jpg',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    )
                  : CardHeaderIcon(
                      icon: hasPhd ? FontAwesomeIcons.userGraduate : avatarIcon,
                      backgroundColor: backgroundColor,
                      size: hasPhd ? 32 : 40,
                    ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LabUtils.emphasizedText(
                        context,
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
                    tooltip: AppLocalizations.of(context)!.visitWebsite,
                    onPressed: () => launchURL(researcher.url!),
                  ),
                if (researcher.dblpPid.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(
                      left: Directionality.of(context) == TextDirection.ltr ? 8 : 0,
                      right: Directionality.of(context) == TextDirection.rtl ? 8 : 0,
                    ),
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
                      tooltip: AppLocalizations.of(context)!.viewOnDblp,
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
                    int crossAxisCount = max(1, constraints.maxWidth ~/ 300);
                    final List<Widget> blocks = _buildDetails(context);

                    return MasonryGridView.count(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: blocks.length,
                      itemBuilder: (context, index) {
                        return blocks[index];
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
                label: Text(AppLocalizations.of(context)!.done),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LabHighlights extends StatelessWidget {
  final AllResearchers allResearchers;
  final List<Publication> publications;
  final Map<Researcher, Set<Publication>> researcherToPublicationsMap;

  const LabHighlights({
    super.key,
    required this.allResearchers,
    required this.publications,
    required this.researcherToPublicationsMap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const CardHeaderIcon(
              icon: Icons.insights,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText(
                    'Lab Highlights',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  SelectableText(
                    'Key statistics and insights about the lab',
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
        LayoutBuilder(
          builder: (context, constraints) {
            // Generate a complete weighted collaborators map for all researchers
            final completeCollaboratorsMap = LabUtils.getCompleteWeightedCollaboratorsMap(researcherToPublicationsMap);

            final uniquePublications = LabUtils.removeDuplicatePublications(publications);
            final uniqueCollaborations = uniquePublications.where(LabUtils.isCollaboration);

            // Calculate column counts for both grids
            int chartCrossAxisCount = max(1, constraints.maxWidth ~/ 600);
            int mainCrossAxisCount = max(1, constraints.maxWidth ~/ 400);

            // Create chart cards separately
            final List<Widget> chartCards = [
              _buildPublicationsPerYearCard(context, uniquePublications),
              _buildCollaborationsPerYearCard(context, uniqueCollaborations),
              _buildPublicationTypesPieChartCard(context, uniquePublications),
              _buildGraduationsPerYearCard(context),
              _buildLabMembersDonutChartCard(context),
            ];

            // Build all other cards for the main grid
            final List<Widget> mainCards = _buildHighlightCards(context, uniquePublications, uniqueCollaborations, completeCollaboratorsMap);

            return Column(
              children: [
                // Charts grid with fewer columns
                MasonryGridView.count(
                  crossAxisCount: chartCrossAxisCount,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: chartCards.length,
                  itemBuilder: (context, index) {
                    return chartCards[index];
                  },
                ),

                const SizedBox(height: 16),

                // Main grid with more columns
                MasonryGridView.count(
                  crossAxisCount: mainCrossAxisCount,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: mainCards.length,
                  itemBuilder: (context, index) {
                    return mainCards[index];
                  },
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  List<Widget> _buildHighlightCards(BuildContext context, Iterable<Publication> uniquePublications, Iterable<Publication> uniqueCollaborations, Map<Researcher, Map<Researcher, int>> completeCollaboratorsMap) {
    final List<Widget> cards = [];

    // Lab overview stats
    cards.add(_buildLabOverviewStatsCard(context, uniquePublications.length, uniqueCollaborations.length));

    cards.add(_buildRecentGraduatesCard(context));

    cards.add(_buildRecentPapersCard(context, Icons.article, 'Recent Current Student Papers', LabUtils.isCurrentStudentPaper, uniquePublications));
    cards.add(_buildRecentPapersCard(context, Icons.article, 'Recent Graduated Student Papers', LabUtils.isNonPostDocGraduatedPaper, uniquePublications));
    cards.add(_buildRecentPapersCard(context, Icons.article, 'Recent Postdoc Papers', LabUtils.isPostDocPaper, uniquePublications));
    cards.add(_buildRecentPapersCard(context, Icons.article, 'Recent Current Faculty Papers', LabUtils.isCurrentFacultyPaper, uniquePublications));
    cards.add(_buildRecentPapersCard(context, Icons.article, 'Recent Emeritus Faculty Papers', LabUtils.isEmeritusFacultyPaper, uniquePublications));
    cards.add(_buildRecentPapersCard(context, Icons.people_alt, 'Recent Lab Collaborations', LabUtils.isCollaboration, uniqueCollaborations));

    cards.add(_buildWellConnectedCard(context, completeCollaboratorsMap, LabUtils.isCurrentStudent, 'Well-Connected Current Students'));
    cards.add(_buildWellConnectedCard(context, completeCollaboratorsMap, LabUtils.isNonPostDocGraduated, 'Well-Connected Graduated Students'));
    cards.add(_buildWellConnectedCard(context, completeCollaboratorsMap, LabUtils.isPostDoc, 'Well-Connected Postdocs'));
    cards.add(_buildWellConnectedCard(context, completeCollaboratorsMap, LabUtils.isCurrentFaculty, 'Well-Connected Current Faculty'));
    cards.add(_buildWellConnectedCard(context, completeCollaboratorsMap, LabUtils.isEmeritusFaculty, 'Well-Connected Emeritus Faculty'));

    cards.add(_buildProlificResearchersCard(context, LabUtils.isCurrentStudent, 'Prolific Current Students'));
    cards.add(_buildProlificResearchersCard(context, LabUtils.isNonPostDocGraduated, 'Prolific Graduated Students'));
    cards.add(_buildProlificResearchersCard(context, LabUtils.isPostDoc, 'Prolific Postdocs'));
    cards.add(_buildProlificResearchersCard(context, LabUtils.isCurrentFaculty, 'Prolific Current Faculty'));
    cards.add(_buildProlificResearchersCard(context, LabUtils.isEmeritusFaculty, 'Prolific Emeritus Faculty'));

    cards.add(_buildFacultyWithMostGraduatesCard(context, LabUtils.isCurrentFaculty, 'Current Faculty with Most Graduates'));
    cards.add(_buildFacultyWithMostGraduatesCard(context, LabUtils.isEmeritusFaculty, 'Emeritus Faculty with Most Graduates'));

    return cards;
  }

  Widget _buildPublicationsPerYearCard(BuildContext context, Iterable<Publication> uniquePublications) {
    // Count publications per year
    final publicationsPerYear = <int, int>{};

    // Count publications per year
    for (final pub in uniquePublications) {
      publicationsPerYear.update(pub.year, (value) => value + 1, ifAbsent: () => 1);
    }

    final materialTheme = MaterialTheme(Theme.of(context).textTheme);

    return LabUtils.buildYearlyLineChartCard(
      context: context,
      icon: Icons.show_chart,
      title: 'Publications Per Year',
      dataByYear: publicationsPerYear,
      lineColor: materialTheme.getPastelChartColorByIndex(context, 0),
      tooltipTextColor: Colors.white,
      yAxisLabel: 'Publications',
      height: 308,
    );
  }

  Widget _buildCollaborationsPerYearCard(BuildContext context, Iterable<Publication> collaborations) {
    // Count collaborations per year
    final collaborationsPerYear = <int, int>{};

    // Count collaborations per year
    for (final pub in collaborations) {
      collaborationsPerYear.update(pub.year, (value) => value + 1, ifAbsent: () => 1);
    }

    final materialTheme = MaterialTheme(Theme.of(context).textTheme);

    return LabUtils.buildYearlyLineChartCard(
      context: context,
      icon: Icons.show_chart,
      title: 'Collaborations Per Year',
      dataByYear: collaborationsPerYear,
      lineColor: materialTheme.getPastelChartColorByIndex(context, 1),
      tooltipTextColor: Colors.white,
      yAxisLabel: 'Collaborations',
    );
  }

  Widget _buildGraduationsPerYearCard(BuildContext context) {
    // Count graduations per year
    final graduationsPerYear = <int, int>{};

    // Count graduations per year for students with graduation years
    for (final student in allResearchers.students) {
      if (student.hasDoctorate && student.year != null) {
        graduationsPerYear.update(student.year!, (value) => value + 1, ifAbsent: () => 1);
      }
    }

    final materialTheme = MaterialTheme(Theme.of(context).textTheme);

    return LabUtils.buildYearlyLineChartCard(
      context: context,
      icon: Icons.school,
      title: 'Graduations Per Year',
      dataByYear: graduationsPerYear,
      lineColor: materialTheme.getPastelChartColorByIndex(context, 2),
      tooltipTextColor: Colors.white,
      yAxisLabel: 'Graduations',
    );
  }

  Widget _buildLabOverviewStatsCard(BuildContext context, int publicationCount, int collaborationCount) {
    final currentStudentCount = allResearchers.students.where(LabUtils.isCurrentStudent).length;
    final graduatedStudentCount = allResearchers.students.where(LabUtils.isNonPostDocGraduated).length;
    final postDocCount = allResearchers.students.where(LabUtils.isPostDoc).length;
    final currentFacultyCount = allResearchers.professors.where(LabUtils.isCurrentFaculty).length;
    final emeritusFacultyCount = allResearchers.professors.where(LabUtils.isEmeritusFaculty).length;

    return LabUtils.buildLabelValueCard(
      context: context,
      icon: Icons.analytics,
      title: 'Lab Overview',
      items: [
        MapEntry('Current Students', LabUtils.formatNumber(currentStudentCount)),
        MapEntry('Graduated Students', LabUtils.formatNumber(graduatedStudentCount)),
        MapEntry('Postdocs', LabUtils.formatNumber(postDocCount)),
        MapEntry('Current Faculty', LabUtils.formatNumber(currentFacultyCount)),
        MapEntry('Emeritus Faculty', LabUtils.formatNumber(emeritusFacultyCount)),
        MapEntry('Distinct Publications', LabUtils.formatNumber(publicationCount)),
        MapEntry('Lab Collaborations', LabUtils.formatNumber(collaborationCount)),
        MapEntry('Years Active', '1975 – Present'),
      ],
      maxItems: 6,
    );
  }

  Widget _buildRecentGraduatesCard(BuildContext context) {
    final graduatedStudents = allResearchers.students
        .where((s) => s.hasDoctorate && s.year != null)
        .toList()
        ..sort((a, b) => (b.year ?? 0).compareTo(a.year ?? 0));

    final items = graduatedStudents.map((s) =>
      MapEntry(s.name, s.year.toString())
    ).toList();

    return LabUtils.buildLabelValueCard(
      context: context,
      icon: Icons.school,
      title: 'Recent Graduates',
      items: items,
    );
  }

  Widget _buildRecentPapersCard(BuildContext context, IconData icon, String title, bool Function(Publication) filter, Iterable<Publication> uniquePublications) {
    final relevantPublications = LabUtils.getSortedPublications(uniquePublications.where(filter), false);

    return LabUtils.buildPublicationsCard(
      context: context,
      icon: icon,
      title: title,
      publications: relevantPublications,
      maxItems: 5,
    );
  }

  Widget _buildWellConnectedCard(BuildContext context, Map<Researcher, Map<Researcher, int>> completeCollaboratorsMap, bool Function(Researcher) filter, String title) {
    final filteredResearchers = completeCollaboratorsMap.keys.where(filter);

    final collaborationOverviews = LabUtils.getCollaborationOverviewList(filteredResearchers, completeCollaboratorsMap);

    final maxTotalOverview = collaborationOverviews.reduce((a, b) => a.totalCollaborations > b.totalCollaborations ? a : b);
    final maxStudentOverview = collaborationOverviews.reduce((a, b) => a.studentCollaborations > b.studentCollaborations ? a : b);
    final maxProfessorOverview = collaborationOverviews.reduce((a, b) => a.professorCollaborations > b.professorCollaborations ? a : b);

    return _buildInfoCard(
      context,
      Icons.people,
      title,
      '',
      customContent: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  'Most Total Collaborations',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: LabUtils.emphasizedText(context, maxTotalOverview.researcher.name),
                    ),
                    SelectableText(
                      '${LabUtils.formatNumber(maxTotalOverview.totalCollaborations)} ${maxTotalOverview.totalCollaborations == 1 ? 'collaborator' : 'collaborators'}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SelectableText(
                        'Students:',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    SelectableText(
                      '${LabUtils.formatNumber(maxTotalOverview.studentCollaborations)} ${maxTotalOverview.studentCollaborations == 1 ? 'collaborator' : 'collaborators'}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SelectableText(
                        'Faculty:',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    SelectableText(
                      '${LabUtils.formatNumber(maxTotalOverview.professorCollaborations)} ${maxProfessorOverview.professorCollaborations == 1 ? 'collaborator' : 'collaborators'}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  'Most Student Collaborations',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: LabUtils.emphasizedText(context, maxStudentOverview.researcher.name),
                    ),
                    SelectableText(
                      '${LabUtils.formatNumber(maxStudentOverview.studentCollaborations)} ${maxStudentOverview.studentCollaborations == 1 ? 'collaborator' : 'collaborators'}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SelectableText(
                        'Faculty:',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    SelectableText(
                      '${LabUtils.formatNumber(maxStudentOverview.professorCollaborations)} ${maxStudentOverview.professorCollaborations == 1 ? 'collaborator' : 'collaborators'}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  'Most Faculty Collaborations',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: LabUtils.emphasizedText(context, maxProfessorOverview.researcher.name),
                    ),
                    SelectableText(
                      '${LabUtils.formatNumber(maxProfessorOverview.professorCollaborations)} ${maxProfessorOverview.professorCollaborations == 1 ? 'collaborator' : 'collaborators'}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SelectableText(
                        'Students:',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    SelectableText(
                      '${LabUtils.formatNumber(maxProfessorOverview.studentCollaborations)} ${maxProfessorOverview.studentCollaborations == 1 ? 'collaborator' : 'collaborators'}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProlificResearchersCard(BuildContext context, bool Function(Researcher) filter, String title) {
    final researcherToPublicationCountMap = <Researcher, int>{};

    for (final researcher in researcherToPublicationsMap.keys.where(filter)) {
      researcherToPublicationCountMap[researcher] = LabUtils.removeDuplicatePublications(researcherToPublicationsMap[researcher]!.where(LabUtils.isFormalPublication)).length;
    }

    final sortedResearchers = researcherToPublicationCountMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return LabUtils.buildLabelValueCard(
      context: context,
      icon: Icons.auto_awesome,
      title: title,
      items: sortedResearchers.map((entry) =>
        MapEntry(entry.key.name, '${LabUtils.formatNumber(entry.value)} ${entry.value == 1 ? 'paper' : 'papers'}')
      ).toList(),
    );
  }

  Widget _buildFacultyWithMostGraduatesCard(BuildContext context, bool Function(Researcher) filter, String title) {
    // Count graduates for each professor
    final graduatesByProfessor = <ProfessorResearcher, List<StudentResearcher>>{};

    for (final professor in allResearchers.professors.where(filter)) {
      final graduates = allResearchers.students.where((s) =>
        s.hasDoctorate &&
        s.advisors != null &&
        s.advisors!.any((a) => a.name == professor.name)
      ).toList();

      if (graduates.isNotEmpty) {
        graduatesByProfessor[professor] = graduates;
      }
    }

    // Sort by number of graduates
    final sortedProfessors = graduatesByProfessor.entries.toList()
      ..sort((a, b) => b.value.length.compareTo(a.value.length));

    return LabUtils.buildLabelValueCard(
      context: context,
      icon: Icons.school,
      title: title,
      items: sortedProfessors.map((entry) =>
        MapEntry(entry.key.name, '${LabUtils.formatNumber(entry.value.length)} ${entry.value.length == 1 ? 'graduate' : 'graduates'}')
      ).toList(),
    );
  }

  Widget _buildPublicationTypesPieChartCard(BuildContext context, Iterable<Publication> publications) {
    // Get publications by type
    final publicationsByType = LabUtils.getPublicationsByType(publications);

    return LabUtils.buildPublicationTypesBarChartCard(
      context: context,
      icon: Icons.bar_chart,
      title: 'Publication Types Distribution',
      publicationsByType: publicationsByType,
    );
  }

  Widget _buildLabMembersDonutChartCard(BuildContext context) {
    // Count different types of lab members
    final currentStudentCount = allResearchers.students.where(LabUtils.isCurrentStudent).length;
    final graduatedStudentCount = allResearchers.students.where(LabUtils.isNonPostDocGraduated).length;
    final postDocCount = allResearchers.students.where(LabUtils.isPostDoc).length;
    final currentFacultyCount = allResearchers.professors.where(LabUtils.isCurrentFaculty).length;
    final emeritusFacultyCount = allResearchers.professors.where(LabUtils.isEmeritusFaculty).length;

    // Create data for the donut chart
    final data = [
      MapEntry('Current Students', currentStudentCount),
      MapEntry('Graduated Students', graduatedStudentCount),
      MapEntry('Postdocs', postDocCount),
      MapEntry('Current Faculty', currentFacultyCount),
      MapEntry('Emeritus Faculty', emeritusFacultyCount),
    ];

    // Colors for the chart sections
    // final colors = [
    //   Theme.of(context).colorScheme.primary,
    //   Theme.of(context).colorScheme.secondary,
    //   Theme.of(context).colorScheme.tertiary,
    //   Theme.of(context).colorScheme.error,
    //   Theme.of(context).colorScheme.surfaceTint,
    // ];

    return LabUtils.buildDonutChartCard(
      context: context,
      icon: Icons.pie_chart,
      title: 'Lab Member Distribution',
      subtitle: 'Breakdown of lab members by category',
      data: data,
      // colors: colors,
    );
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
}
