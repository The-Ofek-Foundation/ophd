import 'package:json_annotation/json_annotation.dart';

part 'researcher.g.dart';

@JsonSerializable()
class Researcher {
  @JsonKey(required: true)
  String name;

  @JsonKey(required: true)
  String dblpPid;

  String? url;

  @JsonKey(includeFromJson: false, includeToJson: false)
  List<Researcher> collaborators = const [];

  @JsonKey(name: 'collaborators')
  List<String> collaboratorNames;

  bool hasDoctorate;

  Researcher({
    required this.name,
    required this.dblpPid,
    this.url,
    required this.collaboratorNames,
    this.hasDoctorate = false,
  });

  factory Researcher.fromJson(Map<String, dynamic> json) => _$ResearcherFromJson(json);

  Map<String, dynamic> toJson() => _$ResearcherToJson(this);
}

@JsonSerializable()
class StudentResearcher extends Researcher {
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<Researcher>? advisors;

  @JsonKey(name: 'advisors')
  List<String>? advisorNames;

  @JsonKey(required: true)
  bool isPostDoc;

  int? year;

  String? thesisTitle;

  StudentResearcher({
    required super.name,
    super.url,
    required super.dblpPid,
    required super.collaboratorNames,
    required List<String> this.advisorNames,
    required super.hasDoctorate,
    this.year,
    this.thesisTitle,
    this.isPostDoc = false,
  });

  factory StudentResearcher.fromJson(Map<String, dynamic> json) => _$StudentResearcherFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$StudentResearcherToJson(this);
}

@JsonSerializable()
class ProfessorResearcher extends Researcher {
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<Researcher>? students;

  @JsonKey(name: 'students')
  List<String>? studentNames;

  @JsonKey(required: true)
  String title;

  @JsonKey(required: true)
  bool isEmeritus;

  @JsonKey(includeFromJson: false)
  @override
  bool get hasDoctorate => true;

  ProfessorResearcher({
    required super.name,
    super.url,
    required super.dblpPid,
    required super.collaboratorNames,
    this.studentNames,
    required this.title,
    this.isEmeritus = false,
  });

  factory ProfessorResearcher.fromJson(Map<String, dynamic> json) => _$ProfessorResearcherFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ProfessorResearcherToJson(this);
}

@JsonSerializable()
class AllResearchers {
  List<StudentResearcher> students;
  List<ProfessorResearcher> professors;

  AllResearchers({
    required this.students,
    required this.professors,
  });

  factory AllResearchers.fromJson(Map<String, dynamic> json) {
    final allResearchers = _$AllResearchersFromJson(json);

    final nameToResearcher = <String, Researcher>{};
    for (final student in allResearchers.students) {
      nameToResearcher[student.name] = student;
    }

    for (final professor in allResearchers.professors) {
      nameToResearcher[professor.name] = professor;
    }

    for (final student in allResearchers.students) {
      student.collaborators = student.collaboratorNames.where(nameToResearcher.containsKey).map((name) => nameToResearcher[name]!).toList();
      student.advisors = student.advisorNames?.where(nameToResearcher.containsKey).map((name) => nameToResearcher[name]!).toList() ?? [];
    }

    for (final professor in allResearchers.professors) {
      professor.collaborators = professor.collaboratorNames.where(nameToResearcher.containsKey).map((name) => nameToResearcher[name]!).toList();
      professor.students = professor.studentNames?.where(nameToResearcher.containsKey).map((name) => nameToResearcher[name]!).toList() ?? [];
    }

    return allResearchers;
  }

  Map<String, dynamic> toJson() => _$AllResearchersToJson(this);
}
