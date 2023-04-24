import 'package:flame/cache.dart';
import 'package:flame/extensions.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:top_dash/game/game.dart';
import 'package:top_dash/gen/assets.gen.dart';

class MatchResultSplash extends StatefulWidget {
  const MatchResultSplash({
    required this.child,
    required this.result,
    super.key,
  });

  final Widget child;
  final GameResult result;

  @override
  State<MatchResultSplash> createState() => _ResultSplashState();
}

class _ResultSplashState extends State<MatchResultSplash> {
  bool isSplashFinished = false;

  @override
  Widget build(BuildContext context) {
    final images = context.watch<Images>();
    final String resultImageKey;

    switch (widget.result) {
      case GameResult.win:
        resultImageKey = Assets.images.winSplash.keyName;
        break;
      case GameResult.lose:
        resultImageKey = Assets.images.lossSplash.keyName;
        break;
      case GameResult.draw:
        resultImageKey = Assets.images.drawSplash.keyName;
        break;
    }

    return isSplashFinished
        ? widget.child
        : SizedBox.expand(
            child: SpriteAnimationWidget.asset(
              path: resultImageKey,
              images: images,
              anchor: Anchor.center,
              onComplete: () {
                setState(() {
                  isSplashFinished = true;
                });
              },
              data: SpriteAnimationData.sequenced(
                amount: 28,
                amountPerRow: 4,
                textureSize: Vector2(1150, 750),
                stepTime: 0.04,
                loop: false,
              ),
            ),
          );
  }
}
