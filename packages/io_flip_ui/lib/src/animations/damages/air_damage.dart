import 'package:io_flip_ui/gen/assets.gen.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

/// {@template air_damage}
// ignore: comment_references
/// A widget that renders several [SpriteAnimation]s for the damages
/// of a card on another.
/// {@endtemplate}
class AirDamage extends ElementalDamage {
  /// {@macro air_damage}
  AirDamage({required super.size})
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
          badgePath: Assets.images.suits.card.air.keyName,
          animationColor: IoFlipColors.seedSilver,
        );
}
