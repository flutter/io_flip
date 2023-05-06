import 'package:flame/cache.dart';
import 'package:flame/extensions.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:io_flip/game/game.dart';
import 'package:io_flip/gen/assets.gen.dart';
import 'package:io_flip/utils/utils.dart';
import 'package:io_flip_ui/io_flip_ui.dart';
import 'package:provider/provider.dart';

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
    final isMobile = MediaQuery.sizeOf(context).width < IoFlipBreakpoints.small;
    final width = isMobile ? 314.0 : 471.0;

    return isSplashFinished
        ? widget.child
        : Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: width),
              child: SizedBox.expand(
                child: isMobile
                    ? _MobileMatchResultSplash(
                        result: widget.result,
                        onComplete: onComplete,
                      )
                    : _DesktopMatchResultSplash(
                        result: widget.result,
                        onComplete: onComplete,
                      ),
              ),
            ),
          );
  }
}

class _MobileMatchResultSplash extends StatelessWidget {
  const _MobileMatchResultSplash({
    required this.result,
    required this.onComplete,
  });

  final GameResult result;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    final Widget child;

    switch (result) {
      case GameResult.win:
        child = Assets.images.mobile.win.svg(
          key: const Key('matchResultSplash_win_mobile'),
        );
        break;
      case GameResult.lose:
        child = Assets.images.mobile.loss.svg(
          key: const Key('matchResultSplash_loss_mobile'),
        );
        break;
      case GameResult.draw:
        child = Assets.images.mobile.draw.svg(
          key: const Key('matchResultSplash_draw_mobile'),
        );
        break;
    }

    return StretchAnimation(
      animating: true,
      onComplete: onComplete,
      child: child,
    );
  }
}

class _DesktopMatchResultSplash extends StatelessWidget {
  const _DesktopMatchResultSplash({
    required this.result,
    required this.onComplete,
  });

  final GameResult result;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    final images = context.watch<Images>();
    final String resultImageKey;
    final textureSize = platformAwareAsset(
      desktop: Vector2(1150, 750),
      mobile: Vector2(575, 375),
    );

    switch (result) {
      case GameResult.win:
        resultImageKey = Assets.images.desktop.winSplash.keyName;
        break;
      case GameResult.lose:
        resultImageKey = Assets.images.desktop.lossSplash.keyName;
        break;
      case GameResult.draw:
        resultImageKey = Assets.images.desktop.drawSplash.keyName;
        break;
    }

    return SpriteAnimationWidget.asset(
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
    );
  }
}
