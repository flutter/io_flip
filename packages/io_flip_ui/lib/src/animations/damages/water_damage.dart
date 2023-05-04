import 'package:io_flip_ui/gen/assets.gen.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

/// {@template water_damage}
// ignore: comment_references
/// A widget that renders several [SpriteAnimation]s for the damages
/// of a card on another.
/// {@endtemplate}
class WaterDamage extends ElementalDamage {
  /// {@macro water_damage_small}
  WaterDamage.small({required super.size})
      : super(
          chargeBackPath: Assets.images.elements.small.water.chargeBack.keyName,
          chargeFrontPath:
              Assets.images.elements.small.water.chargeFront.keyName,
          damageReceivePath:
              Assets.images.elements.small.water.damageReceive.keyName,
          damageSendPath: Assets.images.elements.small.water.damageSend.keyName,
          victoryChargeBackPath:
              Assets.images.elements.small.water.victoryChargeBack.keyName,
          victoryChargeFrontPath:
              Assets.images.elements.small.water.victoryChargeFront.keyName,
        );

  /// {@macro water_damage_large}
  WaterDamage.large({required super.size})
      : super(
          chargeBackPath: Assets.images.elements.large.water.chargeBack.keyName,
          chargeFrontPath:
              Assets.images.elements.large.water.chargeFront.keyName,
          damageReceivePath:
              Assets.images.elements.large.water.damageReceive.keyName,
          damageSendPath: Assets.images.elements.large.water.damageSend.keyName,
          victoryChargeBackPath:
              Assets.images.elements.large.water.victoryChargeBack.keyName,
          victoryChargeFrontPath:
              Assets.images.elements.large.water.victoryChargeFront.keyName,
        );
}
