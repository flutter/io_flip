import 'package:flutter/material.dart';
import 'package:gallery/story_scaffold.dart';
import 'package:io_flip_ui/top_dash_ui.dart';

class FoilShaderStory extends StatefulWidget {
  const FoilShaderStory({super.key});

  @override
  State<FoilShaderStory> createState() => _FoilShaderStoryState();
}

class _FoilShaderStoryState extends State<FoilShaderStory> {
  Offset? mousePosition;

  @override
  Widget build(BuildContext context) {
    return StoryScaffold(
      title: 'Foil Shader',
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = Size.square(constraints.biggest.shortestSide * 0.5);
            final dx = ((mousePosition?.dx ?? 0) / size.width) * 2 - 1;
            final dy = ((mousePosition?.dy ?? 0) / size.height) * 2 - 1;
            return SizedBox.fromSize(
              size: size,
              child: MouseRegion(
                onHover: (event) {
                  setState(() {
                    mousePosition = event.localPosition;
                  });
                },
                child: FoilShader(
                  dx: dx,
                  dy: dy,
                  child: ColoredBox(
                    color: Colors.white,
                    child: Center(
                      child: IoFlipLogo(
                        width: size.width,
                        height: size.height,
                      ),
                    ),
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
