import 'package:flutter/material.dart';
import 'package:gallery/story_scaffold.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

class FlippedGameCardStory extends StatelessWidget {
  const FlippedGameCardStory({super.key});

  @override
  Widget build(BuildContext context) {
    return const StoryScaffold(
      title: 'Flipped Game Card',
      body: Center(
        child: FlippedGameCard(
          width: 200,
          height: 300,
        ),
      ),
    );
  }
}
