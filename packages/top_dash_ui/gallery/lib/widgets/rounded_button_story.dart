import 'package:flutter/material.dart';
import 'package:gallery/story_scaffold.dart';
import 'package:io_flip_ui/top_dash_ui.dart';

class RoundedButtonStory extends StatelessWidget {
  const RoundedButtonStory({super.key});

  @override
  Widget build(BuildContext context) {
    return StoryScaffold(
      title: 'Rounded Button',
      body: Padding(
        padding: const EdgeInsets.all(TopDashSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: TopDashSpacing.lg),
            Wrap(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Icon button'),
                    RoundedButton.icon(
                      Icons.add_circle,
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(width: TopDashSpacing.lg),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Icon button (disabled)'),
                    RoundedButton.icon(
                      Icons.add_circle,
                    ),
                  ],
                ),
              ],
            ),
            const Divider(),
            Wrap(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Text button'),
                    RoundedButton.text(
                      'Text Button',
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(width: TopDashSpacing.lg),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Text Button (disabled)'),
                    RoundedButton.text(
                      'Text Button (disabled)',
                    ),
                  ],
                ),
              ],
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
