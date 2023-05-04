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
    this.size = const GameCardSize.xl(),
  })  : _chargeBackPath = chargeBackPath,
        _chargeFrontPath = chargeFrontPath,
        _damageReceivePath = damageReceivePath,
        _damageSendPath = damageSendPath,
        _victoryChargeFrontPath = victoryChargeBackPath,
        _victoryChargeBackPath = victoryChargeFrontPath;

  /// Size of the card.
  final GameCardSize size;

  /// String containing the [ChargeBack] animation path.
  final String _chargeBackPath;

  /// String containing the [ChargeFront] animation path.
  final String _chargeFrontPath;

  /// String containing the [DamageReceive] animation path.
  final String _damageReceivePath;

  /// String containing the [DamageSend] animation path.
  final String _damageSendPath;

  /// String containing the [VictoryChargeBack] animation path.
  final String _victoryChargeBackPath;

  /// String containing the [VictoryChargeFront] animation path.
  final String _victoryChargeFrontPath;

  /// Widget builder returning the [ChargeBack] animation.
  ChargeBack chargeBackBuilder(
    VoidCallback? onComplete,
    AssetSize assetSize,
  ) {
    return ChargeBack(
      _chargeBackPath,
      size: size,
      assetSize: assetSize,
      onComplete: onComplete,
    );
  }

  /// Widget builder returning the [ChargeFront] animation.
  ChargeFront chargeFrontBuilder(
    VoidCallback? onComplete,
    AssetSize assetSize,
  ) {
    return ChargeFront(
      _chargeFrontPath,
      size: size,
      assetSize: assetSize,
      onComplete: onComplete,
    );
  }

  /// Widget builder returning the [DamageReceive] animation.
  DamageReceive damageReceiveBuilder(
    VoidCallback? onComplete,
    AssetSize assetSize,
  ) {
    return DamageReceive(
      _damageReceivePath,
      size: size,
      assetSize: assetSize,
      onComplete: onComplete,
    );
  }

  /// Widget builder returning the [DamageSend] animation.
  DamageSend damageSendBuilder(
    VoidCallback? onComplete,
    AssetSize assetSize,
  ) {
    return DamageSend(
      _damageSendPath,
      size: size,
      assetSize: assetSize,
      onComplete: onComplete,
    );
  }

  /// Widget builder returning the [VictoryChargeBack] animation.
  VictoryChargeBack victoryChargeBackBuilder(
    VoidCallback? onComplete,
    AssetSize assetSize,
  ) {
    return VictoryChargeBack(
      _victoryChargeBackPath,
      size: size,
      assetSize: assetSize,
      onComplete: onComplete,
    );
  }

  /// Widget builder returning the [VictoryChargeFront] animation.
  VictoryChargeFront victoryChargeFrontBuilder(
    VoidCallback? onComplete,
    AssetSize assetSize,
  ) {
    return VictoryChargeFront(
      _victoryChargeFrontPath,
      size: size,
      assetSize: assetSize,
      onComplete: onComplete,
    );
  }
}
