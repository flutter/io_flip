import 'package:io_flip_ui/gen/assets.gen.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

/// {@template metal_damage}
// ignore: comment_references
/// A widget that renders several [SpriteAnimation]s for the damages
/// of a card on another.
/// {@endtemplate}
class MetalDamage extends ElementalDamage {
  /// {@macro metal_damage}
  MetalDamage({required super.size})
      : super(
          chargeBackPath:
              Assets.images.elements.desktop.metal.chargeBack.keyName,
          chargeFrontPath:
              Assets.images.elements.desktop.metal.chargeFront.keyName,
          damageReceivePath:
              Assets.images.elements.desktop.metal.damageReceive.keyName,
          damageSendPath:
              Assets.images.elements.desktop.metal.damageSend.keyName,
          victoryChargeBackPath:
              Assets.images.elements.desktop.metal.victoryChargeBack.keyName,
          victoryChargeFrontPath:
              Assets.images.elements.desktop.metal.victoryChargeFront.keyName,
          badgePath: Assets.images.suits.card.metal.keyName,
          animationColor: IoFlipColors.seedGreen,
        );
}
