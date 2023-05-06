import 'dart:async';
import 'dart:math';

import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:io_flip_ui/io_flip_ui.dart';
import 'package:io_flip_ui/src/animations/damages/air_damage.dart';
import 'package:io_flip_ui/src/animations/damages/earth_damage.dart';
import 'package:io_flip_ui/src/animations/damages/fire_damage.dart';
import 'package:io_flip_ui/src/animations/damages/water_damage.dart';
import 'package:io_flip_ui/src/widgets/damages/dual_animation.dart';

/// {@template elemental_damage_step_notifier}
/// A notifier that allows an external
/// test to know when an [DamageAnimationState] is complete
/// {@endtemplate}
@visibleForTesting
class ElementalDamageStepNotifier {
  final _charged = Completer<void>();
  final _sent = Completer<void>();
  final _received = Completer<void>();
  final _victory = Completer<void>();

  /// Future notifying when [DamageAnimationState.charging] is complete
  Future<void> get charged => _charged.future;

  /// Future notifying when [DamageAnimationState.sending] is complete
  Future<void> get sent => _sent.future;

  /// Future notifying when [DamageAnimationState.receiving] is complete
  Future<void> get received => _received.future;

  /// Future notifying when [DamageAnimationState.victory] is complete
  Future<void> get victory => _victory.future;
}

/// {@template elemental_damage_animation}
/// A widget that renders a list of [SpriteAnimation] for a given element
/// {@endtemplate}
class ElementalDamageAnimation extends StatefulWidget {
  /// {@macro elemental_damage_animation}
  const ElementalDamageAnimation(
    this.element, {
    required this.direction,
    required this.initialState,
    required this.size,
    this.assetSize = AssetSize.large,
    this.onComplete,
    this.onDamageReceived,
    this.pointDeductionCompleter,
    this.stepNotifier,
    super.key,
  });

  /// Optional callback to be called when all the animations of the damage
  /// are complete.
  final VoidCallback? onComplete;

  /// Optional callback to be called when the damage is received.
  final VoidCallback? onDamageReceived;

  /// Completer to be completed when the points have been deducted.
  final Completer<void>? pointDeductionCompleter;

  /// Element defining which [ElementalDamage] to use
  final Element element;

  /// Direction of the damages
  final DamageDirection direction;

  /// Size of the card
  final GameCardSize size;

  /// Notifies when an [DamageAnimationState] is complete
  final ElementalDamageStepNotifier? stepNotifier;

  /// Size of the assets to use, large or small
  final AssetSize assetSize;

  /// Initial state of the animation
  final DamageAnimationState initialState;

  @override
  State<ElementalDamageAnimation> createState() =>
      _ElementalDamageAnimationState();
}

class _ElementalDamageAnimationState extends State<ElementalDamageAnimation> {
  late var _animationState = widget.initialState;
  late final ElementalDamage elementalDamage;

