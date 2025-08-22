import 'package:ophd/models/conference.dart';

import 'author.dart';

enum ResearchCategory {
  theory,
  education,
}

class Paper {
  final String title;
  final List<Author> authors;
  final String link;
  final String description;
  final String? imagePath;
  final DateTime date;
  final List<String>? awards;
  final Conference conference;
  final ResearchCategory researchCategory;
  final String? slidesPath;

  Paper({
    required this.title,
    required this.authors,
    required this.link,
    required this.description,
    this.imagePath,
    required this.date,
    this.awards,
    required this.conference,
    required this.researchCategory,
    this.slidesPath,
  });
}
