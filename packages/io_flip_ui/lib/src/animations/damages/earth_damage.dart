import 'package:io_flip_ui/gen/assets.gen.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

/// {@template earth_damage}
// ignore: comment_references
/// A widget that renders several [SpriteAnimation]s for the damages
/// of a card on another.
/// {@endtemplate}
class EarthDamage extends ElementalDamage {
  /// {@macro earth_damage_small}
  EarthDamage.small({required super.size})
      : super(
          chargeBackPath: Assets.images.elements.small.earth.chargeBack.keyName,
          chargeFrontPath:
              Assets.images.elements.small.earth.chargeFront.keyName,
          damageReceivePath:
              Assets.images.elements.small.earth.damageReceive.keyName,
          damageSendPath: Assets.images.elements.small.earth.damageSend.keyName,
          victoryChargeBackPath:
              Assets.images.elements.small.earth.victoryChargeBack.keyName,
          victoryChargeFrontPath:
              Assets.images.elements.small.earth.victoryChargeFront.keyName,
        );

  /// {@macro earth_damage_large}
  EarthDamage.large({required super.size})
      : super(
          chargeBackPath: Assets.images.elements.large.earth.chargeBack.keyName,
          chargeFrontPath:
              Assets.images.elements.large.earth.chargeFront.keyName,
          damageReceivePath:
              Assets.images.elements.large.earth.damageReceive.keyName,
          damageSendPath: Assets.images.elements.large.earth.damageSend.keyName,
          victoryChargeBackPath:
              Assets.images.elements.large.earth.victoryChargeBack.keyName,
          victoryChargeFrontPath:
              Assets.images.elements.large.earth.victoryChargeFront.keyName,
        );
}
