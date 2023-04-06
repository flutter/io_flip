import 'package:flutter/material.dart';
import 'package:gallery/story_scaffold.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

class GameCardStory extends StatelessWidget {
  const GameCardStory({super.key});

  @override
  Widget build(BuildContext context) {
    const cardList = [
      _SmallGameCardItem(size: TopDashCardSizes.xs, name: 'xs'),
      _SmallGameCardItem(size: TopDashCardSizes.sm, name: 'sm'),
      _GameCardItem(size: TopDashCardSizes.md, name: 'md'),
      _GameCardItem(size: TopDashCardSizes.lg, name: 'lg'),
      _GameCardItem(size: TopDashCardSizes.xl, name: 'xl'),
      _GameCardItem(size: TopDashCardSizes.xxl, name: 'xxl'),
    ];

    return const StoryScaffold(
      title: 'Game Card',
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: cardList,
          ),
        ),
      ),
    );
  }
}

class _SmallGameCardItem extends StatelessWidget {
  const _SmallGameCardItem({required this.size, required this.name});

  final Size size;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(TopDashSpacing.lg),
      child: Row(
        children: [
          Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              color: TopDashColors.seedBlue,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: TopDashSpacing.md),
          Text('$name (${size.width} x ${size.height})'),
        ],
      ),
    );
  }
}

class _GameCardItem extends StatelessWidget {
  const _GameCardItem({required this.size, required this.name});

  final Size size;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(TopDashSpacing.lg),
      child: Row(
        children: [
          GameCard(
            image:
                'https://firebasestorage.googleapis.com/v0/b/top-dash-dev.appspot.com/o/public%2Fdash_3.png?alt=media',
            name: 'Dash the Great',
            suitName: 'earth',
            power: 57,
            width: size.width,
            height: size.height,
          ),
          const SizedBox(width: TopDashSpacing.md),
          Text('$name (${size.width} x ${size.height})'),
        ],
      ),
    );
  }
}
