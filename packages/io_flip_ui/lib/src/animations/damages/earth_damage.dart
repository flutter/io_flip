import 'package:io_flip_ui/gen/assets.gen.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

/// {@template earth_damage}
// ignore: comment_references
/// A widget that renders several [SpriteAnimation]s for the damages
/// of a card on another.
/// {@endtemplate}
class EarthDamage extends ElementalDamage {
  /// {@macro earth_damage}
  EarthDamage({required super.size})
      : super(
          chargeBackPath: Assets.images.elements.earth.chargeBack.keyName,
          chargeFrontPath: Assets.images.elements.earth.chargeFront.keyName,
          damageReceivePath: Assets.images.elements.earth.damageReceive.keyName,
          damageSendPath: Assets.images.elements.earth.damageSend.keyName,
          victoryChargeBackPath:
              Assets.images.elements.earth.victoryChargeBack.keyName,
          victoryChargeFrontPath:
              Assets.images.elements.earth.victoryChargeFront.keyName,
        );
}
