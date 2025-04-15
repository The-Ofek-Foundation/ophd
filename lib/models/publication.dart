import 'package:json_annotation/json_annotation.dart';
import 'package:ophd/models/researcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'publication.g.dart';

/// Converter for Firestore Timestamp
class TimestampConverter implements JsonConverter<Timestamp, Map<String, dynamic>> {
  const TimestampConverter();

  @override
  Timestamp fromJson(Map<String, dynamic> json) {
    return Timestamp(json['seconds'] as int, json['nanoseconds'] as int);
  }

  @override
  Map<String, dynamic> toJson(Timestamp timestamp) {
    return {
      'seconds': timestamp.seconds,
      'nanoseconds': timestamp.nanoseconds,
    };
  }
}

/// Enum representing the type of publication
@JsonEnum()
enum PublicationType {
  @JsonValue('article')
  article,
  @JsonValue('inproceedings')
  inproceedings,
  @JsonValue('proceedings')
  proceedings,
  @JsonValue('book')
  book,
  @JsonValue('incollection')
  incollection,
  @JsonValue('phdthesis')
  phdthesis,
  @JsonValue('unknown')
  unknown,
}

/// Represents author information stored within a Publication.
@JsonSerializable()
class PublicationAuthor {
  /// Raw name string from XML.
  @JsonKey(required: true)
  String name;

  /// DBLP PID, if available.
  String? pid;

  /// ORCID, if available.
  String? orcid;

  /// Reference to a researcher object (not serialized)
  @JsonKey(includeFromJson: false, includeToJson: false)
  Researcher? researcher;

  PublicationAuthor({
    required this.name,
    this.pid,
    this.orcid,
    this.researcher,
  });

  factory PublicationAuthor.fromJson(Map<String, dynamic> json) =>
      _$PublicationAuthorFromJson(json);

  Map<String, dynamic> toJson() => _$PublicationAuthorToJson(this);
}

/// Represents a publication entry from the database.
@JsonSerializable()
class Publication {
  /// DBLP key (unique identifier).
  @JsonKey(required: true)
  String dblpKey;

  /// Type of the publication.
  @JsonKey(required: true)
  PublicationType type;

  /// Modification date from DBLP.
  @JsonKey(required: true)
  @TimestampConverter()
  Timestamp mdate;

  /// Publication title.
  @JsonKey(required: true)
  String title;

  /// Publication year as a number.
  @JsonKey(required: true)
  int year;

  /// List of authors with their identifiers.
  @JsonKey(required: true)
  List<PublicationAuthor> authors;

  /// Optional electronic edition URLs.
  List<String>? ee;

  /// Optional DBLP URL.
  String? url;

  /// Optional journal name (for articles).
  String? journal;

  /// Optional volume identifier.
  String? volume;

  /// Optional issue number.
  String? number;

  /// Optional page numbers.
  String? pages;

  /// Optional book title (for conference/collection papers).
  String? booktitle;

  /// Optional cross-reference key.
  String? crossref;

  /// Optional publisher name.
  String? publisher;

  /// Optional ISBNs.
  List<String>? isbn;

  /// Optional series name.
  String? series;

  /// Optional school name (for thesis publications).
  String? school;

  /// Optional publication type attribute (e.g., "informal").
  String? publtype;

  /// Optional stream name.
  String? stream;

  /// Optional month.
  String? month;

  /// Names of researchers associated with this publication
  @JsonKey(name: 'researchers')
  List<String>? researcherNames;

  /// References to existing Researcher objects (not serialized)
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<Researcher>? researchers;

  Publication({
    required this.dblpKey,
    required this.type,
    required this.mdate,
    required this.title,
    required this.year,
    required this.authors,
    this.ee,
    this.url,
    this.journal,
    this.volume,
    this.number,
    this.pages,
    this.booktitle,
    this.crossref,
    this.publisher,
    this.isbn,
    this.series,
    this.school,
    this.publtype,
    this.stream,
    this.month,
    this.researcherNames,
    this.researchers,
  });

  factory Publication.fromJson(Map<String, dynamic> json) =>
      _$PublicationFromJson(json);

  Map<String, dynamic> toJson() => _$PublicationToJson(this);


}


