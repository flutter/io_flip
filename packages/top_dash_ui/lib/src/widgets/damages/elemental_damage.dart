import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

/// {@template elemental_damage}
/// A widget that renders several [SpriteAnimation]s for the damages
/// of a card on another.
/// {@endtemplate}
abstract class ElementalDamage {
  /// {@macro elemental_damage}
  ElementalDamage({
    required String chargeBackPath,
    required String chargeFrontPath,
    required String damageReceivePath,
    required String damageSendPath,
    required String victoryChargeBackPath,
    required String victoryChargeFrontPath,
    this.height = 500,
    this.width = 500,
    this.onComplete,
  })  : chargeBack = ChargeBack(chargeBackPath),
        chargeFront = ChargeFront(chargeFrontPath),
        damageReceive = DamageReceive(damageReceivePath),
        damageSend = DamageSend(damageSendPath),
        victoryChargeFront = VictoryChargeFront(victoryChargeBackPath),
        victoryChargeBack = VictoryChargeBack(victoryChargeFrontPath);

  /// The height of the widget.
  ///
  /// Defaults to `500`.
  final double height;

  /// The width of the widget.
  ///
  /// Defaults to `500`.
  final double width;

  /// Optional callback to be called when the animation is complete.
  final VoidCallback? onComplete;

  /// Widget containing the [ChargeBack] animation
  final ChargeBack chargeBack;

  /// Widget containing the [ChargeFront] animation
  final ChargeFront chargeFront;

  /// Widget containing the [DamageReceive] animation
  final DamageReceive damageReceive;

  /// Widget containing the [DamageSend] animation
  final DamageSend damageSend;

  /// Widget containing the [VictoryChargeBack] animation
  final VictoryChargeBack victoryChargeBack;

  /// Widget containing the [VictoryChargeFront] animation
  final VictoryChargeFront victoryChargeFront;
}
