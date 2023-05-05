import 'package:flame/cache.dart';
import 'package:flutter/material.dart' hide Element;
import 'package:gallery/story_scaffold.dart';
import 'package:io_flip_ui/io_flip_ui.dart';
import 'package:provider/provider.dart';

class AllElementsStory extends StatefulWidget {
  const AllElementsStory({super.key});

  @override
  State<AllElementsStory> createState() => _AllElementsStoryState();
}

class _AllElementsStoryState extends State<AllElementsStory> {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => Images(prefix: ''),
      child: StoryScaffold(
        title: 'All Elements',
        body: Padding(
          padding: const EdgeInsets.all(IoFlipSpacing.xxxlg),
          child: Wrap(
            spacing: IoFlipSpacing.xxxlg,
            runSpacing: IoFlipSpacing.xxxlg,
            children: [
              for (final element in Element.values)
                _ElementalDamageGroup(
                  key: ValueKey(element),
                  element: element,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ElementalDamageGroup extends StatelessWidget {
  const _ElementalDamageGroup({
    super.key,
    required this.element,
  });

  final Element element;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 175,
      height: 300,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: GameCard(
              image:
                  'https://firebasestorage.googleapis.com/v0/b/top-dash-dev.appspot.com/o/public%2FDash_pirate_trumpets_field.png?alt=media',
              name: 'Dash the Great',
              description: 'The best Dash in all the Dashland',
              suitName: element.name,
              power: 57,
              size: const GameCardSize.xs(),
              isRare: false,
            ),
          ),
          const Positioned(
            bottom: 0,
            right: 0,
            child: GameCard(
              image:
                  'https://firebasestorage.googleapis.com/v0/b/top-dash-dev.appspot.com/o/public%2FDash_pirate_trumpets_field.png?alt=media',
              name: 'Dash the Great',
              description: 'The best Dash in all the Dashland',
              suitName: 'earth',
              power: 57,
              size: GameCardSize.xs(),
              isRare: false,
            ),
          ),
          Positioned(
            child: ElementalDamageAnimation(
              element,
              direction: DamageDirection.topToBottom,
              initialState: DamageAnimationState.charging,
              size: const GameCardSize.xs(),
              onComplete: () {},
            ),
          ),
        ],
      ),
    );
  }
}
