import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:ophd/models/publication.dart';
import 'package:ophd/models/researcher.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Map<Researcher, Set<Publication>> getResearcherToPublicationsMap(List<Publication> publications) {
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

Map<Researcher, int> getWeightedCollaborators(Researcher researcher, Iterable<Publication>? publications) {
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
Map<Researcher, Map<Researcher, int>> getCompleteWeightedCollaboratorsMap(Map<Researcher, Set<Publication>> researcherToPublications) {
  final Map<Researcher, Map<Researcher, int>> completeMap = {};

  // For each researcher, calculate their weighted collaborators
  for (final researcher in researcherToPublications.keys) {
    completeMap[researcher] = getWeightedCollaborators(researcher, researcherToPublications[researcher]);
  }

  return completeMap;
}

/// Normalizes a title by converting to lowercase and removing non-alphanumeric characters
String normalizeTitle(String title) {
  return title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
}

/// Removes duplicate publications based on normalized titles
List<Publication> removeDuplicatePublications(Iterable<Publication> publications) {
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

List<Publication> getSortedPublications(Iterable<Publication>? publications, bool removeDuplicates) {
  if (publications == null) {
    return [];
  }

  if (removeDuplicates) {
    publications = removeDuplicatePublications(publications);
  }

  return publications.sorted();
}

class ResearcherYear {
  final Researcher researcher;
  final int year;

  ResearcherYear(this.researcher, this.year);
}

/// Returns a list of recent lab collaborators with their most recent collaboration year
List<ResearcherYear> getRecentCollaborators(Researcher researcher, Iterable<Publication> publications) {
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

Map<PublicationType, int> getPublicationsByType(Iterable<Publication> publications) {
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
String formatPublicationType(BuildContext context, PublicationType type) {
  // Convert enum to string for use with localization
  final typeString = type.toString().split('.').last;
  return AppLocalizations.of(context)!.publicationType(typeString);
}

bool isCurrentStudent(Researcher researcher) {
  return researcher is StudentResearcher && !researcher.hasDoctorate;
}

bool isGraduatedStudent(Researcher researcher) {
  return researcher is StudentResearcher && researcher.hasDoctorate;
}

bool isFaculty(Researcher researcher) {
  return researcher is ProfessorResearcher;
}

bool isCurrentStudentPaper(Publication publication) {
  return publication.researchers != null && publication.researchers!.any(isCurrentStudent);
}

bool isGraduatedStudentPaper(Publication publication) {
  return publication.researchers != null && publication.researchers!.any(isGraduatedStudent);
}

bool isFacultyPaper(Publication publication) {
  return publication.researchers != null && publication.researchers!.any(isFaculty);
}

bool isCollaboration(Publication publication) {
  return publication.researchers != null && publication.researchers!.length >= 2;
}

class ResearcherCollaborationOverview {
  final Researcher researcher;
  final int totalCollaborations;
  final int studentCollaborations;
  final int professorCollaborations;

  ResearcherCollaborationOverview(this.researcher, this.totalCollaborations, this.studentCollaborations, this.professorCollaborations);
}

ResearcherCollaborationOverview getCollaborationOverview(Researcher researcher, Set<Researcher> collaborators) {
  final overview = ResearcherCollaborationOverview(
    researcher,
    collaborators.length,
    collaborators.whereType<StudentResearcher>().length,
    collaborators.whereType<ProfessorResearcher>().length,
  );

  return overview;
}

List<ResearcherCollaborationOverview> getCollaborationOverviewList(Iterable<Researcher> researchers, Map<Researcher, Map<Researcher, int>> completeCollaboratorsMap) {
  final List<ResearcherCollaborationOverview> overviewList = [];

  for (final researcher in researchers) {
    overviewList.add(getCollaborationOverview(researcher, completeCollaboratorsMap[researcher]!.keys.toSet()));
  }

  return overviewList;
}

bool isInformalPublication(Publication publication) {
  return (publication.publtype != null && publication.publtype == 'informal') || publication.type == PublicationType.phdthesis;
}

bool isFormalPublication(Publication publication) {
  return !isInformalPublication(publication);
}
