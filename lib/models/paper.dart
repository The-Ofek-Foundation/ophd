import 'author.dart';

class Paper {
  final String title;
  final List<Author> authors;
  final String link;
  final String description;
  final String? imagePath;
  final DateTime date;
  final List<String>? awards;
  final String conference;
  final String conferenceShort;
  final String conferenceLink;

  Paper({
    required this.title,
    required this.authors,
    required this.link,
    required this.description,
    this.imagePath,
    required this.date,
    this.awards,
    required this.conference,
    required this.conferenceShort,
    required this.conferenceLink,
  });
}
