import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ophd/models/publication.dart';
import 'package:ophd/models/researcher.dart';

import 'package:collection/collection.dart';

import 'package:ophd/generated/l10n/app_localizations.dart';
import 'package:ophd/theme.dart';

class ResearcherYear {
  final Researcher researcher;
  final int year;

  ResearcherYear(this.researcher, this.year);
}

class ResearcherCollaborationOverview {
  final Researcher researcher;
  final int totalCollaborations;
  final int studentCollaborations;
  final int professorCollaborations;

  ResearcherCollaborationOverview(this.researcher, this.totalCollaborations, this.studentCollaborations, this.professorCollaborations);
}

class LabUtils {
  //----------------------------------------------------------------------------
  // DATA PROCESSING - PUBLICATIONS AND RESEARCHERS
  //----------------------------------------------------------------------------

  static Map<Researcher, Set<Publication>> getResearcherToPublicationsMap(List<Publication> publications) {
    final Map<Researcher, Set<Publication>> researcherToPublications = {};

    for (final Publication publication in publications) {
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

  static Map<Researcher, int> getWeightedCollaborators(Researcher researcher, Iterable<Publication>? publications) {
    if (publications == null) {
      return {};
    }

    publications = removeDuplicatePublications(publications);

    final Map<Researcher, int> weightedCollaborators = {};

    for (final Publication publication in publications) {
      for (final Researcher collaborator in publication.researchers!) {
        if (collaborator != researcher) {
          weightedCollaborators.update(collaborator, (value) => value + 1, ifAbsent: () => 1);
        }
      }
    }

    // Sort by count (descending)
    final sortedEntries = weightedCollaborators.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Map.fromEntries(sortedEntries);
  }

  /// Generates a complete weighted collaborators map that includes all researchers
  static Map<Researcher, Map<Researcher, int>> getCompleteWeightedCollaboratorsMap(Map<Researcher, Set<Publication>> researcherToPublications) {
    final Map<Researcher, Map<Researcher, int>> completeMap = {};

    // For each researcher, calculate their weighted collaborators
    for (final researcher in researcherToPublications.keys) {
      completeMap[researcher] = getWeightedCollaborators(researcher, researcherToPublications[researcher]);
    }

    return completeMap;
  }

  //----------------------------------------------------------------------------
  // TITLE NORMALIZATION AND PUBLICATION FILTERING
  //----------------------------------------------------------------------------

  /// Normalizes a title by converting to lowercase and removing non-alphanumeric characters
  static String normalizeTitle(String title) {
    return title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
  }

  /// Removes duplicate publications based on normalized titles
  static List<Publication> removeDuplicatePublications(Iterable<Publication> publications) {
    // Map to track seen normalized titles
    final seenTitles = <String, Publication>{};

    for (final publication in publications) {
      // Normalize the title: lowercase and remove non-alphanumeric characters
      final normalizedTitle = normalizeTitle(publication.title);

      // If we haven't seen this title before, or if this publication is newer (by mdate)
      // than the one we've seen, keep this one
      if (!seenTitles.containsKey(normalizedTitle) || publication.mdate.seconds > seenTitles[normalizedTitle]!.mdate.seconds) {
        seenTitles[normalizedTitle] = publication;
      }
    }

    // Return the unique publications
    return seenTitles.values.toList();
  }

  static List<Publication> getSortedPublications(Iterable<Publication>? publications, bool removeDuplicates) {
    if (publications == null) {
      return [];
    }

    if (removeDuplicates) {
      publications = removeDuplicatePublications(publications);
    }

    return publications.sorted();
  }

  //----------------------------------------------------------------------------
  // RESEARCHER CLASSIFICATION FUNCTIONS
  //----------------------------------------------------------------------------

  static bool isStudent(Researcher researcher) {
    return researcher is StudentResearcher;
  }

  static bool isCurrentStudent(Researcher researcher) {
    return isStudent(researcher) && !researcher.hasDoctorate;
  }

  static bool isGraduatedStudent(Researcher researcher) {
    return isStudent(researcher) && researcher.hasDoctorate;
  }

  static bool isPostDoc(Researcher researcher) {
    return isStudent(researcher) && (researcher as StudentResearcher).isPostDoc;
  }

  static bool isNonPostDocGraduated(Researcher researcher) {
    return isGraduatedStudent(researcher) && !(researcher as StudentResearcher).isPostDoc;
  }

  static bool isFaculty(Researcher researcher) {
    return researcher is ProfessorResearcher;
  }

  static bool isCurrentFaculty(Researcher researcher) {
    return isFaculty(researcher) && !(researcher as ProfessorResearcher).isEmeritus;
  }

  static bool isEmeritusFaculty(Researcher researcher) {
    return isFaculty(researcher) && (researcher as ProfessorResearcher).isEmeritus;
  }

  //----------------------------------------------------------------------------
  // PUBLICATION CLASSIFICATION FUNCTIONS
  //----------------------------------------------------------------------------

  static Map<PublicationType, int> getPublicationsByType(Iterable<Publication> publications) {
    final typeCount = <PublicationType, int>{};

    for (final pub in publications) {
      typeCount.update(pub.type, (count) => count + 1, ifAbsent: () => 1);
    }

    // Sort by count (descending)
    final sortedEntries = typeCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Map.fromEntries(sortedEntries);
  }

  static bool isCurrentStudentPaper(Publication publication) {
    return publication.researchers != null && publication.researchers!.any(isCurrentStudent);
  }

  static bool isGraduatedStudentPaper(Publication publication) {
    return publication.researchers != null && publication.researchers!.any(isGraduatedStudent);
  }

  static bool isPostDocPaper(Publication publication) {
    return publication.researchers != null && publication.researchers!.any(isPostDoc);
  }

  static bool isNonPostDocGraduatedPaper(Publication publication) {
    return publication.researchers != null && publication.researchers!.any(isNonPostDocGraduated);
  }

  static bool isFacultyPaper(Publication publication) {
    return publication.researchers != null && publication.researchers!.any(isFaculty);
  }

  static bool isCurrentFacultyPaper(Publication publication) {
    return publication.researchers != null && publication.researchers!.any(isCurrentFaculty);
  }

  static bool isEmeritusFacultyPaper(Publication publication) {
    return publication.researchers != null && publication.researchers!.any(isEmeritusFaculty);
  }

  static bool isInformalPublication(Publication publication) {
    return (publication.publtype != null && publication.publtype == 'informal') || publication.type == PublicationType.phdthesis;
  }

  static bool isFormalPublication(Publication publication) {
    return !isInformalPublication(publication);
  }

  //----------------------------------------------------------------------------
  // COLLABORATION FUNCTIONS
  //----------------------------------------------------------------------------

  /// Returns a list of recent lab collaborators with their most recent collaboration year
  static List<ResearcherYear> getRecentCollaborators(Researcher researcher, Iterable<Publication> publications) {
    final sortedPublications = publications.sorted();

    // Map to track the most recent collaborators we've seen
    final recentCollaborators = <Researcher, int>{};

    // Loop through publications in order of recency
    for (final publication in sortedPublications) {
      // Skip if this publication doesn't have researchers listed
      if (publication.researchers == null || publication.researchers!.isEmpty) continue;

      // Find collaborators in this publication
      for (final labMember in publication.researchers!) {
        // Skip if this is the researcher we're looking at
        if (labMember == researcher) continue;

        if (!recentCollaborators.containsKey(labMember)) {
          recentCollaborators[labMember] = publication.year;
        }
      }
    }

    return recentCollaborators.entries.map((entry) => ResearcherYear(entry.key, entry.value)).toList();
  }

  static bool isCollaboration(Publication publication) {
    return publication.researchers != null && publication.researchers!.length >= 2;
  }

  static ResearcherCollaborationOverview getCollaborationOverview(Researcher researcher, Set<Researcher> collaborators) {
    final overview = ResearcherCollaborationOverview(
      researcher,
      collaborators.length,
      collaborators.whereType<StudentResearcher>().length,
      collaborators.whereType<ProfessorResearcher>().length,
    );

    return overview;
  }

  static List<ResearcherCollaborationOverview> getCollaborationOverviewList(Iterable<Researcher> researchers, Map<Researcher, Map<Researcher, int>> completeCollaboratorsMap) {
    final List<ResearcherCollaborationOverview> overviewList = [];

    for (final researcher in researchers) {
      overviewList.add(getCollaborationOverview(researcher, completeCollaboratorsMap[researcher]!.keys.toSet()));
    }

    return overviewList;
  }

  //----------------------------------------------------------------------------
  // FORMATTING AND UTILITY FUNCTIONS
  //----------------------------------------------------------------------------

  /// Formats a publication type for display
  static String formatPublicationType(BuildContext context, PublicationType type) {
    // Convert enum to string for use with localization
    final typeString = type.toString().split('.').last;
    return AppLocalizations.of(context)!.publicationType(typeString);
  }

  static final numberFormatter = NumberFormat.decimalPatternDigits(
      locale: 'en_us',
      decimalDigits: 0,
  );

  /// Formats a number with commas for thousands, millions, etc.
  static String formatNumber(int number) {
    return numberFormatter.format(number);
  }

  //----------------------------------------------------------------------------
  // UI COMPONENTS AND STYLING
  //----------------------------------------------------------------------------

  /// Returns a common container decoration used throughout the app
  static BoxDecoration getCommonContainerDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(77),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: Theme.of(context).colorScheme.outlineVariant,
        width: 1,
      ),
    );
  }

  /// Creates a label-value row commonly used in info cards
  static Widget buildLabelValueRow(
    BuildContext context, {
    required String label,
    required String value,
    bool emphasize = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: emphasizedText(context, label),
          ),
          SelectableText(
            value,
            style: TextStyle(
              fontWeight: emphasize ? FontWeight.bold : null,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }

  /// Creates a stat row with a label and value, with the value emphasized
  /// Used for displaying statistics in various parts of the app
  static Widget buildStatRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: SelectableText(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        emphasizedText(
          context,
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
    );
  }

  //----------------------------------------------------------------------------
  // CHART UTILITIES AND WIDGETS
  //----------------------------------------------------------------------------

  /// Calculates the optimal interval for grid lines based on the maximum value
  /// This prevents the chart from having too many grid lines when the values are large
  static double _calculateOptimalInterval(double maxValue) {
    if (maxValue <= 5) return 1; // For small values, show every integer
    if (maxValue <= 10) return 2; // For medium values, show every other integer
    if (maxValue <= 20) return 5; // For larger values, show every 5 integers
    if (maxValue <= 50) return 10; // For even larger values, show every 10 integers
    if (maxValue <= 100) return 20; // For very large values, show every 20 integers
    return (maxValue / 10).ceil().toDouble(); // For extremely large values, divide into ~10 sections
  }

  /// Creates a line chart card for displaying data over years
  /// Used for Publications Per Year, Collaborations Per Year, Graduations Per Year, etc.
  static Widget buildYearlyLineChartCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Map<int, int> dataByYear,
    Color? lineColor,
    Color? tooltipTextColor,
    String? yAxisLabel,
    double height = 200,
  }) {
    // Sort years
    final sortedYears = dataByYear.keys.toList()..sort();

    // Create line chart data
    final spots = <FlSpot>[];
    for (int i = 0; i < sortedYears.length; i++) {
      final year = sortedYears[i];
      final count = dataByYear[year]!;
      spots.add(FlSpot(year.toDouble(), count.toDouble()));
    }

    final chartColor = lineColor ?? Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: getCommonContainerDecoration(context),
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
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: height,
                  child: LineChart(
                    LineChartData(
                      minX: sortedYears.isEmpty ? 0 : sortedYears.first.toDouble() - 0.5,
                      maxX: sortedYears.isEmpty ? 0 : sortedYears.last.toDouble() + 0.5,
                      minY: 0,
                      maxY: (dataByYear.values.isEmpty ? 0 : dataByYear.values.reduce(math.max).toDouble()) * 1.2,
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          color: chartColor,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(show: true),
                          belowBarData: BarAreaData(
                            show: true,
                            color: chartColor.withAlpha(51),
                          ),
                        ),
                      ],
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          tooltipBgColor: chartColor.withAlpha(204),
                          getTooltipItems: (List<LineBarSpot> touchedSpots) {
                            return touchedSpots.map((LineBarSpot touchedSpot) {
                              final year = touchedSpot.x.toInt();
                              final count = touchedSpot.y.toInt();
                              return LineTooltipItem(
                                '$year: ${formatNumber(count)}',
                                TextStyle(color: tooltipTextColor ?? Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold),
                              );
                            }).toList();
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          axisNameWidget: yAxisLabel != null ? Text(
                            yAxisLabel,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface.withAlpha((0.7 * 255).round()),
                              fontSize: 10,
                            ),
                          ) : null,
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            interval: _calculateOptimalInterval(dataByYear.values.isEmpty ? 0 : dataByYear.values.reduce(math.max).toDouble()),
                            getTitlesWidget: (value, meta) {
                              if (value == 0) return const SizedBox();
                              if (value % 1 != 0) return const SizedBox();

                              // Only show labels that are multiples of the interval
                              final interval = _calculateOptimalInterval(dataByYear.values.isEmpty ? 0 : dataByYear.values.reduce(math.max).toDouble());
                              if (value % interval != 0) return const SizedBox();

                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                child: SelectableText(
                                  value.toInt().toString(),
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSurface.withAlpha((0.7 * 255).round()),
                                    fontSize: 10,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          axisNameWidget: SelectableText(
                            'Year',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface.withAlpha((0.7 * 255).round()),
                              fontSize: 10,
                            ),
                          ),
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: sortedYears.length > 20 ? 5 : (sortedYears.length > 10 ? 2 : 1),
                            getTitlesWidget: (value, meta) {
                              if (value % 1 != 0) return const SizedBox();

                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                child: SelectableText(
                                  value.toInt().toString(),
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSurface.withAlpha((0.7 * 255).round()),
                                    fontSize: 10,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      gridData: FlGridData(
                        drawHorizontalLine: true,
                        horizontalInterval: _calculateOptimalInterval(dataByYear.values.isEmpty ? 0 : dataByYear.values.reduce(math.max).toDouble()),
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: Theme.of(context).colorScheme.onSurface.withAlpha((0.1 * 255).round()),
                          strokeWidth: 1,
                        ),
                        drawVerticalLine: false,
                      ),
                      borderData: FlBorderData(show: false),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //----------------------------------------------------------------------------
  // CARD WIDGETS
  //----------------------------------------------------------------------------

  /// Creates a card for displaying a list of publications
  /// Used for sections like Recent Publications, Recent Student Papers, etc.
  static Widget buildPublicationsCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required List<Publication> publications,
    int maxItems = 3,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: getCommonContainerDecoration(context),
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
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 8),
                ...publications.take(maxItems).map((pub) =>
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
                        emphasizedText(
                          context,
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
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Creates a simple card with an icon, title, and a list of label-value pairs
  /// Used for displaying simple data like Recent Graduates, Prolific Students, etc.
  static Widget buildLabelValueCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required List<MapEntry<String, String>> items,
    int maxItems = 5,
    bool emphasizeNames = true,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: getCommonContainerDecoration(context),
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
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 4),
                ...items.take(maxItems).map((entry) =>
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: buildLabelValueRow(
                      context,
                      label: entry.key,
                      value: entry.value,
                      emphasize: emphasizeNames && entry.key == 'Ofek Gila',
                    ),
                  )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //----------------------------------------------------------------------------
  // TEXT EMPHASIS
  //----------------------------------------------------------------------------

  /// Creates text with emphasis on specific name mentions
  /// Emphasizes 'Ofek Gila' in the text with a different color and bold style
  static Widget emphasizedText(BuildContext context, String text, {TextStyle? style, int? maxLines}) {
    if (text.contains('Ofek Gila')) {
      // Split the text around Ofek's name
      final parts = text.split('Ofek Gila');

      return SelectableText.rich(
        TextSpan(
          style: style,
          children: [
            for (int i = 0; i < parts.length; i++) ...[
              TextSpan(text: parts[i]),
              if (i < parts.length - 1)
                TextSpan(
                  text: 'Ofek Gila',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontWeight: FontWeight.bold,
                    fontSize: style?.fontSize,
                    fontStyle: style?.fontStyle,
                  ),
                ),
            ],
          ],
        ),
        maxLines: maxLines,
        textAlign: TextAlign.left,
      );
    } else {
      return SelectableText(
        text,
        style: style,
        maxLines: maxLines,
      );
    }
  }

  //----------------------------------------------------------------------------
  // SPECIALIZED CHARTS
  //----------------------------------------------------------------------------

  /// Creates a donut chart for displaying categorical data with labels on the right side
  /// Used for displaying lab member distribution, publication types, etc.
  static Widget buildDonutChartCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required List<MapEntry<String, int>> data,
    double height = 276,
    String subtitle = '',
    Map<String, IconData>? categoryIcons,
  }) {
    return _DonutChartCard(
      context: context,
      icon: icon,
      title: title,
      data: data,
      height: height,
      subtitle: subtitle,
      categoryIcons: categoryIcons,
    );
  }

  /// Creates a stacked horizontal bar chart for displaying publication types distribution
  /// with a logarithmic y-axis scale
  static Widget buildPublicationTypesBarChartCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Map<PublicationType, int> publicationsByType,
  }) {
    // Function to transform values to logarithmic scale
    // We use log10(n + 1) to handle zero values and make small values more visible
    double logTransform(double value) {
      // Add 1 to avoid log(0) which is undefined
      return value <= 0 ? 0 : math.log(value) / math.ln10;
    }
    // Use Okabe-Ito colors for publication types
    final materialTheme = MaterialTheme(Theme.of(context).textTheme);

    // Calculate total publications for percentage
    final totalPublications = publicationsByType.values.fold(0, (sum, count) => sum + count);

    // Sort publication types by count (descending)
    final sortedTypes = publicationsByType.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Create bar chart data
    final barGroups = <BarChartGroupData>[];
    final legendItems = <MapEntry<String, String>>[];

    // We'll use a single group for the stacked bar
    final List<BarChartRodData> rods = [];

    for (int i = 0; i < sortedTypes.length; i++) {
      final entry = sortedTypes[i];
      final type = entry.key;
      final count = entry.value;
      final percentage = (count / totalPublications) * 100;
      final formattedPercentage = percentage.toStringAsFixed(1);

      // Get localized publication type name
      final typeLabel = formatPublicationType(context, type);

      // Add rod for this publication type
      rods.add(
        BarChartRodData(
          fromY: 0,
          toY: count.toDouble(),
          color: materialTheme.getOkabeItoChartColorByIndex(context, i),
          width: 20,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
        ),
      );

      // Add to legend
      legendItems.add(MapEntry(
        typeLabel,
        '${formatNumber(count)} ($formattedPercentage%)'
      ));
    }

    // Create a single group for the horizontal stacked bar
    barGroups.add(
      BarChartGroupData(
        x: 0,
        barRods: rods,
        showingTooltipIndicators: [0],
      ),
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: getCommonContainerDecoration(context),
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
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 300,
                  child: Column(
                    children: [
                      // Bar chart
                      Expanded(
                        flex: 2,
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceEvenly,
                            barTouchData: BarTouchData(
                              enabled: true,
                              touchTooltipData: BarTouchTooltipData(
                                tooltipBgColor: Theme.of(context).colorScheme.surface.withAlpha(204), // 0.8 opacity
                                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                  // The rod.toY value is the logarithmically transformed value
                                  // We need to map back to the original index to get the correct data
                                  final entry = sortedTypes[group.x.toInt()];
                                  final type = entry.key;
                                  final count = entry.value;
                                  final percentage = (count / totalPublications) * 100;
                                  final typeLabel = formatPublicationType(context, type);
                                  return BarTooltipItem(
                                    '$typeLabel\n${formatNumber(count)} (${percentage.toStringAsFixed(1)}%)',
                                    TextStyle(color: Theme.of(context).colorScheme.onSurface),
                                  );
                                },
                              ),
                            ),
                            titlesData: FlTitlesData(
                              show: true,
                              // Configure titles for vertical bar chart
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    // Bottom titles are the publication types
                                    if (value >= 0 && value < sortedTypes.length) {
                                      final type = sortedTypes[value.toInt()].key;
                                      final typeLabel = formatPublicationType(context, type);
                                      return SideTitleWidget(
                                        axisSide: meta.axisSide,
                                        child: SelectableText(
                                          typeLabel,
                                          style: TextStyle(
                                            color: Theme.of(context).colorScheme.onSurface,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      );
                                    }
                                    return const SizedBox();
                                  },
                                  reservedSize: 60,
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    // For logarithmic scale, we want to show powers of 10
                                    // Convert the logarithmic value back to the original scale for display
                                    final originalValue = math.pow(10, value).toInt();

                                    // Only show specific values on the logarithmic scale
                                    if (![0, 1, 2, 3, 4].contains(value.round())) {
                                      return const SizedBox();
                                    }

                                    return SideTitleWidget(
                                      axisSide: meta.axisSide,
                                      child: SelectableText(
                                        formatNumber(originalValue),
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.onSurface.withAlpha((0.7 * 255).round()),
                                          fontSize: 10,
                                        ),
                                      ),
                                    );
                                  },
                                  reservedSize: 40,
                                ),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            gridData: FlGridData(
                              show: true,
                              drawHorizontalLine: true,
                              drawVerticalLine: false,
                              getDrawingHorizontalLine: (value) => FlLine(
                                color: Theme.of(context).colorScheme.onSurface.withAlpha((0.1 * 255).round()),
                                strokeWidth: 1,
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            barGroups: List.generate(sortedTypes.length, (index) {
                              final entry = sortedTypes[index];
                              final count = entry.value;

                              return BarChartGroupData(
                                x: index,
                                barRods: [
                                  BarChartRodData(
                                    // Apply logarithmic transformation to the bar height
                                    toY: logTransform(count.toDouble()),
                                    color: materialTheme.getPastelChartColorByIndex(context, index),
                                    width: 30,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ],
                              );
                            }),
                            // Set maxY based on the logarithmic transformation of the maximum value
                            maxY: logTransform(publicationsByType.values.reduce(math.max).toDouble()) * 1.1,
                            // Keep as vertical bar chart
                          ),
                        ),
                      ),

                      // Legend
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Wrap(
                          spacing: 16,
                          runSpacing: 8,
                          children: legendItems.asMap().entries.map((entry) {
                            final index = entry.key;
                            final item = entry.value;
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: materialTheme.getPastelChartColorByIndex(context, index),
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                SelectableText(
                                  item.key,
                                  style: const TextStyle(fontSize: 10),
                                ),
                                const SizedBox(width: 4),
                                SelectableText(
                                  item.value,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A stateful widget to handle hover interactions for the donut chart
class _DonutChartCard extends StatefulWidget {
  final BuildContext context;
  final IconData icon;
  final String title;
  final List<MapEntry<String, int>> data;
  final double height;
  final String subtitle;
  final Map<String, IconData>? categoryIcons;

  const _DonutChartCard({
    required this.context,
    required this.icon,
    required this.title,
    required this.data,
    required this.height,
    required this.subtitle,
    this.categoryIcons,
  });

  @override
  State<_DonutChartCard> createState() => _DonutChartCardState();
}

class _DonutChartCardState extends State<_DonutChartCard> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final materialTheme = MaterialTheme(Theme.of(context).textTheme);

    // Create pie chart sections
    final sections = <PieChartSectionData>[];
    final legendItems = <MapEntry<String, String>>[];

    // Calculate total for percentages
    final total = widget.data.fold(0, (sum, item) => sum + item.value);

    // Create sections and legend items
    for (int i = 0; i < widget.data.length; i++) {
      final item = widget.data[i];
      final percentage = (item.value / total) * 100;
      final isTouched = i == touchedIndex;
      final radius = isTouched ? 70.0 : 60.0;
      final fontSize = isTouched ? 14.0 : 12.0;

      sections.add(
        PieChartSectionData(
          value: item.value.toDouble(),
          title: '${LabUtils.formatNumber(item.value)}\n${percentage.toStringAsFixed(1)}%',
          color: materialTheme.getPastelChartColorByIndex(context, i),
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: MaterialTheme.onPastelChartColor,
          ),
          showTitle: true,
        ),
      );

      legendItems.add(MapEntry(
        item.key,
        '${LabUtils.formatNumber(item.value)} (${percentage.toStringAsFixed(1)}%)'
      ));
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: LabUtils.getCommonContainerDecoration(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            widget.icon,
            size: 24,
            color: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  widget.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                if (widget.subtitle.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  SelectableText(
                    widget.subtitle,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontFamily: 'RobotoMono',
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                SizedBox(
                  height: widget.height,
                  child: Row(
                    children: [
                      // Donut chart
                      Expanded(
                        flex: 3,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 2,
                            centerSpaceRadius: 60, // This creates the donut hole
                            pieTouchData: PieTouchData(
                              enabled: true,
                              touchCallback: (FlTouchEvent event, pieTouchResponse) {
                                setState(() {
                                  if (pieTouchResponse == null ||
                                      pieTouchResponse.touchedSection == null) {
                                    touchedIndex = -1;
                                    return;
                                  }
                                  touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                                });
                              },
                            ),
                            sections: sections.asMap().map((index, section) {
                              // Add tooltip data to each section
                              final item = widget.data[index];
                              final percentage = (item.value / total) * 100;

                              return MapEntry(
                                index,
                                PieChartSectionData(
                                  value: section.value,
                                  title: section.title,
                                  color: section.color,
                                  radius: section.radius,
                                  titleStyle: section.titleStyle,
                                  showTitle: section.showTitle,
                                  badgeWidget: index == touchedIndex ? Center(
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.black87,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            item.key,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${LabUtils.formatNumber(item.value)} (${percentage.toStringAsFixed(1)}%)',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ) : null,
                                  badgePositionPercentageOffset: 0.8,
                                ),
                              );
                            }).values.toList(),
                          ),
                        ),
                      ),

                      // Legend on the right side
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: legendItems.asMap().entries.map((entry) {
                              final index = entry.key;
                              final item = entry.value;
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  children: [
                                    widget.categoryIcons != null && widget.categoryIcons!.containsKey(item.key)
                                      ? Icon(
                                          widget.categoryIcons![item.key],
                                          size: 20,
                                          color: materialTheme.getPastelChartColorByIndex(context, index),
                                        )
                                      : Container(
                                          width: 16,
                                          height: 16,
                                          decoration: BoxDecoration(
                                            color: materialTheme.getPastelChartColorByIndex(context, index),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: SelectableText(
                                        item.key,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                    SelectableText(
                                      item.value,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).colorScheme.secondary,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}