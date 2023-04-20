import 'package:flutter/material.dart';
import 'package:gallery/story_scaffold.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

class BottomBarStory extends StatelessWidget {
  const BottomBarStory({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmall = screenWidth < TopDashBreakpoints.small;
    return StoryScaffold(
      title: 'Io Flip Bottom Bar',
      body: Column(
        children: [
          const Expanded(
            child: Center(
              child: Text(
                'Bottom bar\nResize to see its behavior on different '
                'screen sizes',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          IoFlipBottomBar(
            leading: RoundedButton.icon(Icons.volume_up),
            height: isSmall ? 120 : null,
            middle: Wrap(
              direction: isSmall ? Axis.vertical : Axis.horizontal,
              spacing: 8,
              children: [
                RoundedButton.text('PLAY NOW'),
                RoundedButton.text('PLAY NOW'),
              ],
            ),
            trailing: RoundedButton.icon(Icons.question_mark),
          ),
        ],
      ),
    );
  }
}