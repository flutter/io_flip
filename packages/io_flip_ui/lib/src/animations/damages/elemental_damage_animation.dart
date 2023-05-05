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
/// A notifier that allows an external test to know when an [_AnimationState]
/// is complete
/// {@endtemplate}
@visibleForTesting
class ElementalDamageStepNotifier {
  final _charged = Completer<void>();
  final _sent = Completer<void>();
  final _received = Completer<void>();
  final _victory = Completer<void>();

  /// Future notifying when [_AnimationState.charging] is complete
  Future<void> get charged => _charged.future;

  /// Future notifying when [_AnimationState.sending] is complete
  Future<void> get sent => _sent.future;

  /// Future notifying when [_AnimationState.receiving] is complete
  Future<void> get received => _received.future;

  /// Future notifying when [_AnimationState.victory] is complete
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
    required this.size,
    this.assetSize = AssetSize.large,
    this.onComplete,
    this.stepNotifier,
    super.key,
  });

  /// Optional callback to be called when all the animations of the damage
  /// are complete.
  final VoidCallback? onComplete;

  /// Element defining which [ElementalDamage] to use
  final Element element;

  /// Direction of the damages
  final DamageDirection direction;

  /// Size of the card
  final GameCardSize size;

  /// Notifies when an [_AnimationState] is complete
  final ElementalDamageStepNotifier? stepNotifier;

  /// Size of the assets to use, large or small
  final AssetSize assetSize;

  @override
  State<ElementalDamageAnimation> createState() =>
      _ElementalDamageAnimationState();
}

class _ElementalDamageAnimationState extends State<ElementalDamageAnimation> {
  var _animationState = _AnimationState.charging;
  late final ElementalDamage elementalDamage;

  @override
  void initState() {
    super.initState();
    switch (widget.element) {
      case Element.metal:
        elementalDamage = widget.assetSize == AssetSize.large
            ? MetalDamage.large(size: widget.size)
            : MetalDamage.small(size: widget.size);
        break;
      case Element.air:
        elementalDamage = widget.assetSize == AssetSize.large
            ? AirDamage.large(size: widget.size)
            : AirDamage.small(size: widget.size);
        break;
      case Element.fire:
        elementalDamage = widget.assetSize == AssetSize.large
            ? FireDamage.large(size: widget.size)
            : FireDamage.small(size: widget.size);
        break;
      case Element.earth:
        elementalDamage = widget.assetSize == AssetSize.large
            ? EarthDamage.large(size: widget.size)
            : EarthDamage.small(size: widget.size);
        break;
      case Element.water:
        elementalDamage = widget.assetSize == AssetSize.large
            ? WaterDamage.large(size: widget.size)
            : WaterDamage.small(size: widget.size);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (_animationState) {
      case _AnimationState.charging:
        return Stack(
          children: [
            if (widget.direction == DamageDirection.topToBottom)
              Transform.translate(
                offset: -Offset(
                  0.356 * widget.size.width,
                  0.32 * widget.size.height,
                ),
                child: DualAnimation(
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
                    0.45 * widget.size.width,
                    0.21 * widget.size.height,
                  ),
                  child: DualAnimation(
                    back: elementalDamage.chargeBackBuilder,
                    front: elementalDamage.chargeFrontBuilder,
                    assetSize: widget.assetSize,
                    onComplete: _onStepCompleted,
                  ),
                ),
              )
          ],
        );
      case _AnimationState.sending:
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
      case _AnimationState.receiving:
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
      case _AnimationState.victory:
        return Stack(
          children: [
            if (widget.direction == DamageDirection.topToBottom)
              Transform.translate(
                offset: -Offset(
                  0.29 * widget.size.width,
                  0.11 * widget.size.height,
                ),
                child: DualAnimation(
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
                    0.28 * widget.size.width,
                    0.11 * widget.size.height,
                  ),
                  child: DualAnimation(
                    back: elementalDamage.victoryChargeBackBuilder,
                    front: elementalDamage.victoryChargeFrontBuilder,
                    assetSize: widget.assetSize,
                    onComplete: _onStepCompleted,
                  ),
                ),
              )
          ],
        );
      case _AnimationState.ended:
        widget.onComplete?.call();
        return const SizedBox.shrink();
    }
  }

  void _onStepCompleted() {
    if (_animationState == _AnimationState.charging) {
      widget.stepNotifier?._charged.complete();
      setState(() {
        _animationState = _AnimationState.sending;
      });
    } else if (_animationState == _AnimationState.sending) {
      widget.stepNotifier?._sent.complete();
      setState(() {
        _animationState = _AnimationState.receiving;
      });
    } else if (_animationState == _AnimationState.receiving) {
      widget.stepNotifier?._received.complete();
      setState(() {
        _animationState = _AnimationState.victory;
      });
    } else if (_animationState == _AnimationState.victory) {
      widget.stepNotifier?._victory.complete();
      setState(() {
        _animationState = _AnimationState.ended;
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

enum _AnimationState { charging, sending, receiving, victory, ended }

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
