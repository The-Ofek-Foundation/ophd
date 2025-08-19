import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_he.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('he')
  ];

  /// No description provided for @ofekGila.
  ///
  /// In en, this message translates to:
  /// **'Ofek Gila'**
  String get ofekGila;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Ofek\'s Portfolio'**
  String get title;

  /// No description provided for @mySubtitle.
  ///
  /// In en, this message translates to:
  /// **'PhD Student, Computer Science @ UCI'**
  String get mySubtitle;

  /// No description provided for @label.
  ///
  /// In en, this message translates to:
  /// **'{key, select, GoogleScholar {Google Scholar} other {{key}}}'**
  String label(String key);

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'{key, select, ofek {Ofek Gila} mikeg {Michael Goodrich} bob {Robert Tarjan} evrim {Evrim Ozel} mikes {Michael Shindler} miked {Michael Dillencourt} nero {Nero Li} shahar {Shahar Broner} yubin {Yubin Kim} katrina {Katrina Mizuo} elijah {Elijah Sauder} claire {Claire To} albert {Albert Wang} abraham {Abraham Illickan} vinesh {Vinesh Sridhar} paul {Paul Erdős} hedet {Stephan Hedetniemi} david {David Eppstein} ryuto {Ryuto Kitagawa} other {{key}}}'**
  String name(String key);

  /// No description provided for @page.
  ///
  /// In en, this message translates to:
  /// **'{key, select, other {{key}}}'**
  String page(String key);

  /// No description provided for @researchPrimary.
  ///
  /// In en, this message translates to:
  /// **'Primary Research'**
  String get researchPrimary;

  /// No description provided for @researchPrimarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Algorithms in the Real World'**
  String get researchPrimarySubtitle;

  /// No description provided for @researchCollaborators.
  ///
  /// In en, this message translates to:
  /// **'Research Collaborators'**
  String get researchCollaborators;

  /// No description provided for @researchCollaboratorsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Special thanks to my amazing advisor, {name}'**
  String researchCollaboratorsSubtitle(String name);

  /// No description provided for @researchDescription.
  ///
  /// In en, this message translates to:
  /// **'My work combines computer science theory with experimental validation, focusing on randomized data structures including graph models and binary search trees.'**
  String get researchDescription;

  /// No description provided for @erdosNumber.
  ///
  /// In en, this message translates to:
  /// **'Erdős Number'**
  String get erdosNumber;

  /// No description provided for @erdosNumberSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Learn more about Erdős numbers'**
  String get erdosNumberSubtitle;

  /// No description provided for @labGraphTitle.
  ///
  /// In en, this message translates to:
  /// **'Lab Collaboration Graph'**
  String get labGraphTitle;

  /// No description provided for @labGraphSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Interactive visualization of research collaborations'**
  String get labGraphSubtitle;

  /// No description provided for @labGraphDescriptionStart.
  ///
  /// In en, this message translates to:
  /// **'Here is a graph of all the members of my lab, the '**
  String get labGraphDescriptionStart;

  /// No description provided for @labGraphDescriptionLink.
  ///
  /// In en, this message translates to:
  /// **'theory lab'**
  String get labGraphDescriptionLink;

  /// No description provided for @labGraphDescriptionEnd.
  ///
  /// In en, this message translates to:
  /// **', at UCI. Edges correspond to co-authorship on research papers. Feel free to select faculty members to see their collaborations, and on any person to see more details.'**
  String get labGraphDescriptionEnd;

  /// No description provided for @unconnectedLabMembersTitle.
  ///
  /// In en, this message translates to:
  /// **'Unconnected Lab Members'**
  String get unconnectedLabMembersTitle;

  /// No description provided for @unconnectedLabMembersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The {count} lab members who have not (yet) collaborated with any other lab members or shown faculty are listed below.'**
  String unconnectedLabMembersSubtitle(int count);

  /// No description provided for @link.
  ///
  /// In en, this message translates to:
  /// **'{key, select, viewPaper {View paper} viewPage {View {name}\'s page} other {{key}}}'**
  String link(String key, String name);

  /// No description provided for @labGraphInfo.
  ///
  /// In en, this message translates to:
  /// **'If you are a lab member and have a missing connection, please try syncing the database from the reload button. If that doesn\'t work, it is possible that either your publication is too recent and does not (yet) appear in DBLP, I have an incorrect DBLP ID associated with you, or your publication is in an adjacent field and does not appear in DBLP. In either case, you can contact me to manually update the data.'**
  String get labGraphInfo;

  /// No description provided for @labInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'UCI Theory Lab'**
  String get labInfoTitle;

  /// No description provided for @labInfoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Exploring theoretical computer science since 1975'**
  String get labInfoSubtitle;

  /// No description provided for @labInfoDescription.
  ///
  /// In en, this message translates to:
  /// **'This page showcases the Theory Lab at the University of California, Irvine. It includes a visualization of lab collaborations, highlights of research achievements, and statistics about publications, students, and faculty members over the years.'**
  String get labInfoDescription;

  /// No description provided for @loadingLabData.
  ///
  /// In en, this message translates to:
  /// **'Loading Lab Data'**
  String get loadingLabData;

  /// No description provided for @syncDatabase.
  ///
  /// In en, this message translates to:
  /// **'Sync Database'**
  String get syncDatabase;

  /// No description provided for @fetchRealData.
  ///
  /// In en, this message translates to:
  /// **'Fetch Real Data'**
  String get fetchRealData;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @disclaimerTitle.
  ///
  /// In en, this message translates to:
  /// **'Disclaimer'**
  String get disclaimerTitle;

  /// No description provided for @disclaimerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Data may not be 100% accurate'**
  String get disclaimerSubtitle;

  /// No description provided for @disclaimerTextStart.
  ///
  /// In en, this message translates to:
  /// **'Knowledge of lab members is taken from '**
  String get disclaimerTextStart;

  /// No description provided for @disclaimerLinkDavidPage.
  ///
  /// In en, this message translates to:
  /// **'David Eppstein\'s fabulous UCI computer science theory page'**
  String get disclaimerLinkDavidPage;

  /// No description provided for @disclaimerTextMiddle.
  ///
  /// In en, this message translates to:
  /// **'. The rest of the data is taken from '**
  String get disclaimerTextMiddle;

  /// No description provided for @disclaimerLinkDblp.
  ///
  /// In en, this message translates to:
  /// **'DBLP'**
  String get disclaimerLinkDblp;

  /// No description provided for @disclaimerTextEnd.
  ///
  /// In en, this message translates to:
  /// **', which is a database of computer science publications. DBLP was chosen because it assigns each researcher a unique ID automatically, it includes historical data, and it is fairly comprehensive. Alternatives, such as Google Scholar and ORCID, require the user to manually create their profile. DBLP is not perfect, however, being less comprehensive than Google Scholar, and not containing citation information which would have been nice to have. That being said, if there are any publications or changes you would like me to manually add, please contact me.'**
  String get disclaimerTextEnd;

  /// No description provided for @publicationsTheory.
  ///
  /// In en, this message translates to:
  /// **'Theoretical Computer Science'**
  String get publicationsTheory;

  /// No description provided for @publicationsTheorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Randomized Algorithms and Data Structures'**
  String get publicationsTheorySubtitle;

  /// No description provided for @publicationsEducation.
  ///
  /// In en, this message translates to:
  /// **'Computer Science Education'**
  String get publicationsEducation;

  /// No description provided for @publicationsEducationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Research in CS Education at UCI'**
  String get publicationsEducationSubtitle;

  /// No description provided for @publicationsEducationIntro.
  ///
  /// In en, this message translates to:
  /// **'I\'ve had the opportunity to tag along on some CS ed research projects.'**
  String get publicationsEducationIntro;

  /// No description provided for @educationJourney.
  ///
  /// In en, this message translates to:
  /// **'Educational Journey'**
  String get educationJourney;

  /// No description provided for @educationJourneySubtitle.
  ///
  /// In en, this message translates to:
  /// **'From High School to Graduate Studies'**
  String get educationJourneySubtitle;

  /// No description provided for @educationBackground.
  ///
  /// In en, this message translates to:
  /// **'Academic Background'**
  String get educationBackground;

  /// No description provided for @educationBackgroundSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Computer Science and Physics at UCI'**
  String get educationBackgroundSubtitle;

  /// No description provided for @educationCurrentStudies.
  ///
  /// In en, this message translates to:
  /// **'Current Studies'**
  String get educationCurrentStudies;

  /// No description provided for @educationCurrentStudiesDetails.
  ///
  /// In en, this message translates to:
  /// **'PhD in CS Theory (Algorithms in the Real World), UCI, ongoing'**
  String get educationCurrentStudiesDetails;

  /// No description provided for @educationMasterNote.
  ///
  /// In en, this message translates to:
  /// **'Masters attained on the way'**
  String get educationMasterNote;

  /// No description provided for @educationUndergrad.
  ///
  /// In en, this message translates to:
  /// **'Undergraduate Studies'**
  String get educationUndergrad;

  /// No description provided for @educationStoryStart.
  ///
  /// In en, this message translates to:
  /// **'I was raised in Cupertino, CA, and graduated from '**
  String get educationStoryStart;

  /// No description provided for @educationStoryMid.
  ///
  /// In en, this message translates to:
  /// **'. My passion for programming ignited during my freshman year with my first programming course. I continued to engage with AP Computer Science A as both a student and teaching assistant. In 2017, I started at '**
  String get educationStoryMid;

  /// No description provided for @educationStoryEnd.
  ///
  /// In en, this message translates to:
  /// **', pursuing a double major in Computer Science and Physics, graduating in 2021. Currently, I am pursuing a PhD at UCI.'**
  String get educationStoryEnd;

  /// No description provided for @montaVistaHS.
  ///
  /// In en, this message translates to:
  /// **'Monta Vista High School'**
  String get montaVistaHS;

  /// No description provided for @uci.
  ///
  /// In en, this message translates to:
  /// **'the University of California, Irvine'**
  String get uci;

  /// No description provided for @uciShort.
  ///
  /// In en, this message translates to:
  /// **'UCI'**
  String get uciShort;

  /// No description provided for @degree.
  ///
  /// In en, this message translates to:
  /// **'BS in {subject}, 2021'**
  String degree(String subject);

  /// No description provided for @physics.
  ///
  /// In en, this message translates to:
  /// **'Physics'**
  String get physics;

  /// No description provided for @computerScience.
  ///
  /// In en, this message translates to:
  /// **'Computer Science'**
  String get computerScience;

  /// No description provided for @uciHomepage.
  ///
  /// In en, this message translates to:
  /// **'UCI Homepage'**
  String get uciHomepage;

  /// No description provided for @uciTheoryGroup.
  ///
  /// In en, this message translates to:
  /// **'UCI Theory Group'**
  String get uciTheoryGroup;

  /// No description provided for @summa.
  ///
  /// In en, this message translates to:
  /// **'Summa Cum Laude'**
  String get summa;

  /// No description provided for @magna.
  ///
  /// In en, this message translates to:
  /// **'Magna Cum Laude'**
  String get magna;

  /// No description provided for @industryExperience.
  ///
  /// In en, this message translates to:
  /// **'Industry Experience'**
  String get industryExperience;

  /// No description provided for @industryExperienceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'From Startups to Large Corporations'**
  String get industryExperienceSubtitle;

  /// No description provided for @conference.
  ///
  /// In en, this message translates to:
  /// **'{key, select, COCOA {Conference on Combinatorial Optimization and Applications} WADS {Algorithms and Data Structures Symposium} CCSC {Journal of Computing Sciences in Colleges} SIGCSE {Special Interest Group on Computer Science Education} CIAC {International Conference on Algorithms and Complexity} ACDA {SIAM Conference on Applied and Computational Discrete Algorithms} other {{key}}}'**
  String conference(String key);

  /// No description provided for @award.
  ///
  /// In en, this message translates to:
  /// **'{key, select, Best_Paper {Best Paper} Best_Student_Presentation {Best Student Presentation} other {{key}}}'**
  String award(String key);

  /// No description provided for @advisor.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Advisor} other{Advisors}}'**
  String advisor(int count);

  /// No description provided for @graduationYear.
  ///
  /// In en, this message translates to:
  /// **'Graduation Year'**
  String get graduationYear;

  /// No description provided for @advisorAndGraduation.
  ///
  /// In en, this message translates to:
  /// **'Graduation Details'**
  String get advisorAndGraduation;

  /// No description provided for @thesisTitle.
  ///
  /// In en, this message translates to:
  /// **'Thesis Title'**
  String get thesisTitle;

  /// No description provided for @graduateStudents.
  ///
  /// In en, this message translates to:
  /// **'Graduate Students'**
  String get graduateStudents;

  /// No description provided for @current.
  ///
  /// In en, this message translates to:
  /// **'Current: {count}'**
  String current(int count);

  /// No description provided for @studentCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{student} other{students}}'**
  String studentCount(int count);

  /// No description provided for @recentGraduates.
  ///
  /// In en, this message translates to:
  /// **'Recent Graduates'**
  String get recentGraduates;

  /// No description provided for @publicationsByType.
  ///
  /// In en, this message translates to:
  /// **'Publications by Type'**
  String get publicationsByType;

  /// No description provided for @researchCollaborations.
  ///
  /// In en, this message translates to:
  /// **'Research Collaborations'**
  String get researchCollaborations;

  /// No description provided for @facultyCoauthors.
  ///
  /// In en, this message translates to:
  /// **'Faculty Co-authors'**
  String get facultyCoauthors;

  /// No description provided for @studentCoauthors.
  ///
  /// In en, this message translates to:
  /// **'Student Co-authors'**
  String get studentCoauthors;

  /// No description provided for @topLabCollaborators.
  ///
  /// In en, this message translates to:
  /// **'Top Lab Collaborators'**
  String get topLabCollaborators;

  /// No description provided for @recentLabCollaborators.
  ///
  /// In en, this message translates to:
  /// **'Recent Lab Collaborators'**
  String get recentLabCollaborators;

  /// No description provided for @recentPublications.
  ///
  /// In en, this message translates to:
  /// **'Recent Publications'**
  String get recentPublications;

  /// No description provided for @visitWebsite.
  ///
  /// In en, this message translates to:
  /// **'Visit website'**
  String get visitWebsite;

  /// No description provided for @viewOnDblp.
  ///
  /// In en, this message translates to:
  /// **'View on DBLP'**
  String get viewOnDblp;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @publicationType.
  ///
  /// In en, this message translates to:
  /// **'{type, select, article {Journal Articles} inproceedings {Conference Papers} proceedings {Proceedings} book {Books} incollection {Book Chapters} phdthesis {PhD Theses} unknown {Other Publications} other {{type}}}'**
  String publicationType(String type);

  /// No description provided for @noInformationAvailable.
  ///
  /// In en, this message translates to:
  /// **'No Information Available'**
  String get noInformationAvailable;

  /// No description provided for @noInformationAvailableDescription.
  ///
  /// In en, this message translates to:
  /// **'There is currently no information available about this researcher in our database. This could be because they have not yet published any papers that appear in DBLP, or their publications have not been linked to their profile.'**
  String get noInformationAvailableDescription;

  /// No description provided for @labHighlightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Lab Highlights'**
  String get labHighlightsTitle;

  /// No description provided for @labHighlightsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Key statistics and insights about the lab'**
  String get labHighlightsSubtitle;

  /// No description provided for @mostTotalCollaborations.
  ///
  /// In en, this message translates to:
  /// **'Most Total Collaborations'**
  String get mostTotalCollaborations;

  /// No description provided for @studentsLabel.
  ///
  /// In en, this message translates to:
  /// **'Students:'**
  String get studentsLabel;

  /// No description provided for @labMembersCategorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Breakdown of lab members by category'**
  String get labMembersCategorySubtitle;

  /// No description provided for @papersCollaborationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Distribution of papers by number of lab member collaborators'**
  String get papersCollaborationSubtitle;

  /// No description provided for @labMemberDistributionTitle.
  ///
  /// In en, this message translates to:
  /// **'Lab Member Distribution'**
  String get labMemberDistributionTitle;

  /// No description provided for @labMembersPerPaperTitle.
  ///
  /// In en, this message translates to:
  /// **'Lab Members Per Paper'**
  String get labMembersPerPaperTitle;

  /// No description provided for @mostStudentCollaborations.
  ///
  /// In en, this message translates to:
  /// **'Most Student Collaborations'**
  String get mostStudentCollaborations;

  /// No description provided for @mostFacultyCollaborations.
  ///
  /// In en, this message translates to:
  /// **'Most Faculty Collaborations'**
  String get mostFacultyCollaborations;

  /// No description provided for @facultyLabel.
  ///
  /// In en, this message translates to:
  /// **'Faculty:'**
  String get facultyLabel;

  /// No description provided for @collaborationsPerYearTitle.
  ///
  /// In en, this message translates to:
  /// **'Collaborations Per Year'**
  String get collaborationsPerYearTitle;

  /// No description provided for @graduationsPerYearTitle.
  ///
  /// In en, this message translates to:
  /// **'Graduations Per Year'**
  String get graduationsPerYearTitle;

  /// No description provided for @publicationsPerYearTitle.
  ///
  /// In en, this message translates to:
  /// **'Publications Per Year'**
  String get publicationsPerYearTitle;

  /// No description provided for @recentGraduatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent Graduates'**
  String get recentGraduatesTitle;

  /// No description provided for @publicationTypesDistributionTitle.
  ///
  /// In en, this message translates to:
  /// **'Publication Types Distribution'**
  String get publicationTypesDistributionTitle;

  /// No description provided for @recentCurrentStudentPapers.
  ///
  /// In en, this message translates to:
  /// **'Recent Current Student Papers'**
  String get recentCurrentStudentPapers;

  /// No description provided for @recentGraduatedStudentPapers.
  ///
  /// In en, this message translates to:
  /// **'Recent Graduated Student Papers'**
  String get recentGraduatedStudentPapers;

  /// No description provided for @recentPostdocPapers.
  ///
  /// In en, this message translates to:
  /// **'Recent Postdoc Papers'**
  String get recentPostdocPapers;

  /// No description provided for @recentCurrentFacultyPapers.
  ///
  /// In en, this message translates to:
  /// **'Recent Current Faculty Papers'**
  String get recentCurrentFacultyPapers;

  /// No description provided for @recentEmeritusFacultyPapers.
  ///
  /// In en, this message translates to:
  /// **'Recent Emeritus Faculty Papers'**
  String get recentEmeritusFacultyPapers;

  /// No description provided for @recentLabCollaborations.
  ///
  /// In en, this message translates to:
  /// **'Recent Lab Collaborations'**
  String get recentLabCollaborations;

  /// No description provided for @prolificCurrentStudents.
  ///
  /// In en, this message translates to:
  /// **'Prolific Current Students'**
  String get prolificCurrentStudents;

  /// No description provided for @prolificGraduatedStudents.
  ///
  /// In en, this message translates to:
  /// **'Prolific Graduated Students'**
  String get prolificGraduatedStudents;

  /// No description provided for @prolificPostdocs.
  ///
  /// In en, this message translates to:
  /// **'Prolific Postdocs'**
  String get prolificPostdocs;

  /// No description provided for @prolificCurrentFaculty.
  ///
  /// In en, this message translates to:
  /// **'Prolific Current Faculty'**
  String get prolificCurrentFaculty;

  /// No description provided for @prolificEmeritusFaculty.
  ///
  /// In en, this message translates to:
  /// **'Prolific Emeritus Faculty'**
  String get prolificEmeritusFaculty;

  /// No description provided for @studentsCategory.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get studentsCategory;

  /// No description provided for @unknownYear.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknownYear;

  /// No description provided for @currentFacultyMostGraduates.
  ///
  /// In en, this message translates to:
  /// **'Current Faculty with Most Graduates'**
  String get currentFacultyMostGraduates;

  /// No description provided for @emeritusFacultyMostGraduates.
  ///
  /// In en, this message translates to:
  /// **'Emeritus Faculty with Most Graduates'**
  String get emeritusFacultyMostGraduates;

  /// No description provided for @publicationsAxis.
  ///
  /// In en, this message translates to:
  /// **'Publications'**
  String get publicationsAxis;

  /// No description provided for @collaborationsAxis.
  ///
  /// In en, this message translates to:
  /// **'Collaborations'**
  String get collaborationsAxis;

  /// No description provided for @graduationsAxis.
  ///
  /// In en, this message translates to:
  /// **'Graduations'**
  String get graduationsAxis;

  /// No description provided for @paper.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 paper} other{{count} papers}}'**
  String paper(int count);

  /// No description provided for @graduate.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 graduate} other{{count} graduates}}'**
  String graduate(int count);

  /// No description provided for @currentStudentsCategory.
  ///
  /// In en, this message translates to:
  /// **'Current Students'**
  String get currentStudentsCategory;

  /// No description provided for @graduatedStudentsCategory.
  ///
  /// In en, this message translates to:
  /// **'Graduated Students'**
  String get graduatedStudentsCategory;

  /// No description provided for @postdocsCategory.
  ///
  /// In en, this message translates to:
  /// **'Postdocs'**
  String get postdocsCategory;

  /// No description provided for @currentFacultyCategory.
  ///
  /// In en, this message translates to:
  /// **'Current Faculty'**
  String get currentFacultyCategory;

  /// No description provided for @emeritusFacultyCategory.
  ///
  /// In en, this message translates to:
  /// **'Emeritus Faculty'**
  String get emeritusFacultyCategory;

  /// No description provided for @oneMemberCategory.
  ///
  /// In en, this message translates to:
  /// **'One Member'**
  String get oneMemberCategory;

  /// No description provided for @twoMembersCategory.
  ///
  /// In en, this message translates to:
  /// **'Two Members'**
  String get twoMembersCategory;

  /// No description provided for @threeMembersCategory.
  ///
  /// In en, this message translates to:
  /// **'Three Members'**
  String get threeMembersCategory;

  /// No description provided for @fourMembersCategory.
  ///
  /// In en, this message translates to:
  /// **'Four Members'**
  String get fourMembersCategory;

  /// No description provided for @fiveMembersCategory.
  ///
  /// In en, this message translates to:
  /// **'Five Members'**
  String get fiveMembersCategory;

  /// No description provided for @sixPlusMembersCategory.
  ///
  /// In en, this message translates to:
  /// **'Six+ Members'**
  String get sixPlusMembersCategory;

  /// No description provided for @wellConnectedCurrentStudents.
  ///
  /// In en, this message translates to:
  /// **'Well-Connected Current Students'**
  String get wellConnectedCurrentStudents;

  /// No description provided for @wellConnectedGraduatedStudents.
  ///
  /// In en, this message translates to:
  /// **'Well-Connected Graduated Students'**
  String get wellConnectedGraduatedStudents;

  /// No description provided for @wellConnectedPostdocs.
  ///
  /// In en, this message translates to:
  /// **'Well-Connected Postdocs'**
  String get wellConnectedPostdocs;

  /// No description provided for @wellConnectedCurrentFaculty.
  ///
  /// In en, this message translates to:
  /// **'Well-Connected Current Faculty'**
  String get wellConnectedCurrentFaculty;

  /// No description provided for @wellConnectedEmeritusFaculty.
  ///
  /// In en, this message translates to:
  /// **'Well-Connected Emeritus Faculty'**
  String get wellConnectedEmeritusFaculty;

  /// No description provided for @yearAxisLabel.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get yearAxisLabel;

  /// No description provided for @collaborator.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 collaborator} other{{count} collaborators}}'**
  String collaborator(int count);

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'{key, select, Honolulu_Hawaii {Honolulu, Hawaii} Montreal_Quebec {Montréal, Québec} Irvine_California {Irvine, California} Pittsburgh_Pennsylvania {Pittsburgh, Pennsylvania} Rome_Italy {Rome, Italy} Toronto_Ontario {Toronto, Ontario} other {{key}}}'**
  String city(String key);

  /// No description provided for @venue.
  ///
  /// In en, this message translates to:
  /// **'{key, select, Prince_Waikiki {Prince Waikiki} Concordia_University {Concordia University} University_of_California_Irvine {University of California, Irvine} David_L_Lawrence_Convention_Center {David L. Lawrence Convention Center} Luiss_University {Luiss University} Montreal_Convention_Center {Montréal Convention Center} York_University {York University} other {{key}}}'**
  String venue(String key);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'he'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'he':
      return AppLocalizationsHe();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
