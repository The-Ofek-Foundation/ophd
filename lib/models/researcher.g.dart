// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'researcher.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Researcher _$ResearcherFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['name', 'dblpPid'],
  );
  return Researcher(
    name: json['name'] as String,
    dblpPid: json['dblpPid'] as String,
    url: json['url'] as String?,
    collaboratorNames: (json['collaborators'] as List<dynamic>)
        .map((e) => e as String)
        .toList(),
    hasDoctorate: json['hasDoctorate'] as bool? ?? false,
  );
}

Map<String, dynamic> _$ResearcherToJson(Researcher instance) =>
    <String, dynamic>{
      'name': instance.name,
      'dblpPid': instance.dblpPid,
      'url': instance.url,
      'collaborators': instance.collaboratorNames,
      'hasDoctorate': instance.hasDoctorate,
    };

StudentResearcher _$StudentResearcherFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['name', 'dblpPid'],
  );
  return StudentResearcher(
    name: json['name'] as String,
    url: json['url'] as String?,
    dblpPid: json['dblpPid'] as String,
    collaboratorNames: (json['collaborators'] as List<dynamic>)
        .map((e) => e as String)
        .toList(),
    advisorNames:
        (json['advisors'] as List<dynamic>).map((e) => e as String).toList(),
    hasDoctorate: json['hasDoctorate'] as bool,
    year: (json['year'] as num?)?.toInt(),
    thesisTitle: json['thesisTitle'] as String?,
  );
}

Map<String, dynamic> _$StudentResearcherToJson(StudentResearcher instance) =>
    <String, dynamic>{
      'name': instance.name,
      'dblpPid': instance.dblpPid,
      'url': instance.url,
      'collaborators': instance.collaboratorNames,
      'hasDoctorate': instance.hasDoctorate,
      'advisors': instance.advisorNames,
      'year': instance.year,
      'thesisTitle': instance.thesisTitle,
    };

ProfessorResearcher _$ProfessorResearcherFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['name', 'dblpPid', 'title'],
  );
  return ProfessorResearcher(
    name: json['name'] as String,
    url: json['url'] as String?,
    dblpPid: json['dblpPid'] as String,
    collaboratorNames: (json['collaborators'] as List<dynamic>)
        .map((e) => e as String)
        .toList(),
    studentNames:
        (json['students'] as List<dynamic>?)?.map((e) => e as String).toList(),
    title: json['title'] as String,
  );
}

Map<String, dynamic> _$ProfessorResearcherToJson(
        ProfessorResearcher instance) =>
    <String, dynamic>{
      'name': instance.name,
      'dblpPid': instance.dblpPid,
      'url': instance.url,
      'collaborators': instance.collaboratorNames,
      'students': instance.studentNames,
      'title': instance.title,
    };

AllResearchers _$AllResearchersFromJson(Map<String, dynamic> json) =>
    AllResearchers(
      students: (json['students'] as List<dynamic>)
          .map((e) => StudentResearcher.fromJson(e as Map<String, dynamic>))
          .toList(),
      professors: (json['professors'] as List<dynamic>)
          .map((e) => ProfessorResearcher.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AllResearchersToJson(AllResearchers instance) =>
    <String, dynamic>{
      'students': instance.students,
      'professors': instance.professors,
    };
