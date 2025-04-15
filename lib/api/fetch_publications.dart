import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ophd/models/publication.dart';
import 'package:ophd/models/researcher.dart';

// Using the regular publications endpoint now that it includes researcher names
const fetchPublicationsUrl = "https://fetchallpublications-bql574jsfq-uc.a.run.app";

/// Fetches a list of publications from the API
/// If allResearchers is provided, it will link the publications to the researchers
Future<List<Publication>> fetchPublications({AllResearchers? allResearchers}) async {
  try {
    final response = await http.get(Uri.parse(fetchPublicationsUrl));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as List<dynamic>;
      final publications = jsonData
          .map((json) => Publication.fromJson(json as Map<String, dynamic>))
          .toList();

      // If allResearchers is provided, link the publications to the researchers
      if (allResearchers != null) {
        _linkPublicationsToResearchers(publications, allResearchers);
      }

      return publications;
    } else {
      throw Exception('Failed to load publications');
    }
  } catch (e) {
    return [];
  }
}

/// Links publications to researchers based on the researcherNames field
void _linkPublicationsToResearchers(List<Publication> publications, AllResearchers allResearchers) {
  // Create a map of researcher names to researcher objects
  final nameToResearcher = <String, Researcher>{};
  for (final student in allResearchers.students) {
    nameToResearcher[student.name] = student;
  }
  for (final professor in allResearchers.professors) {
    nameToResearcher[professor.name] = professor;
  }

  // Link publications to researchers
  for (final publication in publications) {
    if (publication.researcherNames != null && publication.researcherNames!.isNotEmpty) {
      publication.researchers = publication.researcherNames!
          .where((name) => nameToResearcher.containsKey(name))
          .map((name) => nameToResearcher[name]!)
          .toList();
    }
  }
}
