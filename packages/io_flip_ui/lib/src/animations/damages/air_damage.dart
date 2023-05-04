import 'package:io_flip_ui/gen/assets.gen.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

/// {@template air_damage}
// ignore: comment_references
/// A widget that renders several [SpriteAnimation]s for the damages
/// of a card on another.
/// {@endtemplate}
class AirDamage extends ElementalDamage {
  /// {@macro air_damage_small}
  AirDamage.small({required super.size})
      : super(
          chargeBackPath: Assets.images.elements.small.air.chargeBack.keyName,
          chargeFrontPath: Assets.images.elements.small.air.chargeFront.keyName,
          damageReceivePath:
              Assets.images.elements.small.air.damageReceive.keyName,
          damageSendPath: Assets.images.elements.small.air.damageSend.keyName,
          victoryChargeBackPath:
              Assets.images.elements.small.air.victoryChargeBack.keyName,
          victoryChargeFrontPath:
              Assets.images.elements.small.air.victoryChargeFront.keyName,
        );

  /// {@macro air_damage_large}
  AirDamage.large({required super.size})
      : super(
          chargeBackPath: Assets.images.elements.large.air.chargeBack.keyName,
          chargeFrontPath: Assets.images.elements.large.air.chargeFront.keyName,
          damageReceivePath:
              Assets.images.elements.large.air.damageReceive.keyName,
          damageSendPath: Assets.images.elements.large.air.damageSend.keyName,
          victoryChargeBackPath:
              Assets.images.elements.large.air.victoryChargeBack.keyName,
          victoryChargeFrontPath:
              Assets.images.elements.large.air.victoryChargeFront.keyName,
        );
}
