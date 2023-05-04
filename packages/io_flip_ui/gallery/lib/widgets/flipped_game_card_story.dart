import 'package:flutter/material.dart';
import 'package:gallery/story_scaffold.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

class FlippedGameCardStory extends StatelessWidget {
  const FlippedGameCardStory({super.key});

  @override
  Widget build(BuildContext context) {
    return const StoryScaffold(
      title: 'Flipped Game Card',
      body: Center(
        child: FlippedGameCard(),
      ),
    );
  }
}
