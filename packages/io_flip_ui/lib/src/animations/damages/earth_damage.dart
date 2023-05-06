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
          chargeBackPath:
              Assets.images.elements.desktop.earth.chargeBack.keyName,
          chargeFrontPath:
              Assets.images.elements.desktop.earth.chargeFront.keyName,
          damageReceivePath:
              Assets.images.elements.desktop.earth.damageReceive.keyName,
          damageSendPath:
              Assets.images.elements.desktop.earth.damageSend.keyName,
          victoryChargeBackPath:
              Assets.images.elements.desktop.earth.victoryChargeBack.keyName,
          victoryChargeFrontPath:
              Assets.images.elements.desktop.earth.victoryChargeFront.keyName,
          badgePath: Assets.images.suits.card.earth.keyName,
          animationColor: IoFlipColors.seedGreen,
        );
}
