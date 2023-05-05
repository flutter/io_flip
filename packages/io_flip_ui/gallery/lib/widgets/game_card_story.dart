import 'package:flutter/material.dart';
import 'package:gallery/story_scaffold.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

class GameCardStory extends StatelessWidget {
  const GameCardStory({
    required this.name,
    required this.description,
    required this.isRare,
    super.key,
  });

  final String name;
  final String description;
  final bool isRare;

  @override
  Widget build(BuildContext context) {
    final cardList = [
      _GameCardItem(
        size: const GameCardSize.xxs(),
        name: 'xxs',
        cardName: name,
        cardDescription: description,
        isRare: isRare,
      ),
      _GameCardItem(
        size: const GameCardSize.xs(),
        name: 'xs',
        cardName: name,
        cardDescription: description,
        isRare: isRare,
      ),
      _GameCardItem(
        size: const GameCardSize.sm(),
        name: 'sm',
        cardName: name,
        cardDescription: description,
        isRare: isRare,
      ),
      _GameCardItem(
        size: const GameCardSize.md(),
        name: 'md',
        cardName: name,
        cardDescription: description,
        isRare: isRare,
      ),
      _GameCardItem(
        size: const GameCardSize.lg(),
        name: 'lg',
        cardName: name,
        cardDescription: description,
        isRare: isRare,
      ),
      _GameCardItem(
        size: const GameCardSize.xl(),
        name: 'xl',
        cardName: name,
        cardDescription: description,
        isRare: isRare,
      ),
      _GameCardItem(
        size: const GameCardSize.xxl(),
        name: 'xxl',
        cardName: name,
        cardDescription: description,
        isRare: isRare,
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

class _GameCardItem extends StatelessWidget {
  const _GameCardItem({
    required this.size,
    required this.name,
    required this.cardName,
    required this.cardDescription,
    required this.isRare,
  });

  final GameCardSize size;
  final String name;
  final String cardName;
  final String cardDescription;
  final bool isRare;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(IoFlipSpacing.lg),
      child: Row(
        children: [
          TiltBuilder(
            builder: (context, tilt) => GameCard(
              tilt: tilt,
              image:
                  'https://firebasestorage.googleapis.com/v0/b/top-dash-dev.appspot.com/o/public%2Fdash_3.png?alt=media',
              name: cardName,
              description: cardDescription,
              suitName: 'earth',
              power: 57,
              size: size,
              isRare: isRare,
            ),
          ),
          const SizedBox(width: IoFlipSpacing.md),
          Text('$name (${size.width} x ${size.height})'),
        ],
      ),
    );
  }
}
