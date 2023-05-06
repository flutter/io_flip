import 'package:flame/cache.dart';
import 'package:flutter/material.dart' hide Element;
import 'package:gallery/story_scaffold.dart';
import 'package:io_flip_ui/io_flip_ui.dart';
import 'package:provider/provider.dart';

class ElementalDamageStory extends StatefulWidget {
  const ElementalDamageStory(this.element, {super.key});

  final Element element;

  @override
  State<ElementalDamageStory> createState() => _ElementalDamageStoryState();
}

class _ElementalDamageStoryState extends State<ElementalDamageStory> {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => Images(prefix: ''),
      child: StoryScaffold(
        title: 'Elemental Damage Story',
        body: Center(
          child: Row(
            children: [
              SizedBox(
                width: 300,
                height: 500,
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
                        suitName: widget.element.name,
                        power: 57,
                        size: const GameCardSize.md(),
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
                        size: GameCardSize.md(),
                        isRare: false,
                      ),
                    ),
                    Positioned(
                      child: ElementalDamageAnimation(
                        widget.element,
                        direction: DamageDirection.topToBottom,
                        size: const GameCardSize.md(),
                        initialState: DamageAnimationState.charging,
                        assetSize: AssetSize.small,
                        onComplete: () {},
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 300,
                height: 500,
                child: Stack(
                  children: [
                    const Positioned(
                      top: 0,
                      left: 0,
                      child: GameCard(
                        image:
                            'https://firebasestorage.googleapis.com/v0/b/top-dash-dev.appspot.com/o/public%2FDash_pirate_trumpets_field.png?alt=media',
                        name: 'Dash the Great',
                        description: 'The best Dash in all the Dashland',
                        suitName: 'earth',
                        power: 57,
                        size: GameCardSize.md(),
                        isRare: false,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GameCard(
                        image:
                            'https://firebasestorage.googleapis.com/v0/b/top-dash-dev.appspot.com/o/public%2FDash_pirate_trumpets_field.png?alt=media',
                        name: 'Dash the Great',
                        description: 'The best Dash in all the Dashland',
                        suitName: widget.element.name,
                        power: 57,
                        size: const GameCardSize.md(),
                        isRare: false,
                      ),
                    ),
                    Positioned(
                      child: ElementalDamageAnimation(
                        widget.element,
                        direction: DamageDirection.bottomToTop,
                        size: const GameCardSize.md(),
                        initialState: DamageAnimationState.charging,
                        assetSize: AssetSize.small,
                        onComplete: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
