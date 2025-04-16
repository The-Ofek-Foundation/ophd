// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get ofekGila => 'Ofek Gila';

  @override
  String get title => 'Ofek\'s Portfolio';

  @override
  String get mySubtitle => 'PhD Student, Computer Science @ UCI';

  @override
  String label(String key) {
    String _temp0 = intl.Intl.selectLogic(
      key,
      {
        'GoogleScholar': 'Google Scholar',
        'other': '$key',
      },
    );
    return '$_temp0';
  }

  @override
  String name(String key) {
    String _temp0 = intl.Intl.selectLogic(
      key,
      {
        'ofek': 'Ofek Gila',
        'mikeg': 'Michael Goodrich',
        'bob': 'Robert Tarjan',
        'evrim': 'Evrim Ozel',
        'mikes': 'Michael Shindler',
        'miked': 'Michael Dillencourt',
        'nero': 'Nero Li',
        'shahar': 'Shahar Broner',
        'yubin': 'Yubin Kim',
        'katrina': 'Katrina Mizuo',
        'elijah': 'Elijah Sauder',
        'claire': 'Claire To',
        'albert': 'Albert Wang',
        'abraham': 'Abraham Illickan',
        'vinesh': 'Vinesh Sridhar',
        'paul': 'Paul Erdős',
        'hedet': 'Stephan Hedetniemi',
        'other': '$key',
      },
    );
    return '$_temp0';
  }

  @override
  String page(String key) {
    String _temp0 = intl.Intl.selectLogic(
      key,
      {
        'other': '$key',
      },
    );
    return '$_temp0';
  }

  @override
  String get researchPrimary => 'Primary Research';

  @override
  String get researchPrimarySubtitle => 'Algorithms in the Real World';

  @override
  String get researchCollaborators => 'Research Collaborators';

  @override
  String researchCollaboratorsSubtitle(String name) {
    return 'Special thanks to my amazing advisor, $name';
  }

  @override
  String get researchDescription => 'My work combines computer science theory with experimental validation, focusing on randomized data structures including graph models and binary search trees.';

  @override
  String get erdosNumber => 'Erdős Number';

  @override
  String get erdosNumberSubtitle => 'Learn more about Erdős numbers';

  @override
  String get labGraphTitle => 'Lab Collaboration Graph';

  @override
  String get labGraphSubtitle => 'Interactive visualization of research collaborations';

  @override
  String get labGraphDescriptionStart => 'Here is a graph of all the members of my lab, the ';

  @override
  String get labGraphDescriptionLink => 'theory lab';

  @override
  String get labGraphDescriptionEnd => ', at UCI. Edges correspond to co-authorship on research papers. Feel free to select faculty members to see their collaborations, and on any person to see more details.';

  @override
  String get unconnectedLabMembersTitle => 'Unconnected Lab Members';

  @override
  String unconnectedLabMembersSubtitle(int count) {
    return 'The $count lab members who have not (yet) collaborated with any other lab members or shown faculty are listed below.';
  }

  @override
  String link(String key, String name) {
    String _temp0 = intl.Intl.selectLogic(
      key,
      {
        'viewPaper': 'View paper',
        'viewPage': 'View $name\'s page',
        'other': '$key',
      },
    );
    return '$_temp0';
  }

  @override
  String get labGraphInfo => 'If you are a lab member and have a missing connection, please try syncing the database from the reload button. If that doesn\'t work, it is possible that either your publication is too recent and does not (yet) appear in DBLP, I have an incorrect DBLP ID associated with you, or your publication is in an adjacent field and does not appear in DBLP. In either case, you can contact me to manually update the data.';

  @override
  String get publicationsTheory => 'Theoretical Computer Science';

  @override
  String get publicationsTheorySubtitle => 'Randomized Algorithms and Data Structures';

  @override
  String get publicationsEducation => 'Computer Science Education';

  @override
  String get publicationsEducationSubtitle => 'Research in CS Education at UCI';

  @override
  String get publicationsEducationIntro => 'I\'ve had the opportunity to tag along on some CS ed research projects.';

  @override
  String get educationJourney => 'Educational Journey';

  @override
  String get educationJourneySubtitle => 'From High School to Graduate Studies';

  @override
  String get educationBackground => 'Academic Background';

  @override
  String get educationBackgroundSubtitle => 'Computer Science and Physics at UCI';

  @override
  String get educationCurrentStudies => 'Current Studies';

  @override
  String get educationCurrentStudiesDetails => 'PhD in CS Theory (Algorithms in the Real World), UCI, ongoing';

  @override
  String get educationMasterNote => 'Masters attained on the way';

  @override
  String get educationUndergrad => 'Undergraduate Studies';

  @override
  String get educationStoryStart => 'I was raised in Cupertino, CA, and graduated from ';

  @override
  String get educationStoryMid => '. My passion for programming ignited during my freshman year with my first programming course. I continued to engage with AP Computer Science A as both a student and teaching assistant. In 2017, I started at ';

  @override
  String get educationStoryEnd => ', pursuing a double major in Computer Science and Physics, graduating in 2021. Currently, I am pursuing a PhD at UCI.';

  @override
  String get montaVistaHS => 'Monta Vista High School';

  @override
  String get uci => 'the University of California, Irvine';

  @override
  String get uciShort => 'UCI';

  @override
  String degree(String subject) {
    return 'BS in $subject, 2021';
  }

  @override
  String get physics => 'Physics';

  @override
  String get computerScience => 'Computer Science';

  @override
  String get uciHomepage => 'UCI Homepage';

  @override
  String get uciTheoryGroup => 'UCI Theory Group';

  @override
  String get summa => 'Summa Cum Laude';

  @override
  String get magna => 'Magna Cum Laude';

  @override
  String get industryExperience => 'Industry Experience';

  @override
  String get industryExperienceSubtitle => 'From Startups to Large Corporations';

  @override
  String conference(String key) {
    String _temp0 = intl.Intl.selectLogic(
      key,
      {
        'COCOA': 'Conference on Combinatorial Optimization and Applications',
        'WADS': 'Algorithms and Data Structures Symposium',
        'CCSC': 'Journal of Computing Sciences in Colleges',
        'SIGCSE': 'Special Interest Group on Computer Science Education',
        'CIAC': 'International Conference on Algorithms and Complexity',
        'other': '$key',
      },
    );
    return '$_temp0';
  }

  @override
  String award(String key) {
    String _temp0 = intl.Intl.selectLogic(
      key,
      {
        'Best_Paper': 'Best Paper',
        'other': '$key',
      },
    );
    return '$_temp0';
  }

  @override
  String advisor(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Advisors',
      one: 'Advisor',
    );
    return '$_temp0';
  }

  @override
  String get graduationYear => 'Graduation Year';

  @override
  String get thesisTitle => 'Thesis Title';

  @override
  String get graduateStudents => 'Graduate Students';

  @override
  String current(int count) {
    return 'Current: $count';
  }

  @override
  String studentCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'students',
      one: 'student',
    );
    return '$_temp0';
  }

  @override
  String get recentGraduates => 'Recent Graduates';

  @override
  String get publicationsByType => 'Publications by Type';

  @override
  String get researchCollaborations => 'Research Collaborations';

  @override
  String get facultyCoauthors => 'Faculty Co-authors';

  @override
  String get studentCoauthors => 'Student Co-authors';

  @override
  String get topLabCollaborators => 'Top Lab Collaborators';

  @override
  String get recentLabCollaborators => 'Recent Lab Collaborators';

  @override
  String get recentPublications => 'Recent Publications';

  @override
  String paperCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'papers',
      one: 'paper',
    );
    return '$_temp0';
  }

  @override
  String get visitWebsite => 'Visit website';

  @override
  String get viewOnDblp => 'View on DBLP';

  @override
  String get done => 'Done';

  @override
  String publicationType(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'article': 'Journal Articles',
        'inproceedings': 'Conference Papers',
        'proceedings': 'Proceedings',
        'book': 'Books',
        'incollection': 'Book Chapters',
        'phdthesis': 'PhD Theses',
        'unknown': 'Other Publications',
        'other': '$type',
      },
    );
    return '$_temp0';
  }
}
