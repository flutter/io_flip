import 'package:flame/cache.dart';
import 'package:flame/extensions.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_dash/gen/assets.gen.dart';

class DeckPack extends StatelessWidget {
  const DeckPack({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final images = context.watch<Images>();
    const cardWidthFactor = 0.24;
    const cardHeightFactor = 0.25;
    const topPaddingFactor = 0.21;
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Padding(
                padding: EdgeInsets.only(
                  top: topPaddingFactor * constraints.maxHeight,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints.loose(
                    Size(
                      cardWidthFactor * constraints.maxWidth,
                      cardHeightFactor * constraints.maxHeight,
                    ),
                  ),
                  child: ClipRect(
                    child: child,
                  ),
                ),
              );
            },
          ),
        ),
        IgnorePointer(
          child: SizedBox.expand(
            child: SpriteAnimationWidget.asset(
              path: Assets.images.frontPack.keyName,
              images: images,
              anchor: Anchor.center,
              // onComplete: onComplete,
              data: SpriteAnimationData.sequenced(
                amount: 56,
                amountPerRow: 7,
                textureSize: Vector2(1050, 1219),
                stepTime: 0.04,
                loop: true,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
