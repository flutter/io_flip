import 'package:flame/cache.dart';
import 'package:flame/extensions.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:io_flip_ui/io_flip_ui.dart';
import 'package:provider/provider.dart';

/// {@template damage_send}
/// A widget that renders a [SpriteAnimation] for the damages sent.
/// {@endtemplate}
class DamageSend extends StatelessWidget {
  /// {@macro damage_send}
  const DamageSend(
    this.path, {
    required this.size,
    required this.assetSize,
    required this.badgePath,
    super.key,
    this.onComplete,
  });

  /// The size of the card.
  final GameCardSize size;

  /// Optional callback to be called when the animation is complete.
  final VoidCallback? onComplete;

  /// path of the asset containing the sprite sheet
  final String path;

  /// The badge path of the asset.
  final String badgePath;

  /// Size of the assets to use, large or small
  final AssetSize assetSize;

  @override
  Widget build(BuildContext context) {
    final images = context.read<Images>();
    final height = size.height;
    final width = size.width;

    if (assetSize == AssetSize.large) {
      return SizedBox(
        height: height,
        width: width,
        child: RotatedBox(
          quarterTurns: 2,
          child: SpriteAnimationWidget.asset(
            path: path,
            images: images,
            anchor: Anchor.center,
            onComplete: onComplete,
            data: SpriteAnimationData.sequenced(
              amount: 18,
              amountPerRow: 6,
              textureSize: Vector2(568, 683),
              stepTime: 0.04,
              loop: false,
            ),
          ),
        ),
      );
    } else {
      return _MobileAnimation(
        path: badgePath,
        onComplete: onComplete,
        size: size,
      );
    }
  }
}

class _MobileAnimation extends StatefulWidget {
  const _MobileAnimation({
    required this.path,
    required this.size,
    this.onComplete,
  });

  final String path;
  final VoidCallback? onComplete;
  final GameCardSize size;

  @override
  State<_MobileAnimation> createState() => _MobileAnimationState();
}

class _MobileAnimationState extends State<_MobileAnimation> {
  var _step = 0;
  late double _left = widget.size.width / 2 - 25;
  late double _top = widget.size.height / 2 - 25;

  @override
  void initState() {
    super.initState();

    Future<void>.delayed(
      const Duration(milliseconds: 100),
      _onComplete,
    );
  }

  void _onComplete() {
    if (_step == 0) {
      setState(() {
        _step = 1;
        _left = widget.size.width * 1.5 - 25;
        _top = widget.size.height * 1.5 - 25;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedPositioned(
          onEnd: widget.onComplete,
          curve: Curves.bounceOut,
          duration: const Duration(milliseconds: 500),
          left: _left,
          top: _top,
          width: 50,
          height: 50,
          child: SvgPicture.asset(
            widget.path,
          ),
        ),
      ],
    );
  }
}
