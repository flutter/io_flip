import 'package:flutter/widgets.dart';
import 'package:top_dash_ui/gen/assets.gen.dart';

/// {@template element_icon}
/// IO Flip element icon.
/// {@endtemplate}
class ElementIcon extends StatelessWidget {
  /// [ElementIcon] for the air element
  ElementIcon.air({
    super.key,
  }) : icon = Assets.images.elements.air.image(package: package);

  /// [ElementIcon] for the earth element

  ElementIcon.earth({
    super.key,
  }) : icon = Assets.images.elements.earth.image(package: package);

  /// [ElementIcon] for the fire element
  ElementIcon.fire({
    super.key,
  }) : icon = Assets.images.elements.fire.image(package: package);

  /// [ElementIcon] for the metal element
  ElementIcon.metal({
    super.key,
  }) : icon = Assets.images.elements.metal.image(package: package);

  /// [ElementIcon] for the water element
  ElementIcon.water({
    super.key,
  }) : icon = Assets.images.elements.water.image(package: package);

  /// Image icon for the element
  final Widget icon;

  static const package = 'top_dash_ui';

  @override
  Widget build(BuildContext context) {
    return icon;
  }
}
