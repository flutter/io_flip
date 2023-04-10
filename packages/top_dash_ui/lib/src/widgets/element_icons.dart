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
        width = 66.41,
        height = 57.87;

  /// [ElementIcon] for the earth element.

  ElementIcon.earth({
    super.key,
    this.scale = 1,
  })  : icon = Assets.images.elements.earth,
        width = 65.93,
        height = 64.62;

  /// [ElementIcon] for the fire element.
  ElementIcon.fire({
    super.key,
    this.scale = 1,
  })  : icon = Assets.images.elements.fire,
        width = 50.17,
        height = 80.95;

  /// [ElementIcon] for the metal element.
  ElementIcon.metal({
    super.key,
    this.scale = 1,
  })  : icon = Assets.images.elements.metal,
        width = 69.36,
        height = 68.44;

  /// [ElementIcon] for the water element.
  ElementIcon.water({
    super.key,
    this.scale = 1,
  })  : icon = Assets.images.elements.water,
        width = 58.24,
        height = 79.37;

  /// Image icon for the element.
  final String icon;

  /// Original width of the image.
  final double width;

  /// Original height of the image.
  final double height;

  /// Scale factor to resize the image.
  final double scale;

  /// Package name where the assets are located.
  static const package = 'top_dash_ui';

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      icon,
      package: package,
      height: scale * height,
      width: scale * width,
    );
  }
}
