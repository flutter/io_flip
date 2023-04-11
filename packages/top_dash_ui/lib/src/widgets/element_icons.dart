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
  })  : icon = Assets.images.elements.air,
        _width = 66.41,
        _height = 57.87;

  /// [ElementIcon] for the earth element.

  ElementIcon.earth({
    super.key,
    this.scale = 1,
  })  : icon = Assets.images.elements.earth,
        _width = 65.93,
        _height = 64.62;

  /// [ElementIcon] for the fire element.
  ElementIcon.fire({
    super.key,
    this.scale = 1,
  })  : icon = Assets.images.elements.fire,
        _width = 50.17,
        _height = 80.95;

  /// [ElementIcon] for the metal element.
  ElementIcon.metal({
    super.key,
    this.scale = 1,
  })  : icon = Assets.images.elements.metal,
        _width = 69.36,
        _height = 68.44;

  /// [ElementIcon] for the water element.
  ElementIcon.water({
    super.key,
    this.scale = 1,
  })  : icon = Assets.images.elements.water,
        _width = 58.24,
        _height = 79.37;

  /// Image icon for the element.
  final String icon;

  /// Original width of the image.
  final double _width;

  /// Original height of the image.
  final double _height;

  /// Scale factor to resize the image.
  final double scale;

  /// Package name where the assets are located.
  static const package = 'top_dash_ui';

  /// Rendered height of the image
  double get height => scale * _height;

  /// Rendered width of the image
  double get width => scale * _width;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      icon,
      package: package,
      height: height,
      width: width,
    );
  }
}
