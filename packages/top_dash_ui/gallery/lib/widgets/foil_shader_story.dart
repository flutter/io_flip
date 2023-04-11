import 'package:flutter/material.dart';
import 'package:gallery/story_scaffold.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

class FoilShaderStory extends StatelessWidget {
  const FoilShaderStory({super.key});

  @override
  Widget build(BuildContext context) {
    return StoryScaffold(
      title: 'Foil Shader',
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return FoilShader(
              child: SizedBox.square(
                dimension: constraints.biggest.shortestSide / 2,
                child: const ColoredBox(
                  color: Color(0xFFE0E0E0),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
