import 'package:flame/cache.dart';
import 'package:flutter/material.dart';
import 'package:gallery/story_scaffold.dart';
import 'package:io_flip_ui/io_flip_ui.dart';
import 'package:provider/provider.dart';

class CardLandingPuffStory extends StatefulWidget {
  const CardLandingPuffStory({super.key});

  @override
  State<StatefulWidget> createState() => _CardLandingPuffStoryState();
}

class _CardLandingPuffStoryState extends State<CardLandingPuffStory> {
  AnimatedCardController controller = AnimatedCardController();
  bool playing = false;

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => Images(prefix: ''),
      child: StoryScaffold(
        title: 'Card landing puff',
        body: Center(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  CardLandingPuff(
                    playing: playing,
                    onComplete: () => setState(() => playing = false),
                  ),
                  AnimatedCard(
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
                    back: const FlippedGameCard(
                      size: GameCardSize.md(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: IoFlipSpacing.lg),
              ElevatedButton(
                onPressed: () {
                  controller.run(bigFlipAnimation);
                  Future.delayed(
                    bigFlipAnimation.duration * .85,
                    () => setState(() => playing = true),
                  );
                },
                child: const Text('Replay'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
