import 'package:flutter/material.dart';
import 'package:gallery/story_scaffold.dart';
import 'package:io_flip_ui/top_dash_ui.dart';

class FadingDotLoaderStory extends StatelessWidget {
  const FadingDotLoaderStory({super.key});

  @override
  Widget build(BuildContext context) {
    return const StoryScaffold(
      title: 'Fading Dot Loader',
      body: Center(
        child: FadingDotLoader(),
      ),
    );
  }
}
