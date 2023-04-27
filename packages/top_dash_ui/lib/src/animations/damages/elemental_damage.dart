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
  })  : _chargeBackPath = chargeBackPath,
        _chargeFrontPath = chargeFrontPath,
        _damageReceivePath = damageReceivePath,
        _damageSendPath = damageSendPath,
        _victoryChargeFrontPath = victoryChargeBackPath,
        _victoryChargeBackPath = victoryChargeFrontPath;

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
  final String _chargeBackPath;

  /// Widget containing the [ChargeFront] animation
  final String _chargeFrontPath;

  /// Widget containing the [DamageReceive] animation
  final String _damageReceivePath;

  /// Widget containing the [DamageSend] animation
  final String _damageSendPath;

  /// Widget containing the [VictoryChargeBack] animation
  final String _victoryChargeBackPath;

  /// Widget containing the [VictoryChargeFront] animation
  final String _victoryChargeFrontPath;

  /// Widget containing the [ChargeBack] animation
  ChargeBack get chargeBack => ChargeBack(
        _chargeBackPath,
        width: width,
        height: height,
      );

  /// Widget containing the [ChargeFront] animation
  ChargeFront get chargeFront => ChargeFront(
        _chargeFrontPath,
        width: width,
        height: height,
      );

  /// Widget containing the [DamageReceive] animation
  DamageReceive get damageReceive => DamageReceive(
        _damageReceivePath,
        width: width,
        height: height,
      );

  /// Widget containing the [DamageSend] animation
  DamageSend get damageSend => DamageSend(
        _damageSendPath,
        width: width,
        height: height,
      );

  /// Widget containing the [VictoryChargeBack] animation
  VictoryChargeBack get victoryChargeBack => VictoryChargeBack(
        _victoryChargeBackPath,
        width: width,
        height: height,
      );

  /// Widget containing the [VictoryChargeFront] animation
  VictoryChargeFront get victoryChargeFront => VictoryChargeFront(
        _victoryChargeFrontPath,
        width: width,
        height: height,
      );
}
