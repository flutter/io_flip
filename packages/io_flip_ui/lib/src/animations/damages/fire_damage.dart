import 'package:io_flip_ui/gen/assets.gen.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

/// {@template fire_damage}
// ignore: comment_references
/// A widget that renders several [SpriteAnimation]s for the damages
/// of a card on another.
/// {@endtemplate}
class FireDamage extends ElementalDamage {
  /// {@macro fire_damage_small}
  FireDamage.small({required super.size})
      : super(
          chargeBackPath: Assets.images.elements.mobile.fire.chargeBack.keyName,
          chargeFrontPath:
              Assets.images.elements.mobile.fire.chargeFront.keyName,
          damageReceivePath:
              Assets.images.elements.mobile.fire.damageReceive.keyName,
          damageSendPath: Assets.images.elements.mobile.fire.damageSend.keyName,
          victoryChargeBackPath:
              Assets.images.elements.mobile.fire.victoryChargeBack.keyName,
          victoryChargeFrontPath:
              Assets.images.elements.mobile.fire.victoryChargeFront.keyName,
        );

  /// {@macro fire_damage_large}
  FireDamage.large({required super.size})
      : super(
          chargeBackPath:
              Assets.images.elements.desktop.fire.chargeBack.keyName,
          chargeFrontPath:
              Assets.images.elements.desktop.fire.chargeFront.keyName,
          damageReceivePath:
              Assets.images.elements.desktop.fire.damageReceive.keyName,
          damageSendPath:
              Assets.images.elements.desktop.fire.damageSend.keyName,
          victoryChargeBackPath:
              Assets.images.elements.desktop.fire.victoryChargeBack.keyName,
          victoryChargeFrontPath:
              Assets.images.elements.desktop.fire.victoryChargeFront.keyName,
        );
}
