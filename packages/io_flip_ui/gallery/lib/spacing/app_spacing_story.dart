import 'package:flutter/material.dart';
import 'package:gallery/story_scaffold.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

class AppSpacingStory extends StatelessWidget {
  const AppSpacingStory({super.key});

  @override
  Widget build(BuildContext context) {
    const spacingList = [
      _SpacingItem(spacing: TopDashSpacing.xxxs, name: 'xxxs'),
      _SpacingItem(spacing: TopDashSpacing.xxs, name: 'xxs'),
      _SpacingItem(spacing: TopDashSpacing.xs, name: 'xs'),
      _SpacingItem(spacing: TopDashSpacing.sm, name: 'sm'),
      _SpacingItem(spacing: TopDashSpacing.md, name: 'md'),
      _SpacingItem(spacing: TopDashSpacing.lg, name: 'lg'),
      _SpacingItem(spacing: TopDashSpacing.xlgsm, name: 'xlgsm'),
      _SpacingItem(spacing: TopDashSpacing.xlg, name: 'xlg'),
      _SpacingItem(spacing: TopDashSpacing.xxlg, name: 'xxlg'),
      _SpacingItem(spacing: TopDashSpacing.xxxlg, name: 'xxxlg'),
    ];

    return StoryScaffold(
      title: 'Spacing',
      body: ListView(
        shrinkWrap: true,
        children: spacingList,
      ),
    );
  }
}

class _SpacingItem extends StatelessWidget {
  const _SpacingItem({required this.spacing, required this.name});

  final double spacing;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(TopDashSpacing.sm),
      child: Row(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                color: TopDashColors.seedBlack,
                width: TopDashSpacing.xxs,
                height: TopDashSpacing.lg,
              ),
              Container(
                width: spacing,
                height: TopDashSpacing.lg,
                color: TopDashColors.seedPaletteBlue70,
              ),
              Container(
                color: TopDashColors.seedBlack,
                width: TopDashSpacing.xxs,
                height: TopDashSpacing.lg,
              ),
            ],
          ),
          const SizedBox(width: TopDashSpacing.sm),
          Text('$name ($spacing)'),
        ],
      ),
    );
  }
}
