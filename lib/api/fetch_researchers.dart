import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ophd/models/researcher.dart';

const fetchResearchersUrl = "https://fetchallresearchers-bql574jsfq-uc.a.run.app";
const updateDatabaseUrl = "https://updatedatabase-bql574jsfq-uc.a.run.app";

Future<AllResearchers> fetchResearchers() async {
  try {
    final response = await http.get(Uri.parse(fetchResearchersUrl));
    
    if (response.statusCode == 200) {
      return AllResearchers.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load researchers');
    }
  } catch (e) {
    return AllResearchers(students: [], professors: []);
  }
}

Future<void> updateDatabase() async {
  await http.get(Uri.parse(updateDatabaseUrl));
}


