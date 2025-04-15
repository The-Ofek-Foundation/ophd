// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'publication.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PublicationAuthor _$PublicationAuthorFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['name'],
  );
  return PublicationAuthor(
    name: json['name'] as String,
    pid: json['pid'] as String?,
    orcid: json['orcid'] as String?,
  );
}

Map<String, dynamic> _$PublicationAuthorToJson(PublicationAuthor instance) =>
    <String, dynamic>{
      'name': instance.name,
      'pid': instance.pid,
      'orcid': instance.orcid,
    };

Publication _$PublicationFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'dblpKey',
      'type',
      'mdate',
      'title',
      'year',
      'authors'
    ],
  );
  return Publication(
    dblpKey: json['dblpKey'] as String,
    type: $enumDecode(_$PublicationTypeEnumMap, json['type']),
    mdate: const TimestampConverter()
        .fromJson(json['mdate'] as Map<String, dynamic>),
    title: json['title'] as String,
    year: (json['year'] as num).toInt(),
    authors: (json['authors'] as List<dynamic>)
        .map((e) => PublicationAuthor.fromJson(e as Map<String, dynamic>))
        .toList(),
    ee: (json['ee'] as List<dynamic>?)?.map((e) => e as String).toList(),
    url: json['url'] as String?,
    journal: json['journal'] as String?,
    volume: json['volume'] as String?,
    number: json['number'] as String?,
    pages: json['pages'] as String?,
    booktitle: json['booktitle'] as String?,
    crossref: json['crossref'] as String?,
    publisher: json['publisher'] as String?,
    isbn: (json['isbn'] as List<dynamic>?)?.map((e) => e as String).toList(),
    series: json['series'] as String?,
    school: json['school'] as String?,
    publtype: json['publtype'] as String?,
    stream: json['stream'] as String?,
    month: json['month'] as String?,
    researcherNames: (json['researchers'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
  );
}

Map<String, dynamic> _$PublicationToJson(Publication instance) =>
    <String, dynamic>{
      'dblpKey': instance.dblpKey,
      'type': _$PublicationTypeEnumMap[instance.type]!,
      'mdate': const TimestampConverter().toJson(instance.mdate),
      'title': instance.title,
      'year': instance.year,
      'authors': instance.authors,
      'ee': instance.ee,
      'url': instance.url,
      'journal': instance.journal,
      'volume': instance.volume,
      'number': instance.number,
      'pages': instance.pages,
      'booktitle': instance.booktitle,
      'crossref': instance.crossref,
      'publisher': instance.publisher,
      'isbn': instance.isbn,
      'series': instance.series,
      'school': instance.school,
      'publtype': instance.publtype,
      'stream': instance.stream,
      'month': instance.month,
      'researchers': instance.researcherNames,
    };

const _$PublicationTypeEnumMap = {
  PublicationType.article: 'article',
  PublicationType.inproceedings: 'inproceedings',
  PublicationType.proceedings: 'proceedings',
  PublicationType.book: 'book',
  PublicationType.incollection: 'incollection',
  PublicationType.phdthesis: 'phdthesis',
  PublicationType.unknown: 'unknown',
};
