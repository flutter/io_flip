import 'package:flutter/widgets.dart';
import 'package:io_flip_ui/gen/assets.gen.dart';

/// {@template suit_icon}
/// IO Flip suit icon.
/// {@endtemplate}
class SuitIcon extends StatelessWidget {
  /// [SuitIcon] for the air element.
  SuitIcon.air({
    super.key,
    this.scale = 1,
  }) : asset = Assets.images.suits.onboarding.air;

  /// [SuitIcon] for the earth element.
  SuitIcon.earth({
    super.key,
    this.scale = 1,
  }) : asset = Assets.images.suits.onboarding.earth;

  /// [SuitIcon] for the fire element.
  SuitIcon.fire({
    super.key,
    this.scale = 1,
  }) : asset = Assets.images.suits.onboarding.fire;

  /// [SuitIcon] for the metal element.
  SuitIcon.metal({
    super.key,
    this.scale = 1,
  }) : asset = Assets.images.suits.onboarding.metal;

  /// [SuitIcon] for the water element.
  SuitIcon.water({
    super.key,
    this.scale = 1,
  }) : asset = Assets.images.suits.onboarding.water;

  /// Image icon for the element.
  final SvgGenImage asset;

  /// Scale factor to resize the image.
  final double scale;

// Original size of the image.
  static const _size = 96;

  /// Rendered size of the image
  double get size => scale * _size;

  @override
  Widget build(BuildContext context) {
    return asset.svg(
      height: size,
      width: size,
    );
  }
}
