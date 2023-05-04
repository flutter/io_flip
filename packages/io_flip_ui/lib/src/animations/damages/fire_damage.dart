import 'package:io_flip_ui/gen/assets.gen.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

/// {@template fire_damage}
// ignore: comment_references
/// A widget that renders several [SpriteAnimation]s for the damages
/// of a card on another.
/// {@endtemplate}
class FireDamage extends ElementalDamage {
  /// {@macro fire_damage}
  FireDamage({required super.size})
      : super(
          chargeBackPath: Assets.images.elements.fire.chargeBack.keyName,
          chargeFrontPath: Assets.images.elements.fire.chargeFront.keyName,
          damageReceivePath: Assets.images.elements.fire.damageReceive.keyName,
          damageSendPath: Assets.images.elements.fire.damageSend.keyName,
          victoryChargeBackPath:
              Assets.images.elements.fire.victoryChargeBack.keyName,
          victoryChargeFrontPath:
              Assets.images.elements.fire.victoryChargeFront.keyName,
        );
}
