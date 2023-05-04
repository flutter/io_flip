import 'package:top_dash_ui/gen/assets.gen.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

/// {@template metal_damage}
// ignore: comment_references
/// A widget that renders several [SpriteAnimation]s for the damages
/// of a card on another.
/// {@endtemplate}
class MetalDamage extends ElementalDamage {
  /// {@macro metal_damage_small}
  MetalDamage.small({required super.size})
      : super(
          chargeBackPath: Assets.images.elements.small.metal.chargeBack.keyName,
          chargeFrontPath:
              Assets.images.elements.small.metal.chargeFront.keyName,
          damageReceivePath:
              Assets.images.elements.small.metal.damageReceive.keyName,
          damageSendPath: Assets.images.elements.small.metal.damageSend.keyName,
          victoryChargeBackPath:
              Assets.images.elements.small.metal.victoryChargeBack.keyName,
          victoryChargeFrontPath:
              Assets.images.elements.small.metal.victoryChargeFront.keyName,
        );

  /// {@macro metal_damage_large}
  MetalDamage.large({required super.size})
      : super(
          chargeBackPath: Assets.images.elements.large.metal.chargeBack.keyName,
          chargeFrontPath:
              Assets.images.elements.large.metal.chargeFront.keyName,
          damageReceivePath:
              Assets.images.elements.large.metal.damageReceive.keyName,
          damageSendPath: Assets.images.elements.large.metal.damageSend.keyName,
          victoryChargeBackPath:
              Assets.images.elements.large.metal.victoryChargeBack.keyName,
          victoryChargeFrontPath:
              Assets.images.elements.large.metal.victoryChargeFront.keyName,
        );
}
