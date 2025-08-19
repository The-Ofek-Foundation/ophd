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
        'david': 'David Eppstein',
        'ryuto': 'Ryuto Kitagawa',
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
  String get researchDescription =>
      'My work combines computer science theory with experimental validation, focusing on randomized data structures including graph models and binary search trees.';

  @override
  String get erdosNumber => 'Erdős Number';

  @override
  String get erdosNumberSubtitle => 'Learn more about Erdős numbers';

  @override
  String get labGraphTitle => 'Lab Collaboration Graph';

  @override
  String get labGraphSubtitle =>
      'Interactive visualization of research collaborations';

  @override
  String get labGraphDescriptionStart =>
      'Here is a graph of all the members of my lab, the ';

  @override
  String get labGraphDescriptionLink => 'theory lab';

  @override
  String get labGraphDescriptionEnd =>
      ', at UCI. Edges correspond to co-authorship on research papers. Feel free to select faculty members to see their collaborations, and on any person to see more details.';

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
  String get labGraphInfo =>
      'If you are a lab member and have a missing connection, please try syncing the database from the reload button. If that doesn\'t work, it is possible that either your publication is too recent and does not (yet) appear in DBLP, I have an incorrect DBLP ID associated with you, or your publication is in an adjacent field and does not appear in DBLP. In either case, you can contact me to manually update the data.';

  @override
  String get labInfoTitle => 'UCI Theory Lab';

  @override
  String get labInfoSubtitle =>
      'Exploring theoretical computer science since 1975';

  @override
  String get labInfoDescription =>
      'This page showcases the Theory Lab at the University of California, Irvine. It includes a visualization of lab collaborations, highlights of research achievements, and statistics about publications, students, and faculty members over the years.';

  @override
  String get loadingLabData => 'Loading Lab Data';

  @override
  String get syncDatabase => 'Sync Database';

  @override
  String get fetchRealData => 'Fetch Real Data';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get error => 'Error';

  @override
  String get disclaimerTitle => 'Disclaimer';

  @override
  String get disclaimerSubtitle => 'Data may not be 100% accurate';

  @override
  String get disclaimerTextStart => 'Knowledge of lab members is taken from ';

  @override
  String get disclaimerLinkDavidPage =>
      'David Eppstein\'s fabulous UCI computer science theory page';

  @override
  String get disclaimerTextMiddle => '. The rest of the data is taken from ';

  @override
  String get disclaimerLinkDblp => 'DBLP';

  @override
  String get disclaimerTextEnd =>
      ', which is a database of computer science publications. DBLP was chosen because it assigns each researcher a unique ID automatically, it includes historical data, and it is fairly comprehensive. Alternatives, such as Google Scholar and ORCID, require the user to manually create their profile. DBLP is not perfect, however, being less comprehensive than Google Scholar, and not containing citation information which would have been nice to have. That being said, if there are any publications or changes you would like me to manually add, please contact me.';

  @override
  String get publicationsTheory => 'Theoretical Computer Science';

  @override
  String get publicationsTheorySubtitle =>
      'Randomized Algorithms and Data Structures';

  @override
  String get publicationsEducation => 'Computer Science Education';

  @override
  String get publicationsEducationSubtitle => 'Research in CS Education at UCI';

  @override
  String get publicationsEducationIntro =>
      'I\'ve had the opportunity to tag along on some CS ed research projects.';

  @override
  String get educationJourney => 'Educational Journey';

  @override
  String get educationJourneySubtitle => 'From High School to Graduate Studies';

  @override
  String get educationBackground => 'Academic Background';

  @override
  String get educationBackgroundSubtitle =>
      'Computer Science and Physics at UCI';

  @override
  String get educationCurrentStudies => 'Current Studies';

  @override
  String get educationCurrentStudiesDetails =>
      'PhD in CS Theory (Algorithms in the Real World), UCI, ongoing';

  @override
  String get educationMasterNote => 'Masters attained on the way';

  @override
  String get educationUndergrad => 'Undergraduate Studies';

  @override
  String get educationStoryStart =>
      'I was raised in Cupertino, CA, and graduated from ';

  @override
  String get educationStoryMid =>
      '. My passion for programming ignited during my freshman year with my first programming course. I continued to engage with AP Computer Science A as both a student and teaching assistant. In 2017, I started at ';

  @override
  String get educationStoryEnd =>
      ', pursuing a double major in Computer Science and Physics, graduating in 2021. Currently, I am pursuing a PhD at UCI.';

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
  String get industryExperienceSubtitle =>
      'From Startups to Large Corporations';

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
        'ACDA':
            'SIAM Conference on Applied and Computational Discrete Algorithms',
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
        'Best_Student_Presentation': 'Best Student Presentation',
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
  String get advisorAndGraduation => 'Graduation Details';

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

  @override
  String get noInformationAvailable => 'No Information Available';

  @override
  String get noInformationAvailableDescription =>
      'There is currently no information available about this researcher in our database. This could be because they have not yet published any papers that appear in DBLP, or their publications have not been linked to their profile.';

  @override
  String get labHighlightsTitle => 'Lab Highlights';

  @override
  String get labHighlightsSubtitle =>
      'Key statistics and insights about the lab';

  @override
  String get mostTotalCollaborations => 'Most Total Collaborations';

  @override
  String get studentsLabel => 'Students:';

  @override
  String get labMembersCategorySubtitle =>
      'Breakdown of lab members by category';

  @override
  String get papersCollaborationSubtitle =>
      'Distribution of papers by number of lab member collaborators';

  @override
  String get labMemberDistributionTitle => 'Lab Member Distribution';

  @override
  String get labMembersPerPaperTitle => 'Lab Members Per Paper';

  @override
  String get mostStudentCollaborations => 'Most Student Collaborations';

  @override
  String get mostFacultyCollaborations => 'Most Faculty Collaborations';

  @override
  String get facultyLabel => 'Faculty:';

  @override
  String get collaborationsPerYearTitle => 'Collaborations Per Year';

  @override
  String get graduationsPerYearTitle => 'Graduations Per Year';

  @override
  String get publicationsPerYearTitle => 'Publications Per Year';

  @override
  String get recentGraduatesTitle => 'Recent Graduates';

  @override
  String get publicationTypesDistributionTitle =>
      'Publication Types Distribution';

  @override
  String get recentCurrentStudentPapers => 'Recent Current Student Papers';

  @override
  String get recentGraduatedStudentPapers => 'Recent Graduated Student Papers';

  @override
  String get recentPostdocPapers => 'Recent Postdoc Papers';

  @override
  String get recentCurrentFacultyPapers => 'Recent Current Faculty Papers';

  @override
  String get recentEmeritusFacultyPapers => 'Recent Emeritus Faculty Papers';

  @override
  String get recentLabCollaborations => 'Recent Lab Collaborations';

  @override
  String get prolificCurrentStudents => 'Prolific Current Students';

  @override
  String get prolificGraduatedStudents => 'Prolific Graduated Students';

  @override
  String get prolificPostdocs => 'Prolific Postdocs';

  @override
  String get prolificCurrentFaculty => 'Prolific Current Faculty';

  @override
  String get prolificEmeritusFaculty => 'Prolific Emeritus Faculty';

  @override
  String get studentsCategory => 'Students';

  @override
  String get unknownYear => 'Unknown';

  @override
  String get currentFacultyMostGraduates =>
      'Current Faculty with Most Graduates';

  @override
  String get emeritusFacultyMostGraduates =>
      'Emeritus Faculty with Most Graduates';

  @override
  String get publicationsAxis => 'Publications';

  @override
  String get collaborationsAxis => 'Collaborations';

  @override
  String get graduationsAxis => 'Graduations';

  @override
  String paper(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count papers',
      one: '1 paper',
    );
    return '$_temp0';
  }

  @override
  String graduate(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count graduates',
      one: '1 graduate',
    );
    return '$_temp0';
  }

  @override
  String get currentStudentsCategory => 'Current Students';

  @override
  String get graduatedStudentsCategory => 'Graduated Students';

  @override
  String get postdocsCategory => 'Postdocs';

  @override
  String get currentFacultyCategory => 'Current Faculty';

  @override
  String get emeritusFacultyCategory => 'Emeritus Faculty';

  @override
  String get oneMemberCategory => 'One Member';

  @override
  String get twoMembersCategory => 'Two Members';

  @override
  String get threeMembersCategory => 'Three Members';

  @override
  String get fourMembersCategory => 'Four Members';

  @override
  String get fiveMembersCategory => 'Five Members';

  @override
  String get sixPlusMembersCategory => 'Six+ Members';

  @override
  String get wellConnectedCurrentStudents => 'Well-Connected Current Students';

  @override
  String get wellConnectedGraduatedStudents =>
      'Well-Connected Graduated Students';

  @override
  String get wellConnectedPostdocs => 'Well-Connected Postdocs';

  @override
  String get wellConnectedCurrentFaculty => 'Well-Connected Current Faculty';

  @override
  String get wellConnectedEmeritusFaculty => 'Well-Connected Emeritus Faculty';

  @override
  String get yearAxisLabel => 'Year';

  @override
  String collaborator(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count collaborators',
      one: '1 collaborator',
    );
    return '$_temp0';
  }

  @override
  String city(String key) {
    String _temp0 = intl.Intl.selectLogic(
      key,
      {
        'Honolulu_Hawaii': 'Honolulu, Hawaii',
        'Montreal_Quebec': 'Montréal, Québec',
        'Irvine_California': 'Irvine, California',
        'Pittsburgh_Pennsylvania': 'Pittsburgh, Pennsylvania',
        'Rome_Italy': 'Rome, Italy',
        'Toronto_Ontario': 'Toronto, Ontario',
        'other': '$key',
      },
    );
    return '$_temp0';
  }

  @override
  String venue(String key) {
    String _temp0 = intl.Intl.selectLogic(
      key,
      {
        'Prince_Waikiki': 'Prince Waikiki',
        'Concordia_University': 'Concordia University',
        'University_of_California_Irvine': 'University of California, Irvine',
        'David_L_Lawrence_Convention_Center':
            'David L. Lawrence Convention Center',
        'Luiss_University': 'Luiss University',
        'Montreal_Convention_Center': 'Montréal Convention Center',
        'York_University': 'York University',
        'other': '$key',
      },
    );
    return '$_temp0';
  }
}
