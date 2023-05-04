import 'package:flutter/material.dart';
import 'package:gallery/story_scaffold.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

class AppSpacingStory extends StatelessWidget {
  const AppSpacingStory({super.key});

  @override
  Widget build(BuildContext context) {
    const spacingList = [
      _SpacingItem(spacing: IoFlipSpacing.xxxs, name: 'xxxs'),
      _SpacingItem(spacing: IoFlipSpacing.xxs, name: 'xxs'),
      _SpacingItem(spacing: IoFlipSpacing.xs, name: 'xs'),
      _SpacingItem(spacing: IoFlipSpacing.sm, name: 'sm'),
      _SpacingItem(spacing: IoFlipSpacing.md, name: 'md'),
      _SpacingItem(spacing: IoFlipSpacing.lg, name: 'lg'),
      _SpacingItem(spacing: IoFlipSpacing.xlgsm, name: 'xlgsm'),
      _SpacingItem(spacing: IoFlipSpacing.xlg, name: 'xlg'),
      _SpacingItem(spacing: IoFlipSpacing.xxlg, name: 'xxlg'),
      _SpacingItem(spacing: IoFlipSpacing.xxxlg, name: 'xxxlg'),
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
      padding: const EdgeInsets.all(IoFlipSpacing.sm),
      child: Row(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                color: IoFlipColors.seedBlack,
                width: IoFlipSpacing.xxs,
                height: IoFlipSpacing.lg,
              ),
              Container(
                width: spacing,
                height: IoFlipSpacing.lg,
                color: IoFlipColors.seedPaletteBlue70,
              ),
              Container(
                color: IoFlipColors.seedBlack,
                width: IoFlipSpacing.xxs,
                height: IoFlipSpacing.lg,
              ),
            ],
          ),
          const SizedBox(width: IoFlipSpacing.sm),
          Text('$name ($spacing)'),
        ],
      ),
    );
  }
}
