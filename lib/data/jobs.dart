// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ophd/data/companies.dart';
import 'package:ophd/models/job.dart';
import 'package:ophd/utils/screen_utils.dart';

final List<Job> jobs = [
  Job(
    company: Cloudera,
    team: 'AI Inference',
    location: 'Santa Clara, CA',
    dateRange: 'Summer\n2024',
    keywords: ['go', 'kubernetes', 'application serving', 'docker'],
    hourlyRate: 75,
    description: Cloudera2024Description,
    keyDetails: [
      const Chip(
        avatar: Icon(Icons.rocket_launch),
        label: Text('3 Ways to Serve Models'),
      ),
      const Chip(
        avatar: Icon(Icons.webhook),
        label: Text('Streamlined Libraries'),
      ),
      const Chip(
        avatar: Icon(Icons.analytics),
        label: Text('User Behavior Tracking'),
      ),
    ],
  ),
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
        label: Text('Internal Course'),
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
    isSelected: true,
    imagePaths: [
      'assets/images/amp_catalog.png',
      'assets/images/amp_steps.png',
      'assets/images/amp_documentation.png',
      'assets/images/amp_patent.png',
    ]
  ),
  Job(
    company: Cloudera,
    team: 'Control Plane',
    location: 'Palo Alto, CA',
    dateRange: 'Summer\n2019',
    keywords: ['kubernetes', 'go', 'vault', 'terraform', 'helm'],
    hourlyRate: 55,
    description: Cloudera2019Description,
    keyDetails: [
      const Chip(
        avatar: Icon(Icons.attach_money),
        label: Text('Saving >\$2M Annually'),
      ),
      const Chip(
        avatar: Icon(Icons.people),
        label: Text('100+ Active Users'),
      ),
    ],
    isSelected: true,
  ),
  Job(
    company: SynopsysOpticalSolutions,
    team: 'Optical Solutions',
    location: 'Pasadena, CA',
    dateRange: 'Summer\n2018',
    keywords: ['c++', 'boost'],
    hourlyRate: 23,
    description: Synopsys2018Description,
    keyDetails: [
      const Chip(
        avatar: Icon(Icons.bolt),
        label: Text('95% Speedup'),
      ),
      const Chip(
        avatar: Icon(Icons.co_present),
        label: Text('Presented to Executives & Customers'),
      ),
      const Chip(
        avatar: Icon(Icons.bug_report),
        label: Text('100+ Tests'),
      ),
    ],
    imagePaths: [ 'assets/images/synopsys_team.jpg', ],
  ),
  Job(
    company: RecruiterAI,
    location: 'Palo Alto, CA',
    dateRange: 'Summer\n2016',
    keywords: ['fullstack', 'web development', 'django', 'backbone', 'mongodb', 'mixpanel', 'selenium', 'pytest'],
    hourlyRate: 18,
    description: RecruiterAI2016Description,
    keyDetails: [
      const Chip(
        avatar: Icon(Icons.settings_input_component),
        label: Text('Custom Components'),
      ),
      const Chip(
        avatar: Icon(Icons.chat),
        label: Text('Chatbot Implementation'),
      ),
      const Chip(
        avatar: Icon(Icons.analytics),
        label: Text('User Behavior Tracking'),
      ),
    ],
  ),
  Job(
    company: TrueSkills,
    location: 'Palo Alto, CA',
    dateRange: 'Summer\n2015',
    keywords: ['fullstack', 'web development', 'liquid'],
    hourlyRate: 15,
    description: TrueSkills2015Description,
    keyDetails: [
      const Chip(
        avatar: Icon(Icons.code),
        label: Text('Online IDE'),
      ),
      const Chip(
        avatar: Icon(Icons.save),
        label: Text('Persistent State'),
      ),
    ],
  ),
];

const Cloudera2024Description = '''
At this point I am apparently a perpetual 'intern' at Cloudera, rounding up my 4th summer 'internship' here. I put 'intern' in quotes since Cloudera did not have any US interns this year, and instead I was hired as a contractor. I was still under the same team, formerly known as the Data Science Workbench (CDSW) team, but now known as the AI Inference (AI Inf) team. The team had recently made a new product which was still in its very early stages, so I spent a reasonable amount of time defining best practices and major, major refactoring. I was able to simplify (and delete) tons of code, make the API much simpler, add usage reporting, fix lots of breaking bugs, help with our Jupyter plugin, and make parts of our Kubernetes cluster more vanilla. My main project which I worked on was the ability to serve _long-running_ applications.

* I **researched and defined** _best-in-class_ application serving strategies by analyzing top industry practices, culminating in a comprehensive design document guiding implementation.
* I **architected and implemented** _three distinct_ application serving methods (Git, object store, pre-built containers) to support diverse customer needs and deployment scenarios.
* I **enhanced application resilience** with features like _graceful recovery_, _dynamic autoscaling_ (including scale-to-zero), _versioning/rollback_, and _A/B testing with traffic splitting_, improving user experience and system reliability.
* I **unified and significantly simplified** the application and model serving codebase, _reducing complexity_ and _improving maintainability_.
* I **integrated comprehensive usage tracking**, providing valuable insights into application performance and user behavior.
* I **laid the foundation** for future scalability and security by designing for _precise application versioning_ and addressing key _security considerations_.
''';

