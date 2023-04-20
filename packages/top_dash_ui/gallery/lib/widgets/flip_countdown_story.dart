import 'package:flame/cache.dart';
import 'package:flutter/material.dart';
import 'package:gallery/story_scaffold.dart';
import 'package:provider/provider.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

class FlipCountdownStory extends StatefulWidget {
  const FlipCountdownStory({super.key});

  @override
  State<StatefulWidget> createState() => _FlipCountdownStoryState();
}

class _FlipCountdownStoryState extends State<FlipCountdownStory> {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => Images(prefix: ''),
      child: StoryScaffold(
        title: 'Flip Countdown',
        body: Center(
          child: Column(
            children: [
              // ignore: prefer_const_constructors
              FlipCountdown(),
              const SizedBox(height: TopDashSpacing.lg),
              ElevatedButton(
                onPressed: () => setState(() {}),
                child: const Text('Replay'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
