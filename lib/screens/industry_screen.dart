import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:ophd/data/jobs.dart';
import 'package:ophd/models/job.dart';
import 'package:ophd/utils/screen_utils.dart';
import 'package:ophd/widgets/clickable_image.dart';
import 'package:ophd/widgets/collapsible_leading.dart';
import 'package:ophd/widgets/expandable_image.dart';
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
            for (Job job in jobs)
              JobCard(job: job),
          ],
        ),
      ),
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
    Widget body = MarkdownBody(
      data: job.description,
      selectable: true,
      onTapLink: (text, href, title) => launchURL(href!),
    );

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
              const TextSpan(text: "'s "),
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
        if (job.company.url != null)
          ClickableImage(
            image: AssetImage(job.company.logo),
            link: job.company.url!,
            tooltip: job.company.tooltip,
            width: 64,
          )
        else
          Tooltip(
            message: job.company.tooltip,
            child: Image(
              image: AssetImage(job.company.logo),
              width: 64,
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
