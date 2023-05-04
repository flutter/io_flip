import 'package:flutter/material.dart';
import 'package:gallery/story_scaffold.dart';
import 'package:io_flip_ui/top_dash_ui.dart';

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

class _GameCardItem extends StatefulWidget {
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
  State<_GameCardItem> createState() => _GameCardItemState();
}

class _GameCardItemState extends State<_GameCardItem> {
  late Offset mousePosition = Offset(
    widget.size.width / 2,
    widget.size.height / 2,
  );

  @override
  Widget build(BuildContext context) {
    final dx = (mousePosition.dx / widget.size.width) * 2 - 1;
    final dy = (mousePosition.dy / widget.size.height) * 2 - 1;
    return Padding(
      padding: const EdgeInsets.all(TopDashSpacing.lg),
      child: Row(
        children: [
          MouseRegion(
            onHover: (event) {
              setState(() {
                mousePosition = event.localPosition;
              });
            },
            child: GameCard(
              tilt: Offset(dx, dy),
              image:
                  'https://firebasestorage.googleapis.com/v0/b/top-dash-dev.appspot.com/o/public%2Fdash_3.png?alt=media',
              name: widget.cardName,
              description: widget.cardDescription,
              suitName: 'earth',
              power: 57,
              size: widget.size,
              isRare: widget.isRare,
            ),
          ),
          const SizedBox(width: TopDashSpacing.md),
          Text('${widget.name} (${widget.size.width} x ${widget.size.height})'),
        ],
      ),
    );
  }
}
