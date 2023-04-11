import 'package:flutter/material.dart';
import 'package:gallery/story_scaffold.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

class AnimatedCardStory extends StatefulWidget {
  const AnimatedCardStory({super.key});

  @override
  State<AnimatedCardStory> createState() => _AnimatedCardStoryState();
}

class _AnimatedCardStoryState extends State<AnimatedCardStory> {
  final controller = AnimatedCardController();

  @override
  Widget build(BuildContext context) {
    const size = TopDashCardSizes.md;
    return StoryScaffold(
      title: 'Animated Card',
      body: Column(
        children: [
          Expanded(
            child: Center(
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
          ),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              ElevatedButton(
                onPressed: () => controller.run(smallFlipAnimation),
                child: const Text('Small Flip'),
              ),
              ElevatedButton(
                onPressed: () => controller.run(bigFlipAnimation),
                child: const Text('Big Flip'),
              ),
              ElevatedButton(
                onPressed: () => controller.run(jumpAnimation),
                child: const Text('Jump'),
              ),
              ElevatedButton(
                onPressed: () => controller.run(knockOutAnimation),
                child: const Text('Knock Out'),
              ),
              ElevatedButton(
                onPressed: () => controller
                    .run(smallFlipAnimation)
                    .then((_) => controller.run(jumpAnimation)),
                child: const Text('Flip and Jump'),
              ),
              ElevatedButton(
                onPressed: () => controller.run(attackAnimation),
                child: const Text('Attack'),
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
