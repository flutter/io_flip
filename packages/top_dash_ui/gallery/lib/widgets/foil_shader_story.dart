import 'package:flutter/material.dart';
import 'package:gallery/story_scaffold.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

class FoilShaderStory extends StatefulWidget {
  const FoilShaderStory({super.key});

  @override
  State<FoilShaderStory> createState() => _FoilShaderStoryState();
}

class _FoilShaderStoryState extends State<FoilShaderStory> {
  Offset? mousePosition;

  @override
  Widget build(BuildContext context) {
    const size = TopDashCardSizes.md;
    return StoryScaffold(
      title: 'Foil Shader',
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              width: size.width,
              height: size.height,
              child: MouseRegion(
                onHover: (event) {
                  setState(() {
                    mousePosition = event.localPosition;
                  });
                },
                child: FoilShader(
                  dx: ((mousePosition?.dx ?? 0) / size.width) * 2 - 1,
                  dy: ((mousePosition?.dy ?? 0) / size.height) * 2 - 1,
                  child: GameCard(
                    image:
                        'https://firebasestorage.googleapis.com/v0/b/top-dash-dev.appspot.com/o/public%2Fdash_3.png?alt=media',
                    name: 'Dash the Great',
                    suitName: 'earth',
                    power: 57,
                    isRare: true,
                    width: size.width,
                    height: size.height,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
