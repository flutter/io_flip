import 'package:flutter/material.dart';
import 'package:gallery/story_scaffold.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

class GameCardStory extends StatelessWidget {
  const GameCardStory({super.key});

  @override
  Widget build(BuildContext context) {
    return const StoryScaffold(
      title: 'Game Card',
      body: Center(
        child: GameCard(
          image:
              'https://firebasestorage.googleapis.com/v0/b/top-dash-dev.appspot.com/o/public%2Fdash_3.png?alt=media',
          name: 'Dash the Great',
          suitName: 'earth',
          power: 57,
          height: 300,
          width: 200,
        ),
      ),
    );
  }
}
