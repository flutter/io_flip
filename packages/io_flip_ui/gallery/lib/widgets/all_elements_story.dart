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
                  key: ValueKey(
                    DamageDirection.bottomToTop.name + element.name,
                  ),
                  direction: DamageDirection.bottomToTop,
                  element: element,
                ),
              for (final element in Element.values)
                _ElementalDamageGroup(
                  key: ValueKey(
                    DamageDirection.topToBottom.name + element.name,
                  ),
                  direction: DamageDirection.topToBottom,
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
    required this.direction,
  });

  final Element element;
  final DamageDirection direction;

  @override
  Widget build(BuildContext context) {
    final card1 = GameCard(
      image:
          'https://firebasestorage.googleapis.com/v0/b/top-dash-dev.appspot.com/o/public%2FDash_pirate_trumpets_field.png?alt=media',
      name: 'Dash the Great',
      description: 'The best Dash in all the Dashland',
      suitName: element.name,
      power: 57,
      size: const GameCardSize.xs(),
      isRare: false,
    );

    const card2 = GameCard(
      image:
          'https://firebasestorage.googleapis.com/v0/b/top-dash-dev.appspot.com/o/public%2FDash_pirate_trumpets_field.png?alt=media',
      name: 'Dash the Great',
      description: 'The best Dash in all the Dashland',
      suitName: 'earth',
      power: 57,
      size: GameCardSize.xs(),
      isRare: false,
    );
    return SizedBox(
      width: 175,
      height: 300,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: direction == DamageDirection.topToBottom ? card1 : card2,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: direction == DamageDirection.topToBottom ? card2 : card1,
          ),
          Positioned(
            child: ElementalDamageAnimation(
              element,
              direction: direction,
              initialState: DamageAnimationState.charging,
              size: const GameCardSize.xs(),
              assetSize: AssetSize.small,
              onComplete: () {},
            ),
          ),
        ],
      ),
    );
  }
}
