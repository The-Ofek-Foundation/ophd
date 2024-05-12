import 'package:flutter/material.dart';
import 'package:ophd/data/jobs.dart';
import 'package:ophd/data/social_links.dart';
import 'package:ophd/models/job.dart';
import 'package:ophd/models/social_link.dart';
import 'package:ophd/widgets/clickable_image.dart';
import 'package:ophd/widgets/clickable_markdown.dart';
import 'package:ophd/widgets/collapsible_leading.dart';
import 'package:ophd/widgets/expandable_image.dart';
import 'package:ophd/widgets/launchable_icon_button.dart';
import 'package:ophd/widgets/standard_card.dart';

class IndustryPage extends StatelessWidget {
  const IndustryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const JobOverviewCard(),
            for (Job job in jobs)
              JobCard(job: job),
          ],
        ),
      ),
    );
  }
}

class JobOverviewCard extends StatelessWidget {
  const JobOverviewCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String overview = '''
Despite my relatively young age, I've already had **${jobs.length} summer internships**, starting from when I was _only 15_ in high school! In fact, I've had an internship every summer except for the summer after my senior year of high school, when I went on a senior trip instead to Canada, and the summer of 2023, when I instead decided to focus on my research and spend some quality time with my girlfriend before we become long distance. I have received full-time **return offers** _every single summer_ I've interned (yes, including the first two internships where I was still in high school). I've worked in a variety of different companies, from early startups where I was _only the 8th_ employee, and large corporations with over 10,000. I've worked at companies in the recruitment space, to optical design companies, to cloud computing companies. And I've worked on everything from _full-stack web development_, where my project [went public], got media attention, and **[got patented]**, to low-level internal tools that **save millions of \$** annually!

Below I list out all my internships (with select internships highlighted), and I discuss each one casually from my perspective. If you are interested in a more formal overview, you can view the below links.

[went public]: https://docs.cloudera.com/machine-learning/cloud/applied-ml-prototypes/topics/ml-amp-project-spec.html
[got patented]: https://www.patentguru.com/inventor/gila-ofek
''';

    Wrap social = Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      runAlignment: WrapAlignment.center,
      children: [
        for (SocialLink social in socials.where((social) => social.types.contains(SocialType.industry)))
          LaunchableSocialButton(social: social),
      ]
    );

    return CardWrapper(
      child: Column(
        children: [
          ClickableMarkdown(data: overview, textAlign: WrapAlignment.center),
          social,
        ],
      )
    );
  }
}

class JobCard extends StatelessWidget {
  final Job job;

  const JobCard({Key? key, required this.job}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HighlightedCard(
      highlighted: job.isSelected,
      child: CardItself(
        child: Column(
          children: [
            CollapsibleLeading(
              initiallyExpanded: false,
              leading: JobLeading(job: job),
              header: JobHeader(job: job),
              footer: JobFooter(job: job),
              child: JobBody(job: job),
            ),
          ],
        ),
      ),
    );
  }
}

class JobFooter extends StatelessWidget {
  final Job job;

  const JobFooter({Key? key, required this.job}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      runAlignment: WrapAlignment.center,
      children: job.keyDetails,
    );
  }
}

class JobBody extends StatelessWidget {
  final Job job;
  final double width = 800;

  const JobBody({Key? key, required this.job}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget body = ClickableMarkdown(data: job.description);

    List<Widget> imagesAndSpacers = [];
    if (job.imagePaths != null) {
      for (int i = 0; i < job.imagePaths!.length; i++) {
        if (i > 0) imagesAndSpacers.add(const SizedBox(height: 16));
        imagesAndSpacers.add(ExpandableImage(
          imagePath: job.imagePaths![i],
        ));
      }
    }
    
    Widget? images = job.imagePaths != null ? Column(
      children: imagesAndSpacers,
    ) : null;

    return Padding(
      padding: const EdgeInsets.only(right: 8, bottom: 8),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
            children: [
              constraints.maxWidth > width || images == null ?
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: body,
                    ),
                    if (images != null)
                      const SizedBox(width: 16.0),
                    if (images != null)
                      Expanded(
                        flex: 2,
                        child: images,
                      ),
                  ],
                ) : Column(
                    children: [
                      body,
                      const SizedBox(height: 16.0),
                      images,
                    ],
                  ),
              const SizedBox(height: 8.0),
            ],
          );
        },
      ),
    );
  }
}

class JobHeader extends StatelessWidget {
  final Job job;

  const JobHeader({Key? key, required this.job}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> keywordsAndBullets = [];
    for (int i = 0; i < job.keywords.length; i++) {
      if (i > 0) keywordsAndBullets.add('⦁');
      keywordsAndBullets.add(job.keywords[i]);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SelectableText.rich(
          TextSpan(
            style: Theme.of(context).textTheme.bodyLarge,
            children: [
              TextSpan(
                text: job.company.name,
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
              if (job.team != null)
                TextSpan(text: job.company.name.endsWith('s') ? "' " : "'s "),
              if (job.team != null)
                TextSpan(text: '${job.team} Team'),
            ],
          ),
        ),
        SelectableText(job.location, style: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
        )),
        Wrap(
          spacing: 8,
          children: keywordsAndBullets.map((String keyword)  => Text(
            keyword,
            style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
              fontStyle: FontStyle.italic,
            ),
          )).toList(),
        ),
      ],
    );
  }
}

class JobLeading extends StatelessWidget {
  final Job job;

  const JobLeading({Key? key, required this.job}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: job.company.url != null ? ClickableImage(
            image: AssetImage(job.company.logo),
            link: job.company.url!,
            tooltip: job.company.tooltip,
            width: 64,
          ) : Tooltip(
            message: job.company.tooltip,
            child: Image(
              image: AssetImage(job.company.logo),
              width: 64,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SelectableText(
          job.dateRange,
          style: const TextStyle(fontStyle: FontStyle.italic),
          textAlign: TextAlign.center
        ),
      ],
    );
  }
}
