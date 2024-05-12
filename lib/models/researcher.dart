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
  List<Researcher> collaborators;

  @JsonKey(name: 'collaborators')
  List<String> collaboratorNames;

  Researcher({
    required this.name,
    required this.dblpPid,
    this.url,
    required this.collaboratorNames,
    this.collaborators = const [],
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

  bool hasDoctorate;

  int? year;

  String? thesisTitle;

  StudentResearcher({
    required String name,
    String? url,
    required String dblpPid,
    required List<String> collaboratorNames,
    required List<String> this.advisorNames,
    required this.hasDoctorate,
    this.year,
    this.thesisTitle,
  }) : super(
    name: name,
    url: url,
    dblpPid: dblpPid,
    collaboratorNames: collaboratorNames,
  );

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

  ProfessorResearcher({
    required String name,
    String? url,
    required String dblpPid,
    required List<String> collaboratorNames,
    List<String>? studentNames,
  }) : super(
    name: name,
    url: url,
    dblpPid: dblpPid,
    collaboratorNames: collaboratorNames,
  );

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
      student.collaborators = student.collaboratorNames.map((name) => nameToResearcher[name]!).toList();
      student.advisors = student.advisorNames?.map((name) => nameToResearcher[name]!).toList() ?? [];
    }

    for (final professor in allResearchers.professors) {
      professor.collaborators = professor.collaboratorNames.map((name) => nameToResearcher[name]!).toList();
      professor.students = professor.studentNames?.map((name) => nameToResearcher[name]!).toList() ?? [];
    }

    return allResearchers;
  }

  Map<String, dynamic> toJson() => _$AllResearchersToJson(this);
}
