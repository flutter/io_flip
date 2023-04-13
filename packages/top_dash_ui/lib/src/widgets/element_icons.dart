import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:top_dash_ui/gen/assets.gen.dart';

/// {@template element_icon}
/// IO Flip element icon.
/// {@endtemplate}
class ElementIcon extends StatelessWidget {
  /// [ElementIcon] for the air element.
  ElementIcon.air({
    super.key,
    this.scale = 1,
  }) : asset = Assets.images.elements.air;

  /// [ElementIcon] for the earth element.
  ElementIcon.earth({
    super.key,
    this.scale = 1,
  }) : asset = Assets.images.elements.earth;

  /// [ElementIcon] for the fire element.
  ElementIcon.fire({
    super.key,
    this.scale = 1,
  }) : asset = Assets.images.elements.fire;

  /// [ElementIcon] for the metal element.
  ElementIcon.metal({
    super.key,
    this.scale = 1,
  }) : asset = Assets.images.elements.metal;

  /// [ElementIcon] for the water element.
  ElementIcon.water({
    super.key,
    this.scale = 1,
  }) : asset = Assets.images.elements.water;

  /// Image icon for the element.
  final String asset;

  /// Scale factor to resize the image.
  final double scale;

// Original size of the image.
  static const _size = 96;

  /// Package name where the assets are located.
  static const package = 'top_dash_ui';

  /// Rendered size of the image
  double get size => scale * _size;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      asset,
      package: package,
      height: size,
      width: size,
    );
  }
}
