import 'package:flutter/material.dart';
import 'package:gallery/story_scaffold.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

class AnimatedCardStory extends StatelessWidget {
  const AnimatedCardStory({super.key, required this.controller});

  final AnimatedCardController controller;

  @override
  Widget build(BuildContext context) {
    return StoryScaffold(
      backgroundColor: Colors.black,
      title: 'Animated Card',
      body: Center(
        child: AnimatedCard(
          controller: controller,
          front: const GameCard(
            image:
                'https://firebasestorage.googleapis.com/v0/b/top-dash-dev.appspot.com/o/public%2FDash_pirate_trumpets_field.png?alt=media',
            name: 'Dash the Great',
            description: 'The best Dash in all the Dashland',
            suitName: 'earth',
            power: 57,
            size: GameCardSize.md(),
          ),
          back: const FlippedGameCard(),
        ),
      ),
    );
  }
}
