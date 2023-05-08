import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_flip/audio/audio_controller.dart';
import 'package:io_flip/gen/assets.gen.dart';
import 'package:io_flip/utils/utils.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

class DeckPack extends StatefulWidget {
  const DeckPack({
    required this.child,
    required this.onComplete,
    required this.size,
    super.key,
  });

  final Widget child;
  final Size size;
  final VoidCallback onComplete;

  @override
  State<DeckPack> createState() => DeckPackState();
}

@visibleForTesting
class DeckPackState extends State<DeckPack> {
  late final Images images;
  final asset = platformAwareAsset(
    desktop: Assets.images.desktop.frontPack.keyName,
    mobile: Assets.images.mobile.frontPack.keyName,
  );
  bool _underlayVisible = false;
  bool _isAnimationComplete = false;
  Widget? anim;

  @override
  void initState() {
    super.initState();
    images = context.read<Images>();
    setupAnimation();
  }

  @override
  void dispose() {
    images.clear(asset);
    super.dispose();
  }

  Future<void> setupAnimation() async {
    final data = SpriteAnimationData.sequenced(
      amount: 56,
      amountPerRow: platformAwareAsset(desktop: 7, mobile: 8),
      textureSize: platformAwareAsset(
        desktop: Vector2(1050, 1219),
        mobile: Vector2(750, 871),
      ),
      stepTime: 0.04,
      loop: false,
    );
    await SpriteAnimation.load(
      asset,
      data,
      images: images,
    ).then((animation) {
      if (!mounted) return;
      final ticker = animation.ticker()
        ..onFrame = onFrame
        ..completed.then((_) => onComplete());
      setState(() {
        anim = SpriteAnimationWidget(
          animation: animation,
          animationTicker: ticker,
        );
      });
    });
  }

  void onFrame(int currentFrame) {
    if (currentFrame == 29) {
      setState(() {
        _underlayVisible = true;
      });
      context.read<AudioController>().playSfx(Assets.sfx.deckOpen);
    }
  }

  void onComplete() {
    widget.onComplete();
    setState(() {
      _isAnimationComplete = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (anim == null) return SizedBox.fromSize(size: widget.size);
    return SizedBox.fromSize(
      size: widget.size,
      child: Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            if (_isAnimationComplete)
              widget.child
            else
              AspectRatio(
                // Aspect ratio of card
                aspectRatio: widget.size.aspectRatio,
                child: Offstage(
                  offstage: !_underlayVisible,
                  child: StretchAnimation(
                    animating: _underlayVisible,
                    child: Center(child: widget.child),
                  ),
                ),
              ),
            LayoutBuilder(
              builder: (context, constraints) {
                // The shrink is here to "hide" the size of the deck pack
                // animation as we want the DeckPack to size to the card and
                // not the animation size.
                return SizedBox.shrink(
                  child: OverflowBox(
                    maxWidth: constraints.maxWidth / 0.272,
                    maxHeight: constraints.maxHeight / 0.344,
                    child: Transform.translate(
                      offset: Offset(0, constraints.maxHeight * 0.16),
                      child: Center(
                        child: AspectRatio(
                          // Aspect ratio of texture
                          aspectRatio: 1050 / 1219,
                          child: SizedBox.expand(child: anim),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
