import 'package:flutter/material.dart';
import 'package:gallery/story_scaffold.dart';
import 'package:io_flip_ui/top_dash_ui.dart';

class TypographyStory extends StatelessWidget {
  const TypographyStory({super.key});

  @override
  Widget build(BuildContext context) {
    const textTheme = TopDashTextStyles.mobile;

    final textStyleList = [
      _TextItem(name: 'Display small', style: textTheme.displaySmall),
      _TextItem(name: 'Display medium', style: textTheme.displayMedium),
      _TextItem(name: 'Display large', style: textTheme.displayLarge),
      _TextItem(name: 'Headline small', style: textTheme.headlineSmall),
      _TextItem(name: 'Headline medium', style: textTheme.headlineMedium),
      _TextItem(name: 'Headline large', style: textTheme.headlineLarge),
      _TextItem(name: 'Title small', style: textTheme.titleSmall),
      _TextItem(name: 'Title medium', style: textTheme.titleMedium),
      _TextItem(name: 'Title large', style: textTheme.titleLarge),
      _TextItem(name: 'Body small', style: textTheme.bodySmall),
      _TextItem(name: 'Body medium', style: textTheme.bodyMedium),
      _TextItem(name: 'Body large', style: textTheme.bodyLarge),
      _TextItem(name: 'Label small', style: textTheme.labelSmall),
      _TextItem(name: 'Label medium', style: textTheme.labelMedium),
      _TextItem(name: 'Label large', style: textTheme.labelLarge),
    ];

    return StoryScaffold(
      title: 'Typography',
      body: ListView(shrinkWrap: true, children: textStyleList),
    );
  }
}

class _TextItem extends StatelessWidget {
  const _TextItem({required this.name, required this.style});

  final String name;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: TopDashSpacing.sm,
        vertical: TopDashSpacing.lg,
      ),
      child: Text(name, style: style),
    );
  }
}