const String Snowflake2022Description = '''
When I joined, Snowflake did not have any good automated process for dealing with data  corruption issues. Although data corruption certainly didn't occur often, when it did occur, it was usually due to a different team or individual who hadn't dealt with one before. Moreover, time is critical when dealing with corruption since backups are only kept for a limited time, and the corrupted data can propagate to other tables.

* I **automated the process** for dealing with these issues to quickly _determine the extent of damage_ (blast radius) as it propagates through tables, databases, and accounts.
* Then, I created **dashboards and tools** to _freeze the data_ and _track progress_ as issues are addressed.
* As far as I know, I am the **_only intern_** to create an entire _internal course_ on their project (Snow Academy).
* My tools are still in **active use** (as of two years later).
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

const String Cloudera2019Description = '''
This was my first internship at Cloudera, and the first time I worked in a large high-tech office. When I joined, Cloudera engineers, whenever they made even the most minute changes to the code, needed to spin up a new Kubernetes cluster just to test their changes. This was very expensive! The problem was that even if they made a change to only one service, since each service is interconnected to other services, spinning up a new cluster was the only way to ensure isolation.

* I worked with another employee to build an internal tool that allows developers to easily deploy their own mix of modified services into a Kubernetes environment. While developers in reality deployed services to a shared environment (**significantly minimizing costs**), they were given the _illusion of isolation_. This involved a lot of behind-the-scenes pipelining. The tool could do the following:
  * Differentiate Vault policies and Terraform modules per developer configuration
  * Apply relevant and customized secrets, service accounts, and other resources in a Kubernetes namespace
  * Allow developers to provide **customized services** and **automatically configure** them to depend on default, un-customized services when necessary
  * Annotate all Kubernetes resources in deployments to allow blame
  * With a single `update` command, efficiently handle all the resource, Vault, and Terraform customization when a developer modifies their environment
* I also used the Kubernetes Go API directly with concurrency when applicable for _major performance improvements_
* As of 2021, this tool was being used by **100+** weekly active developers, and saving Cloudera well over **\$2 million** annually. It was growing in usage, so these numbers are likely very conservative for now.

Unfortunately since this was an internal tool, I am very limited in what else I can share.
''';
const String Synopsys2018Description = '''
This was the first internship I held in college, with a relatively small and new branch of Synopsys in Pasadena. This team was formerly known as [Optical Research Associates] (ORA), and they developed [LightTools], a leading light illumination design software. It was an incredible experience working with them, and since many of them had been working together for 20/30+ years, I almost felt like I was joining their family.

One problem in the industry was that the top 3 leading softwares each stored their ray data in a different format, meaning that light companies would need to share their data in all 3 formats to be compatible with all clients. A new standard, [TM-25] (invented by many experts in the field including Groot, my coworker), was created to solve this issue, although it was so new that no software had implemented it yet.

- I extracted out file formatting logic to a new, standalone, API to be shared with other groups and released

- I added _3 new file formats_ to this shared API, and implemented very efficient parsing methods, with one format seeing a **95% speedup**. Needless to say this is much faster than open sourced libraries such as [this much more recent one]

- Designed to be both _backwards_ and _forwards_ compatible

- I presented new functionality directly to both Synopsys _executives_ and to **top customers**

- I added support for **3 previously unhandled forms** of ray file color data (the way that color for a set of rays is stored)

- I wrote extensive unit tests (**over 100**) and system tests using the Optical Research Associates Test System (ORATS) written in a proprietary language

- I added a feature that allows loading particular sections of the file independently, facilitating parallelism

- I wrote _extensive documentation_

All my programming here was done in C++

[Optical Research Associates]: https://news.synopsys.com/home?item=123203
[LightTools]: https://www.synopsys.com/optical-solutions/lighttools.html
[TM-25]: https://opg.optica.org/abstract.cfm?uri=Freeform-2013-FM1B.3#
[this much more recent one]: https://github.com/JuliusMuschaweck/TM25RaySetTools
''';

const String RecruiterAI2016Description = '''
This was between my junior and senior years of high school, when I decided to return to work at TrueSkills. By this point, they had changed their name to Recruiter.AI, and scrapped the entire code base I had worked on the past summer. Their vision (which in hindsight was a bit ahead of its time) was to create a platform where recruiters could find qualified candidates for specific roles by communicating with an AI chatbot.

* I made a single page app where every component was **custom-implemented** (including autocompletes, input fields, etc.)

* I contributed to the chatbot's implementation, both in the frontend and backend

* I designed _database schemas_ and I _optimized_ many of the _queries_

* I integrated with a third party (mixpanel) to measure user behavior and dropoffs

* I built both unit tests and UI tests for the above
''';

const String TrueSkills2015Description = '''
This was my first internship ever, right after I finished taking (and TA'ing) my school's AP Computer Science A course (between my sophomore and junior years of high school). I joined as the 8th employee of this small startup with a successful CEO (Amir Ashkenazi). Sadly this specific company ultimately failed, changing its name to Recruiter.AI and then shutting down (there may have been some other names as well). I am still very close to the CEO. The idea behind this startup was to use advanced online assessments that accurately mimic real-world programming scenarios to help recruiters filter candidates.

* I built a text editor up to an **online IDE** with a _working file system_

* I made the IDE state persistent (for example which tabs are open)

* I integrated with another tool to create an _adaptive joyride_ for new users
''';
