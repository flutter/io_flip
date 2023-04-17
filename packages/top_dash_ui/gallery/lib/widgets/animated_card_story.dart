import 'package:flutter/material.dart';
import 'package:gallery/story_scaffold.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

class AnimatedCardStory extends StatelessWidget {
  const AnimatedCardStory({super.key, required this.controller});

  final AnimatedCardController controller;

  @override
  Widget build(BuildContext context) {
    const size = TopDashCardSizes.md;
    return StoryScaffold(
      title: 'Animated Card',
      body: Center(
        child: AnimatedCard(
          controller: controller,
          front: GameCard(
            image:
                'https://firebasestorage.googleapis.com/v0/b/top-dash-dev.appspot.com/o/public%2Fdash_3.png?alt=media',
            name: 'Dash the Great',
            suitName: 'earth',
            power: 57,
            width: size.width,
            height: size.height,
          ),
          back: FlippedGameCard(
            width: size.width,
            height: size.height,
          ),
        ),
      ),
    );
  }
}
