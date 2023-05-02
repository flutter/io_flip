import 'package:flame/cache.dart';
import 'package:flame/extensions.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:top_dash/game/game.dart';
import 'package:top_dash/gen/assets.gen.dart';
import 'package:top_dash/utils/utils.dart';

class MatchResultSplash extends StatefulWidget {
  const MatchResultSplash({
    required this.child,
    required this.result,
    super.key,
  });

  final Widget child;
  final GameResult result;

  @override
  State<MatchResultSplash> createState() => MatchResultSplashState();
}

@visibleForTesting
class MatchResultSplashState extends State<MatchResultSplash> {
  bool isSplashFinished = false;

  void onComplete() {
    setState(() {
      isSplashFinished = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final images = context.watch<Images>();
    final String resultImageKey;
    final textureSize = platformAwareAsset(
      desktop: Vector2(1150, 750),
      mobile: Vector2(575, 375),
    );

    switch (widget.result) {
      case GameResult.win:
        resultImageKey = platformAwareAsset(
          desktop: Assets.images.desktop.winSplash.keyName,
          mobile: Assets.images.mobile.winSplash.keyName,
        );
        break;
      case GameResult.lose:
        resultImageKey = platformAwareAsset(
          desktop: Assets.images.desktop.lossSplash.keyName,
          mobile: Assets.images.mobile.lossSplash.keyName,
        );
        break;
      case GameResult.draw:
        resultImageKey = platformAwareAsset(
          desktop: Assets.images.desktop.drawSplash.keyName,
          mobile: Assets.images.mobile.drawSplash.keyName,
        );
        break;
    }

    return isSplashFinished
        ? widget.child
        : SizedBox.expand(
            child: SpriteAnimationWidget.asset(
              path: resultImageKey,
              images: images,
              anchor: Anchor.center,
              onComplete: onComplete,
              data: SpriteAnimationData.sequenced(
                amount: 28,
                amountPerRow: 4,
                textureSize: textureSize,
                stepTime: 0.04,
                loop: false,
              ),
            ),
          );
  }
}
