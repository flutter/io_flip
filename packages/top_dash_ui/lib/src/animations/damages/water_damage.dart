import 'package:top_dash_ui/gen/assets.gen.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

/// {@template water_damage}
// ignore: comment_references
/// A widget that renders several [SpriteAnimation]s for the damages
/// of a card on another.
/// {@endtemplate}
class WaterDamage extends ElementalDamage {
  /// {@macro water_damage}
  WaterDamage({required super.size})
      : super(
          chargeBackPath: Assets.images.elements.water.chargeBack.keyName,
          chargeFrontPath: Assets.images.elements.water.chargeFront.keyName,
          damageReceivePath: Assets.images.elements.water.damageReceive.keyName,
          damageSendPath: Assets.images.elements.water.damageSend.keyName,
          victoryChargeBackPath:
              Assets.images.elements.water.victoryChargeBack.keyName,
          victoryChargeFrontPath:
              Assets.images.elements.water.victoryChargeFront.keyName,
        );
}
