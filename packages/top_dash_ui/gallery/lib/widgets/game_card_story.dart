import 'package:flutter/material.dart';
import 'package:gallery/story_scaffold.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

class GameCardStory extends StatelessWidget {
  const GameCardStory({
    required this.name,
    required this.description,
    super.key,
  });

  final String name;
  final String description;

  @override
  Widget build(BuildContext context) {
    final cardList = [
      _GameCardItem(
        size: const GameCardSize.xxs(),
        name: 'xxs',
        cardName: name,
        cardDescription: description,
      ),
      _GameCardItem(
        size: const GameCardSize.xs(),
        name: 'xs',
        cardName: name,
        cardDescription: description,
      ),
      _GameCardItem(
        size: const GameCardSize.sm(),
        name: 'sm',
        cardName: name,
        cardDescription: description,
      ),
      _GameCardItem(
        size: const GameCardSize.md(),
        name: 'md',
        cardName: name,
        cardDescription: description,
      ),
      _GameCardItem(
        size: const GameCardSize.lg(),
        name: 'lg',
        cardName: name,
        cardDescription: description,
      ),
      _GameCardItem(
        size: const GameCardSize.xl(),
        name: 'xl',
        cardName: name,
        cardDescription: description,
      ),
      _GameCardItem(
        size: const GameCardSize.xxl(),
        name: 'xxl',
        cardName: name,
        cardDescription: description,
      ),
    ];

    return StoryScaffold(
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

  final GameCardSize size;
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
  const _GameCardItem({
    required this.size,
    required this.name,
    required this.cardName,
    required this.cardDescription,
  });

  final GameCardSize size;
  final String name;
  final String cardName;
  final String cardDescription;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(TopDashSpacing.lg),
      child: Row(
        children: [
          GameCard(
            image:
                'https://firebasestorage.googleapis.com/v0/b/top-dash-dev.appspot.com/o/public%2Fdash_3.png?alt=media',
            name: cardName,
            description: cardDescription,
            suitName: 'earth',
            power: 57,
            size: size,
          ),
          const SizedBox(width: TopDashSpacing.md),
          Text('$name (${size.width} x ${size.height})'),
        ],
      ),
    );
  }
}
