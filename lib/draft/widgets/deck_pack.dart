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
    const topPaddingFactor = 0.03;
    const cardHeight = 400;
    const cardWidth = cardHeight * 2 * 0.73;
    const textureHeight = cardHeight * 2;
    return _AnimatedDeck(
      child: Container(),
    );

    return Stack(
      children: [
        // Align(
        //   alignment: Alignment.topCenter,
        //   child: LayoutBuilder(
        //     builder: (context, constraints) {
        //       return Padding(
        //         padding: EdgeInsets.only(
        //           top: topPaddingFactor * textureHeight,
        //         ),
        //         child: ConstrainedBox(
        //           constraints: BoxConstraints.loose(
        //             Size(
        //               cardWidthFactor * cardWidth,
        //               cardHeightFactor * textureHeight,
        //             ),
        //           ),
        //           child: ClipRect(
        //             child: SizedBox.expand(
        //               child: ColoredBox(
        //                 color: Colors.red,
        //               ),
        //             ),
        //           ),
        //         ),
        //       );
        //     },
        //   ),
        // ),
        // Positioned.fill(
        //   child: OverflowBox(
        //     maxHeight: 845,
        //     maxWidth: 400,
        //     child: SizedBox.expand(
        //       child: SpriteAnimationWidget.asset(
        //         path: Assets.images.frontPack.keyName,
        //         images: images,
        //         anchor: Anchor.center,
        //         // onComplete: onComplete,
        //         data: SpriteAnimationData.sequenced(
        //           amount: 56,
        //           amountPerRow: 7,
        //           textureSize: Vector2(1050, 1219),
        //           stepTime: 0.04,
        //           loop: true,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        Container(
          alignment: Alignment.topCenter,
          child: _AnimatedDeck(
            child: Container(),
          ),
        )
      ],
    );
  }
}

class _AnimatedDeck extends StatelessWidget {
  const _AnimatedDeck({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final images = context.watch<Images>();
    const aspectRatio = 0.75;
    const height = 1200.0;
    const cardHeight = 380;
    const cardWidth = 268;
    const left = 391;
    const right = 659;
    const top = 53;
    const bottom = 428;

    const leftFactor = 0.38;
    // const rightFactor = 0.627;
    const topFactor = .11;
    const bottomFactor = 0.38;

    return ClipRect(
      clipBehavior: Clip.none,
      child: SizedBox(
        height: height * 0.41,
        width: height * aspectRatio,
        child: OverflowBox(
          alignment: Alignment.topCenter,
          maxHeight: height,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Positioned(
                    left: leftFactor * constraints.maxWidth,
                    right: leftFactor * constraints.maxWidth,
                    top: topFactor * constraints.maxHeight,
                    bottom: constraints.maxHeight -
                        (bottomFactor * constraints.maxHeight),
                    child: SizedBox.expand(
                      child: ColoredBox(
                        color: Colors.red,
                      ),
                    ),
                  ),
                  SizedBox.expand(
                    child: SpriteAnimationWidget.asset(
                      path: Assets.images.frontPack.keyName,
                      images: images,
                      anchor: Anchor.topCenter,
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
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
