import 'package:flutter/material.dart';
import 'package:gallery/story_scaffold.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

class FadingDotLoaderStory extends StatelessWidget {
  const FadingDotLoaderStory({super.key});

  @override
  Widget build(BuildContext context) {
    return StoryScaffold(
      title: 'Fading Dot Loader',
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Animation I was going for (3 controllers)'),
            FadingDotLoader(),
            SizedBox(height: TopDashSpacing.xxxlg),
            Text('Animation with 1 controller and intervals'),
            FadingDotLoaderV2(),
          ],
        ),
      ),
    );
  }
}
