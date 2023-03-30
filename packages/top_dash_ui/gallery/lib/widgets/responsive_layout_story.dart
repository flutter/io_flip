import 'package:flutter/material.dart';
import 'package:gallery/story_scaffold.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

class ResponsiveLayoutStory extends StatelessWidget {
  const ResponsiveLayoutStory({super.key});

  @override
  Widget build(BuildContext context) {
    return StoryScaffold(
      title: 'Responsive Layout',
      body: ResponsiveLayoutBuilder(
        small: (_, __) => const Center(
          child: Text(
            'Small Layout\nResize the window to see the large layout',
            style: TextStyle(color: TopDashColors.seedLightBlue),
            textAlign: TextAlign.center,
          ),
        ),
        large: (_, __) => const Center(
          child: Text(
            'Large Layout\nResize the window to see the small layout',
            style: TextStyle(color: TopDashColors.gold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
