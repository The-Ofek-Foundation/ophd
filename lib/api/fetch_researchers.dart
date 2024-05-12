import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ophd/models/researcher.dart';

const fetchResearchersUrl = "https://fetchallresearchers-bql574jsfq-uc.a.run.app";
const updateDatabaseUrl = "https://updatedatabase-bql574jsfq-uc.a.run.app";

Future<AllResearchers> fetchResearchers() async {
  try {
    final response = await http.get(Uri.parse(fetchResearchersUrl));
    
    return AllResearchers.fromJson(jsonDecode(response.body));
  } catch (e) {
    print('Failed to fetch researchers');
    print('Error: $e');
    return AllResearchers(students: [], professors: []);
  }
}

Future<void> updateDatabase() async {
  await http.get(Uri.parse(updateDatabaseUrl));
}