  @override
  void initState() {
    super.initState();
    switch (widget.element) {
      case Element.metal:
        elementalDamage = MetalDamage(size: widget.size);
        break;
      case Element.air:
        elementalDamage = AirDamage(size: widget.size);
        break;
      case Element.fire:
        elementalDamage = FireDamage(size: widget.size);
        break;
      case Element.earth:
        elementalDamage = EarthDamage(size: widget.size);
        break;
      case Element.water:
        elementalDamage = WaterDamage(size: widget.size);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (_animationState) {
      case DamageAnimationState.charging:
        return Stack(
          children: [
            if (widget.direction == DamageDirection.topToBottom)
              Transform.translate(
                offset: -Offset(
                  0.32 * widget.size.width,
                  0.315 * widget.size.height,
                ),
                child: DualAnimation(
                  cardOffset: Offset(
                    0.32 * widget.size.width,
                    0.315 * widget.size.height,
                  ),
                  cardSize: widget.size,
                  back: elementalDamage.chargeBackBuilder,
                  front: elementalDamage.chargeFrontBuilder,
                  assetSize: widget.assetSize,
                  onComplete: _onStepCompleted,
                ),
              )
            else
              _BottomAnimation(
                child: Transform.translate(
                  offset: Offset(
                    0.32 * widget.size.width,
                    0.215 * widget.size.height,
                  ),
                  child: DualAnimation(
                    cardOffset: Offset(
                      0.32 * widget.size.width,
                      0.315 * widget.size.height,
                    ),
                    cardSize: widget.size,
                    back: elementalDamage.chargeBackBuilder,
                    front: elementalDamage.chargeFrontBuilder,
                    assetSize: widget.assetSize,
                    onComplete: _onStepCompleted,
                  ),
                ),
              )
          ],
        );
      case DamageAnimationState.sending:
        return Stack(
          children: [
            if (widget.direction == DamageDirection.topToBottom)
              Align(
                alignment: const Alignment(-0.7, 0.3),
                child: elementalDamage.damageSendBuilder(
                  _onStepCompleted,
                  widget.assetSize,
                ),
              )
            else
              Align(
                alignment: const Alignment(0.7, 0),
                child: Transform.rotate(
                  angle: pi,
                  child: elementalDamage.damageSendBuilder(
                    _onStepCompleted,
                    widget.assetSize,
                  ),
                ),
              )
          ],
        );
      case DamageAnimationState.receiving:
        return Stack(
          children: [
            if (widget.direction == DamageDirection.topToBottom)
              _BottomAnimation(
                child: Transform.translate(
                  offset: Offset(
                    0.3 * widget.size.width,
                    0.3 * widget.size.height,
                  ),
                  child: elementalDamage.damageReceiveBuilder(
                    _onStepCompleted,
                    widget.assetSize,
                  ),
                ),
              )
            else
              Transform.translate(
                offset: -Offset(
                  0.3 * widget.size.width,
                  0.3 * widget.size.height,
                ),
                child: elementalDamage.damageReceiveBuilder(
                  _onStepCompleted,
                  widget.assetSize,
                ),
              )
          ],
        );
      case DamageAnimationState.waitingVictory:
        return const SizedBox.shrink(key: Key('elementalDamage_empty'));
      case DamageAnimationState.victory:
        return Stack(
          children: [
            if (widget.direction == DamageDirection.topToBottom)
              Transform.translate(
                offset: -Offset(
                  0.25 * widget.size.width,
                  0.11 * widget.size.height,
                ),
                child: DualAnimation(
                  cardOffset: Offset(
                    0.25 * widget.size.width,
                    0.11 * widget.size.height,
                  ),
                  cardSize: widget.size,
                  back: elementalDamage.victoryChargeBackBuilder,
                  front: elementalDamage.victoryChargeFrontBuilder,
                  assetSize: widget.assetSize,
                  onComplete: _onStepCompleted,
                ),
              )
            else
              _BottomAnimation(
                child: Transform.translate(
                  offset: Offset(
                    0.255 * widget.size.width,
                    0.115 * widget.size.height,
                  ),
                  child: DualAnimation(
                    cardOffset: Offset(
                      0.25 * widget.size.width,
                      0.11 * widget.size.height,
                    ),
                    cardSize: widget.size,
                    back: elementalDamage.victoryChargeBackBuilder,
                    front: elementalDamage.victoryChargeFrontBuilder,
                    assetSize: widget.assetSize,
                    onComplete: _onStepCompleted,
                  ),
                ),
              )
          ],
        );
      case DamageAnimationState.ended:
        return const SizedBox.shrink(key: Key('elementalDamage_empty'));
    }
  }

  Future<void> _onStepCompleted() async {
    if (_animationState == DamageAnimationState.charging) {
      widget.stepNotifier?._charged.complete();
      setState(() {
        _animationState = DamageAnimationState.sending;
      });
    } else if (_animationState == DamageAnimationState.sending) {
      widget.stepNotifier?._sent.complete();
      setState(() {
        _animationState = DamageAnimationState.receiving;
      });
    } else if (_animationState == DamageAnimationState.receiving) {
      setState(() {
        _animationState = DamageAnimationState.waitingVictory;
      });

      widget.stepNotifier?._received.complete();
      widget.onDamageReceived?.call();
      await widget.pointDeductionCompleter?.future;

      setState(() {
        _animationState = DamageAnimationState.victory;
      });
    } else if (_animationState == DamageAnimationState.victory) {
      widget.stepNotifier?._victory.complete();
      widget.onComplete?.call();
      setState(() {
        _animationState = DamageAnimationState.ended;
      });
    }
  }
}

class _BottomAnimation extends StatelessWidget {
  const _BottomAnimation({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      child: child,
    );
  }
}

/// State of the animation playing
enum DamageAnimationState {
  /// Charging animation
  charging,

  /// Sending animation
  sending,

  /// Receiving animation
  receiving,

  /// Waiting for victory animation
  waitingVictory,

  /// Victory animation
  victory,

  /// Animation ended
  ended
}

/// Represents the size that should be used for the assets
enum AssetSize {
  /// Represents small assets
  small,

  /// Represents large assets
  large
}

/// Represents the direction of the damages
enum DamageDirection {
  /// Represents the damages from top card to bottom card
  topToBottom,

  /// Represents the damages from bottom card to top card
  bottomToTop
}

/// Represents the element of damage animation
enum Element {
  /// Represents the element of metal.
  metal,

  /// Represents the element of water.
  water,

  /// Represents the element of air.
  air,

  /// Represents the element of fire.
  fire,

  /// Represents the element of earth.
  earth,
}
