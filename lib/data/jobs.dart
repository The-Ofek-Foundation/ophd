// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ophd/data/companies.dart';
import 'package:ophd/models/job.dart';
import 'package:ophd/utils/screen_utils.dart';

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
    imagePaths: [ 'assets/images/snowflake_intern.jpg', ]
  ),
  Job(
    company: Cloudera,
    team: 'Data Science Workbench',
    location: 'Palo Alto, CA',
    dateRange: 'Summer\n2021',
    keywords: ['bash', 'kubernetes', 'react', 'redux', 'go', 'grpc'],
    hourlyRate: 67,
    description: Cloudera2021Description,
    keyDetails: [
      const Chip(
        avatar: Icon(Icons.arrow_circle_up),
        label: Text('Automated Workspace Migration'),
      ),
    ],
  ),
  Job(
    company: Cloudera,
    team: 'Data Science Workbench',
    location: 'Palo Alto, CA',
    dateRange: 'Summer & Fall\n2020',
    keywords: ['fullstack', 'nodejs', 'react', 'redux', 'antd', 'typescript', 'jest', 'mocha'],
    hourlyRate: 60,
    description: Cloudera2020Description,
    keyDetails: [
      ActionChip(
        avatar: const Icon(FontAwesomeIcons.scroll),
        label: const Text('Patented!'),
        onPressed: () => launchURL('https://www.patentguru.com/inventor/gila-ofek'),
      ),
      ActionChip(
        avatar: const Icon(Icons.newspaper),
        label: const Text('Media Attention'),
        onPressed: () => launchURL('https://www.zdnet.com/article/cloudera-aims-to-fast-track-enterprise-machine-learning-use-cases-with-applied-ml-prototypes/'),
      ),
      ActionChip(
        avatar: const Icon(Icons.article),
        label: const Text('Publicly Documented'),
        onPressed: () => launchURL('https://docs.cloudera.com/machine-learning/cloud/applied-ml-prototypes/topics/ml-amp-project-spec.html'),
      ),
    ],
    imagePaths: [
      'assets/images/amp_catalog.png',
      'assets/images/amp_steps.png',
      'assets/images/amp_documentation.png',
      'assets/images/amp_patent.png',
    ]
  ),
];

const String Snowflake2022Description = '''
When I joined, Snowflake did not have any good automated process for dealing with data  corruption issues. Although data corruption certainly didn't occur often, when it did occur, it was usually due to a different team or individual who hadn't dealt with one before. Moreover, time is critical when dealing with corruption since backups are only kept for a limited time, and the corrupted data can propagate to other tables.

* I **automated the process** for dealing with these issues to quickly _determine the extent of damage_ (blast radius) as it propagates through tables, databases, and accounts.
* Then, I created **dashboards and tools** to _freeze the data_ and _track progress_ as issues are addressed.
* As far as I know, I am the **_only intern_** to create an entire _internal course_ on their project (Snow Academy).
* My tools are still in **active use** two years later.
''';

const String Cloudera2021Description = '''
This was my third internship at Cloudera, when there was a major product migration that needed to occur, and no automation at all to this process. The only real practical method was to create a new workspace and manually copy over all the applications, workflows, data, etc., and even then some details didn't transfer straight-forwardly.

* I create an **end-to-end** workspace migration upgrade flow.
* A majority of my work dealt with advanced _BASH_ scripts, dealing heavily with _postgres_ databases and _Kubernetes_ architectures.
* The UI work was done using _React_ and _Redux_ for the frontend, and _Go_ and _gRPC_ for the backend.
''';

const String Cloudera2020Description = '''
When I came back for my second internship at Cloudera, we had a slight problem—we had tons of exciting new features for our ML platform, but we didn't really have a good way to showcase them. While users could clone the data and then manually set up all the configuration, apps, tasks, visuals, etc., it was a very time-consuming and not really a very fun process. Furthermore, we realized that if we did have a good, interactive way to showcase these features, a very similar process may work to backup and restore workspaces!

* I designed a **robust and maintainable framework** which allows users the flexibility they need to define their own AMPs, still in use and [publicly documented] today. I designed all the specifications, API, framework, etc., as currently shown in the docs. Many of my easter eggs are still there, including my name, age at the time, aliases, and more!

* I built the entire backend for this project (using _NodeJS_ and _TypeScript_) in a way that gracefully handles errors, and designed with the future in mind.
    * This allows the automation of ~10 different machine learning workflow tasks, including creating and running jobs, creating/building/deploying models, running sessions, etc.

* I also built a vast majority of the frontend (using _React_, _Redux_, _Ant Design_, _Jest_, _Mocha_, etc.), including the entire AMP configuration flow, the entire interactive steps view, all the details shown in the main project page and settings, and also a vast majority of the AMP catalog page (including all the logic).

* I worked in a team of ~10 people, including managers, UX designers, ML practitioners, and product managers. I was the only one working on this project full-time.

* This feature went **public** and received **_[media attention]_**! Incidentally this means I can share much more with you :)

* I got a **[patent]** for this project! There you can see probably the most figures from my work, regrettably in grayscale.

* This was shown off during the company **earnings call**, and is needless to say still actively being used today, 3 years later. Now hugging face spaces [can be used directly as AMPS].

[media attention]: https://www.zdnet.com/article/cloudera-aims-to-fast-track-enterprise-machine-learning-use-cases-with-applied-ml-prototypes/

[publicly documented]: https://docs.cloudera.com/machine-learning/cloud/applied-ml-prototypes/topics/ml-amp-project-spec.html

[patent]: https://www.patentguru.com/inventor/gila-ofek

[can be used directly as AMPS]: https://community.cloudera.com/t5/Community-Articles/Hugging-Face-Spaces-AMPs-Accelerate-ML-Projects/ta-p/384685
''';
