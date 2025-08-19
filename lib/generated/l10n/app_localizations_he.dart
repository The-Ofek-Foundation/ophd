// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class AppLocalizationsHe extends AppLocalizations {
  AppLocalizationsHe([String locale = 'he']) : super(locale);

  @override
  String get ofekGila => 'אופק גילה';

  @override
  String get title => 'הפורטפוליו של אופק';

  @override
  String get mySubtitle => 'סטודנט דוקטורט, מדעי המחשב @ UCI';

  @override
  String label(String key) {
    String _temp0 = intl.Intl.selectLogic(
      key,
      {
        'Family': 'משפחה',
        'Website': 'אתר אישי',
        'Blog': 'בלוג',
        'LinkedIn': 'לינקדאין',
        'Email': 'אימייל',
        'Paper': 'מאמר',
        'WhatsApp': 'וואטסאפ',
        'Resume': 'קורות החיים',
        'Sync': 'אחזר שיתופי פעולה חדשים',
        'GoogleScholar': 'גוגל סקולר',
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
        'ofek': 'אופק גילה',
        'mikeg': 'מייקל גודריץ\'',
        'bob': 'רוברט טרג\'אן',
        'evrim': 'אברים אוזל',
        'mikes': 'מייקל שינדלר',
        'miked': 'מייקל דילנקורט',
        'nero': 'נירו לי',
        'shahar': 'שחר ברונר',
        'yubin': 'יובין קים',
        'katrina': 'קתרינה מיזאו',
        'elijah': 'אליהו סאדר',
        'claire': 'קלייר טו',
        'albert': 'אלברט וואנג',
        'abraham': 'אברהם איליקן',
        'vinesh': 'וינש סרידהאר',
        'paul': 'פול ארדש',
        'hedet': 'סטפן הדטנימי',
        'david': 'דייוויד אפשטיין',
        'ryuto': 'ריוטו קיטגאווה',
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
        'About': 'אודות',
        'Research': 'מחקר',
        'Publications': 'פרסומים',
        'Education': 'השכלה',
        'Contact': 'צור קשר',
        'Industry': 'תעשייה',
        'Lab': 'מעבדה',
        'other': '$key',
      },
    );
    return '$_temp0';
  }

  @override
  String get researchPrimary => 'מחקר עיקרי';

  @override
  String get researchPrimarySubtitle => 'אלגוריתמים בעולם האמיתי';

  @override
  String get researchCollaborators => 'שותפי מחקר';

  @override
  String researchCollaboratorsSubtitle(String name) {
    return 'תודה במיוחד למנחה המדהים שלי, $name';
  }

  @override
  String get researchDescription =>
      'עבודתי משלבת תיאוריה במדעי המחשב עם אימות ניסיוני, תוך התמקדות במבני נתונים אקראיים, כולל מודלים של גרפים ועצי חיפוש בינאריים.';

  @override
  String get erdosNumber => 'מספר ארדש';

  @override
  String get erdosNumberSubtitle => 'למד עוד על מספרי ארדש';

  @override
  String get labGraphTitle => 'גרף שיתופי פעולה במעבדה';

  @override
  String get labGraphSubtitle =>
      'ויזואליזציה אינטראקטיבית של שיתופי פעולה במחקר';

  @override
  String get labGraphDescriptionStart => 'לפניכם גרף של כל חברי המעבדה שלי, ';

  @override
  String get labGraphDescriptionLink => 'מעבדת התיאוריה';

  @override
  String get labGraphDescriptionEnd =>
      ', ב-UCI. הקשתות מייצגות כתיבה משותפת של מאמרי מחקר. אתם מוזמנים לבחור בחברי הסגל כדי לראות את שיתופי הפעולה שלהם, ועל כל אדם כדי לראות פרטים נוספים.';

  @override
  String get unconnectedLabMembersTitle => 'חברי מעבדה ללא קשרים';

  @override
  String unconnectedLabMembersSubtitle(int count) {
    return 'ה-$count חברי המעבדה שטרם שיתפו פעולה עם חברי מעבדה אחרים או עם חברי הסגל המוצגים באיור, רשומים מטה.';
  }

  @override
  String link(String key, String name) {
    String _temp0 = intl.Intl.selectLogic(
      key,
      {
        'viewPaper': 'צפה במאמר',
        'viewPage': 'צפה בעמוד של $name',
        'other': '$key',
      },
    );
    return '$_temp0';
  }

  @override
  String get labGraphInfo =>
      'אם אתה חבר מעבדה ואם חסר לך חיבור, אנא נסה לסנכרן את מסד הנתונים באמצעות כפתור הטעינה מחדש. אם זה לא עובד, ייתכן שהפרסום שלך חדש מדי ועדיין לא מופיע ב-DBLP, שיש לי מזהה DBLP שגוי המשויך אליך, או שהפרסום שלך בתחום משיק ואינו מופיע ב-DBLP. בכל אחד מהמקרים, תוכל ליצור איתי קשר כדי לעדכן את הנתונים באופן ידני.';

  @override
  String get labInfoTitle => 'מעבדת התיאוריה של UCI';

  @override
  String get labInfoSubtitle => 'חוקרים מדעי המחשב התיאורטיים מאז 1975';

  @override
  String get labInfoDescription =>
      'עמוד זה מציג את מעבדת התיאוריה באוניברסיטת קליפורניה, אירווין. הוא כולל ויזואליזציה של שיתופי פעולה במעבדה, הדגשה של הישגי מחקר, וסטטיסטיקות על פרסומים, סטודנטים וחברי סגל לאורך השנים.';

  @override
  String get loadingLabData => 'טוען נתוני מעבדה';

  @override
  String get syncDatabase => 'סנכרון מסד נתונים';

  @override
  String get fetchRealData => 'אחזר נתונים אמיתיים';

  @override
  String get tryAgain => 'נסה שוב';

  @override
  String get error => 'שגיאה';

  @override
  String get disclaimerTitle => 'הסתייגות';

  @override
  String get disclaimerSubtitle => 'הנתונים עלולים לא להיות מדויקים ב-100%';

  @override
  String get disclaimerTextStart => 'המידע על חברי המעבדה נלקח מ';

  @override
  String get disclaimerLinkDavidPage =>
      'עמוד התיאוריה המדהים של דייוויד אפשטיין מ-UCI';

  @override
  String get disclaimerTextMiddle => '. שאר הנתונים נלקחים מ';

  @override
  String get disclaimerLinkDblp => 'DBLP';

  @override
  String get disclaimerTextEnd =>
      ', שהוא מסד נתונים של פרסומים במדעי המחשב. DBLP נבחר מכיוון שהוא מקצה לכל חוקר מזהה ייחודי באופן אוטומטי, הוא כולל נתונים היסטוריים, והוא מקיף למדי. חלופות, כמו Google Scholar ו-ORCID, דורשות מהמשתמש ליצור את הפרופיל שלו באופן ידני. DBLP אינו מושלם, עם זאת, הוא פחות מקיף מ-Google Scholar, ואינו מכיל מידע על ציטוטים שהיה נחמד שיהיה. עם זאת, אם יש פרסומים או שינויים שתרצו שאוסיף באופן ידני, אנא צרו איתי קשר.';

  @override
  String get publicationsTheory => 'מדעי המחשב התיאורטיים';

  @override
  String get publicationsTheorySubtitle => 'אלגוריתמים ומבני נתונים אקראיים';

  @override
  String get publicationsEducation => 'חינוך במדעי המחשב';

  @override
  String get publicationsEducationSubtitle => 'מחקר בחינוך במדעי המחשב ב-UCI';

  @override
  String get publicationsEducationIntro =>
      'הייתה לי הזדמנות להשתתף בכמה מחקרים בתחום החינוך במדעי המחשב.';

  @override
  String get educationJourney => 'מסע חינוכי';

  @override
  String get educationJourneySubtitle => 'מהתיכון ועד ללימודים מתקדמים';

  @override
  String get educationBackground => 'רקע אקדמי';

  @override
  String get educationBackgroundSubtitle => 'מדעי המחשב ופיזיקה ב-UCI';

  @override
  String get educationCurrentStudies => 'לימודים נוכחיים';

  @override
  String get educationCurrentStudiesDetails =>
      'דוקטורט בתיאוריה של מדעי המחשב (אלגוריתמים בעולם האמיתי), UCI, מתמשך';

  @override
  String get educationMasterNote => 'תואר שני הושג בדרך';

  @override
  String get educationUndergrad => 'לימודי תואר ראשון';

  @override
  String get educationStoryStart => 'גדלתי בקופרטינו, קליפורניה, וסיימתי את ';

  @override
  String get educationStoryMid =>
      '. התשוקה שלי לתכנות התעוררה במהלך שנת הלימודים הראשונה שלי עם קורס התכנות הראשון שלי. המשכתי להשתתף ב-AP Computer Science A הן כתלמיד והן כעוזר הוראה. בשנת 2017, התחלתי ב-';

  @override
  String get educationStoryEnd =>
      ', בתואר כפול במדעי המחשב ופיזיקה, וסיימתי בשנת 2021. כיום, אני לומד לדוקטורט ב-UCI.';

  @override
  String get montaVistaHS => 'תיכון מונטה ויסטה';

  @override
  String get uci => 'אוניברסיטת קליפורניה, אירווין';

  @override
  String get uciShort => 'UCI';

  @override
  String degree(String subject) {
    return 'תואר ראשון ב$subject, 2021';
  }

  @override
  String get physics => 'פיזיקה';

  @override
  String get computerScience => 'מדעי המחשב';

  @override
  String get uciHomepage => 'דף הבית של UCI';

  @override
  String get uciTheoryGroup => 'קבוצת התיאוריה של UCI';

  @override
  String get summa => 'סומה קום לאודה';

  @override
  String get magna => 'מגנה קום לאודה';

  @override
  String get industryExperience => 'ניסיון תעשייתי';

  @override
  String get industryExperienceSubtitle => 'מסטארט-אפים ועד תאגידים גדולים';

  @override
  String conference(String key) {
    String _temp0 = intl.Intl.selectLogic(
      key,
      {
        'COCOA': 'הכנס לאופטימיזציה קומבינטורית ויישומים',
        'WADS': 'הסימפוזיון לאלגוריתמים ומבני נתונים',
        'CCSC': 'כתב העת למדעי המחשב במכללות',
        'SIGCSE': 'קבוצת העניין המיוחדת בחינוך מדעי המחשב',
        'CIAC': 'הכנס הבינלאומי לאלגוריתמים ומורכבות',
        'ACDA': 'הכנס של סיאם לאלגוריתמים בדידים יישומיים וחישוביים',
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
        'Best_Paper': 'מאמר מצטיין',
        'Best_Student_Presentation': 'הרצאת הסטודנט המצטיינת',
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
      other: 'מנחים',
      one: 'מנחה',
    );
    return '$_temp0';
  }

  @override
  String get graduationYear => 'שנת סיום';

  @override
  String get advisorAndGraduation => 'פרטי סיום';

  @override
  String get thesisTitle => 'כותרת התזה';

  @override
  String get graduateStudents => 'תלמידי מחקר';

  @override
  String current(int count) {
    return 'נוכחי: $count';
  }

  @override
  String studentCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'סטודנטים',
      one: 'סטודנט',
    );
    return '$_temp0';
  }

  @override
  String get recentGraduates => 'בוגרים אחרונים';

  @override
  String get publicationsByType => 'פרסומים לפי סוג';

  @override
  String get researchCollaborations => 'שיתופי פעולה מחקריים';

  @override
  String get facultyCoauthors => 'שותפי כתיבה מהסגל';

  @override
  String get studentCoauthors => 'שותפי כתיבה סטודנטים';

  @override
  String get topLabCollaborators => 'שותפי מעבדה מובילים';

  @override
  String get recentLabCollaborators => 'שותפי מעבדה אחרונים';

  @override
  String get recentPublications => 'פרסומים אחרונים';

  @override
  String get visitWebsite => 'בקר באתר';

  @override
  String get viewOnDblp => 'צפה ב-DBLP';

  @override
  String get done => 'סיום';

  @override
  String publicationType(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'article': 'מאמרי עת',
        'inproceedings': 'מאמרי כנסים',
        'proceedings': 'כנסים',
        'book': 'ספרים',
        'incollection': 'פרקי ספרים',
        'phdthesis': 'תזות דוקטורט',
        'unknown': 'פרסומים אחרים',
        'other': '$type',
      },
    );
    return '$_temp0';
  }

  @override
  String get noInformationAvailable => 'אין מידע זמין';

  @override
  String get noInformationAvailableDescription =>
      'אין כרגע מידע זמין על חוקר זה במאגר שלנו. ייתכן שהם עדיין לא פרסמו מאמרים שמופיעים ב-DBLP, או שהפרסומים שלהם לא קושרו לפרופיל שלהם.';

  @override
  String get labHighlightsTitle => 'דגשים של המעבדה';

  @override
  String get labHighlightsSubtitle => 'סטטיסטיקות מרכזיות ותובנות על המעבדה';

  @override
  String get mostTotalCollaborations => 'הכי הרבה שיתופי פעולה';

  @override
  String get studentsLabel => 'סטודנטים:';

  @override
  String get labMembersCategorySubtitle => 'פירוט חברי המעבדה לפי קטגוריה';

  @override
  String get papersCollaborationSubtitle =>
      'חלוקת מאמרים לפי מספר שותפי פעולה מחברי המעבדה';

  @override
  String get labMemberDistributionTitle => 'חלוקת חברי המעבדה';

  @override
  String get labMembersPerPaperTitle => 'חברי מעבדה למאמר';

  @override
  String get mostStudentCollaborations => 'הכי הרבה שיתופי פעולה עם סטודנטים';

  @override
  String get mostFacultyCollaborations => 'הכי הרבה שיתופי פעולה עם סגל';

  @override
  String get facultyLabel => 'סגל:';

  @override
  String get collaborationsPerYearTitle => 'שיתופי פעולה לפי שנה';

  @override
  String get graduationsPerYearTitle => 'סיום תואר לפי שנה';

  @override
  String get publicationsPerYearTitle => 'פרסומים לפי שנה';

  @override
  String get recentGraduatesTitle => 'בוגרים לאחרונה';

  @override
  String get publicationTypesDistributionTitle => 'חלוקת סוגי פרסומים';

  @override
  String get recentCurrentStudentPapers => 'מאמרים אחרונים של סטודנטים נוכחיים';

  @override
  String get recentGraduatedStudentPapers =>
      'מאמרים אחרונים של סטודנטים בוגרים';

  @override
  String get recentPostdocPapers => 'מאמרים אחרונים של פוסט דוקטורנטים';

  @override
  String get recentCurrentFacultyPapers => 'מאמרים אחרונים של סגל נוכחי';

  @override
  String get recentEmeritusFacultyPapers => 'מאמרים אחרונים של סגל אמריטוס';

  @override
  String get recentLabCollaborations => 'שיתופי פעולה אחרונים במעבדה';

  @override
  String get prolificCurrentStudents => 'סטודנטים נוכחיים פרודוקטיביים';

  @override
  String get prolificGraduatedStudents => 'סטודנטים בוגרים פרודוקטיביים';

  @override
  String get prolificPostdocs => 'פוסט דוקטורנטים פרודוקטיביים';

  @override
  String get prolificCurrentFaculty => 'סגל נוכחי פרודוקטיבי';

  @override
  String get prolificEmeritusFaculty => 'סגל אמריטוס פרודוקטיבי';

  @override
  String get studentsCategory => 'סטודנטים';

  @override
  String get unknownYear => 'לא ידוע';

  @override
  String get currentFacultyMostGraduates => 'סגל נוכחי עם הכי הרבה בוגרים';

  @override
  String get emeritusFacultyMostGraduates => 'סגל אמריטוס עם הכי הרבה בוגרים';

  @override
  String get publicationsAxis => 'פרסומים';

  @override
  String get collaborationsAxis => 'שיתופי פעולה';

  @override
  String get graduationsAxis => 'סיום תואר';

  @override
  String paper(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count מאמרים',
      one: 'מאמר 1',
    );
    return '$_temp0';
  }

  @override
  String graduate(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count בוגרים',
      one: 'בוגר 1',
    );
    return '$_temp0';
  }

  @override
  String get currentStudentsCategory => 'סטודנטים נוכחיים';

  @override
  String get graduatedStudentsCategory => 'סטודנטים בוגרים';

  @override
  String get postdocsCategory => 'פוסט דוקטורנטים';

  @override
  String get currentFacultyCategory => 'סגל נוכחי';

  @override
  String get emeritusFacultyCategory => 'סגל אמריטוס';

  @override
  String get oneMemberCategory => 'חבר אחד';

  @override
  String get twoMembersCategory => 'שני חברים';

  @override
  String get threeMembersCategory => 'שלושה חברים';

  @override
  String get fourMembersCategory => 'ארבעה חברים';

  @override
  String get fiveMembersCategory => 'חמישה חברים';

  @override
  String get sixPlusMembersCategory => 'שישה חברים ויותר';

  @override
  String get wellConnectedCurrentStudents => 'סטודנטים נוכחיים מחוברים היטב';

  @override
  String get wellConnectedGraduatedStudents => 'סטודנטים בוגרים מחוברים היטב';

  @override
  String get wellConnectedPostdocs => 'פוסט דוקטורנטים מחוברים היטב';

  @override
  String get wellConnectedCurrentFaculty => 'סגל נוכחי מחובר היטב';

  @override
  String get wellConnectedEmeritusFaculty => 'סגל אמריטוס מחובר היטב';

  @override
  String get yearAxisLabel => 'שנה';

  @override
  String collaborator(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count שותפים',
      one: 'שותף 1',
    );
    return '$_temp0';
  }

  @override
  String city(String key) {
    String _temp0 = intl.Intl.selectLogic(
      key,
      {
        'Honolulu_Hawaii': 'הונולולו, הוואי',
        'Montreal_Quebec': 'מונטריאול, קוויבק',
        'Irvine_California': 'אירווין, קליפורניה',
        'Pittsburgh_Pennsylvania': 'פיטסבורג, פנסילבניה',
        'Rome_Italy': 'רומא, איטליה',
        'Toronto_Ontario': 'טורונטו, אונטריו',
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
        'Prince_Waikiki': 'פרינס וויקיקי',
        'Concordia_University': 'אוניברסיטת קונקורדיה',
        'University_of_California_Irvine': 'אוניברסיטת קליפורניה, אירווין',
        'David_L_Lawrence_Convention_Center': 'מרכז הכנסים דייוויד ל. לורנס',
        'Luiss_University': 'אוניברסיטת לואיס',
        'Montreal_Convention_Center': 'מרכז הכנסים של מונטריאול',
        'York_University': 'אוניברסיטת יורק',
        'other': '$key',
      },
    );
    return '$_temp0';
  }
}
