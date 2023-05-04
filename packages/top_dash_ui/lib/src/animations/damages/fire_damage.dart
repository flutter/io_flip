import 'package:top_dash_ui/gen/assets.gen.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

/// {@template fire_damage}
// ignore: comment_references
/// A widget that renders several [SpriteAnimation]s for the damages
/// of a card on another.
/// {@endtemplate}
class FireDamage extends ElementalDamage {
  /// {@macro fire_damage_small}
  FireDamage.small({required super.size})
      : super(
          chargeBackPath: Assets.images.elements.small.fire.chargeBack.keyName,
          chargeFrontPath:
              Assets.images.elements.small.fire.chargeFront.keyName,
          damageReceivePath:
              Assets.images.elements.small.fire.damageReceive.keyName,
          damageSendPath: Assets.images.elements.small.fire.damageSend.keyName,
          victoryChargeBackPath:
              Assets.images.elements.small.fire.victoryChargeBack.keyName,
          victoryChargeFrontPath:
              Assets.images.elements.small.fire.victoryChargeFront.keyName,
        );

  /// {@macro fire_damage_large}
  FireDamage.large({required super.size})
      : super(
          chargeBackPath: Assets.images.elements.large.fire.chargeBack.keyName,
          chargeFrontPath:
              Assets.images.elements.large.fire.chargeFront.keyName,
          damageReceivePath:
              Assets.images.elements.large.fire.damageReceive.keyName,
          damageSendPath: Assets.images.elements.large.fire.damageSend.keyName,
          victoryChargeBackPath:
              Assets.images.elements.large.fire.victoryChargeBack.keyName,
          victoryChargeFrontPath:
              Assets.images.elements.large.fire.victoryChargeFront.keyName,
        );
}
