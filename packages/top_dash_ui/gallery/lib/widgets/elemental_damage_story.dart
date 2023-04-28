import 'package:flame/cache.dart';
import 'package:flutter/material.dart' hide Element;
import 'package:gallery/story_scaffold.dart';
import 'package:provider/provider.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

class ElementalDamageStory extends StatefulWidget {
  const ElementalDamageStory({super.key});

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
          child: SizedBox(
            width: 400,
            height: 500,
            child: Stack(
              clipBehavior: Clip.none,
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
                  ),
                ),
                Positioned(
                  bottom: -80,
                  right: -60,
                  left: -60,
                  top: -80,
                  child: ElementalDamageAnimation(
                    Element.metal,
                    direction: DamageDirection.topToBottom,
                    onComplete: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
