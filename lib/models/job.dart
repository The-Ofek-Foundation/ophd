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
  final List<Widget> keyDetails;
  final bool isSelected;
  final List<String>? imagePaths; 

  Job({
    required this.team,
    required this.company,
    required this.location,
    required this.dateRange,
    required this.keywords,
    required this.hourlyRate,
    required this.description,
    required this.keyDetails,
    this.isSelected = false,
    this.imagePaths,
  });
}
