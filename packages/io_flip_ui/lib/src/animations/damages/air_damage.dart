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
          chargeBackPath: Assets.images.elements.mobile.air.chargeBack.keyName,
          chargeFrontPath:
              Assets.images.elements.mobile.air.chargeFront.keyName,
          damageReceivePath:
              Assets.images.elements.mobile.air.damageReceive.keyName,
          damageSendPath: Assets.images.elements.mobile.air.damageSend.keyName,
          victoryChargeBackPath:
              Assets.images.elements.mobile.air.victoryChargeBack.keyName,
          victoryChargeFrontPath:
              Assets.images.elements.mobile.air.victoryChargeFront.keyName,
        );

  /// {@macro air_damage_large}
  AirDamage.large({required super.size})
      : super(
          chargeBackPath: Assets.images.elements.desktop.air.chargeBack.keyName,
          chargeFrontPath:
              Assets.images.elements.desktop.air.chargeFront.keyName,
          damageReceivePath:
              Assets.images.elements.desktop.air.damageReceive.keyName,
          damageSendPath: Assets.images.elements.desktop.air.damageSend.keyName,
          victoryChargeBackPath:
              Assets.images.elements.desktop.air.victoryChargeBack.keyName,
          victoryChargeFrontPath:
              Assets.images.elements.desktop.air.victoryChargeFront.keyName,
        );
}
