// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:ophd/data/companies.dart';
import 'package:ophd/models/job.dart';

final List<Job> jobs = [
  Job(
    company: Snowflake,
    team: 'SQL Frameworks',
    location: 'San Mateo, CA',
    dateRange: 'Summer\n2022',
    keywords: ['sql', 'data corruption'],
    hourlyRate: 75,
    description: Snowflake2022Description,
    keyDetails: [
      const Chip(
        avatar: Icon(Icons.school),
        label: Text('Created Internal Course'),
      ),
      const Chip(
        avatar: Icon(Icons.dashboard),
        label: Text('Automated Data Corruption Process'),
      ),
    ],
    imagePath: 'assets/images/snowflake_intern.jpg',
  )
];

const String Snowflake2022Description = '''
When I joined, Snowflake did not have any good automated process for dealing with data  corruption issues. Although data corruption certainly didn't occur often, when it did occur, it was usually due to a different team or individual who hadn't dealt with one before. Moreover, time is critical when dealing with corruption since backups are only kept for a limited time, and the corrupted data can propagate to other tables.

* I **automated the process** for dealing with these issues to quickly _determine the extent of damage_ as it propagates through tables, databases, and accounts.
* Then, I created **dashboards and tools** to _freeze the data_ and _track progress_ as issues are addressed.

* As far as I know, I am the **_only intern_** to create an entire _internal course_ on their project (Snow Academy)
''';
