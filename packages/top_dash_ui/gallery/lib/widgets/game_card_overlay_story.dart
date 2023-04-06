import 'package:flutter/material.dart';
import 'package:gallery/story_scaffold.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

class GameCardOverlayStory extends StatelessWidget {
  const GameCardOverlayStory({super.key});

  @override
  Widget build(BuildContext context) {
    return const StoryScaffold(
      title: 'Game Card Overlay',
      body: Center(
        child: SingleChildScrollView(
          child: Wrap(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Win'),
                  GameCard(
                    image:
                        'https://firebasestorage.googleapis.com/v0/b/top-dash-dev.appspot.com/o/public%2Fdash_3.png?alt=media',
                    name: 'Dash the Great',
                    suitName: 'earth',
                    power: 57,
                    height: 300,
                    width: 200,
                    overlay: CardOverlayType.win,
                  ),
                ],
              ),
              SizedBox(width: TopDashSpacing.lg),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Draw'),
                  GameCard(
                    image:
                        'https://firebasestorage.googleapis.com/v0/b/top-dash-dev.appspot.com/o/public%2Fdash_3.png?alt=media',
                    name: 'Dash the Great',
                    suitName: 'earth',
                    power: 57,
                    height: 300,
                    width: 200,
                    overlay: CardOverlayType.draw,
                  ),
                ],
              ),
              SizedBox(width: TopDashSpacing.lg),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Lose'),
                  GameCard(
                    image:
                        'https://firebasestorage.googleapis.com/v0/b/top-dash-dev.appspot.com/o/public%2Fdash_3.png?alt=media',
                    name: 'Dash the Great',
                    suitName: 'earth',
                    power: 57,
                    height: 300,
                    width: 200,
                    overlay: CardOverlayType.lose,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
