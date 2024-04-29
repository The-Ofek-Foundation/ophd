import 'package:flutter/material.dart';
import 'package:ophd/models/company.dart';

class Job {
  final Company company;
  final String team;
  final String location;
  final String dateRange;
  final List<String> keywords;
  final int hourlyRate; 
  final String description;
  final String? imagePath; 
  final List<Widget>? keyDetails; 

  Job({
    required this.team,
    required this.company,
    required this.location,
    required this.description,
    required this.dateRange,
    required this.keywords,
    this.imagePath,
    required this.hourlyRate,
    this.keyDetails,
  });
}
