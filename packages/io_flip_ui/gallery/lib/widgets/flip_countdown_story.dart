import 'package:flame/cache.dart';
import 'package:flutter/material.dart';
import 'package:gallery/story_scaffold.dart';
import 'package:io_flip_ui/io_flip_ui.dart';
import 'package:provider/provider.dart';

class FlipCountdownStory extends StatefulWidget {
  const FlipCountdownStory({super.key});

  @override
  State<StatefulWidget> createState() => _FlipCountdownStoryState();
}

class _FlipCountdownStoryState extends State<FlipCountdownStory> {
  int _replayCounter = 0;

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => Images(prefix: ''),
      child: StoryScaffold(
        title: 'Flip Countdown',
        body: Center(
          child: Column(
            children: [
              FlipCountdown(
                key: ValueKey(_replayCounter),
              ),
              const SizedBox(height: IoFlipSpacing.lg),
              ElevatedButton(
                onPressed: () => setState(() {
                  _replayCounter++;
                }),
                child: const Text('Replay'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
