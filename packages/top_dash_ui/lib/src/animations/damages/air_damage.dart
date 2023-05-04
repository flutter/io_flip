import 'package:io_flip_ui/gen/assets.gen.dart';
import 'package:io_flip_ui/top_dash_ui.dart';

/// {@template air_damage}
// ignore: comment_references
/// A widget that renders several [SpriteAnimation]s for the damages
/// of a card on another.
/// {@endtemplate}
class AirDamage extends ElementalDamage {
  /// {@macro air_damage}
  AirDamage({required super.size})
      : super(
          chargeBackPath: Assets.images.elements.air.chargeBack.keyName,
          chargeFrontPath: Assets.images.elements.air.chargeFront.keyName,
          damageReceivePath: Assets.images.elements.air.damageReceive.keyName,
          damageSendPath: Assets.images.elements.air.damageSend.keyName,
          victoryChargeBackPath:
              Assets.images.elements.air.victoryChargeBack.keyName,
          victoryChargeFrontPath:
              Assets.images.elements.air.victoryChargeFront.keyName,
        );
}
