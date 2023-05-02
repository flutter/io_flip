import 'package:flutter/material.dart';
import 'package:top_dash_ui/src/animations/damages/air_damage.dart';
import 'package:top_dash_ui/src/animations/damages/earth_damage.dart';
import 'package:top_dash_ui/src/animations/damages/fire_damage.dart';
import 'package:top_dash_ui/src/animations/damages/water_damage.dart';
import 'package:top_dash_ui/src/widgets/damages/dual_animation.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

/// {@template elemental_damage_animation}
// ignore: comment_references
/// A widget that renders a list of [SpriteAnimation] for a given element
/// {@endtemplate}
class ElementalDamageAnimation extends StatefulWidget {
  /// {@macro elemental_damage_animation}
  const ElementalDamageAnimation(
    this.element, {
    required this.direction,
    required this.size,
    this.onComplete,
    this.loop = false,
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

  /// boolean that indicates if the aniamtion should repeat
  final bool loop;

  @override
  State<ElementalDamageAnimation> createState() =>
      _ElementalDamageAnimationState();
}

class _ElementalDamageAnimationState extends State<ElementalDamageAnimation> {
  var _animationState = _AnimationState.charging;
  late final ElementalDamage elementalDamage;

  @override
  void initState() {
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (_animationState) {
      case _AnimationState.charging:
        return Stack(
          children: [
            if (widget.direction == DamageDirection.topToBottom)
              _TopAnimation(
                child: DualAnimation(
                  back: elementalDamage.chargeBackBuilder,
                  front: elementalDamage.chargeFrontBuilder,
                  onComplete: _onStepCompleted,
                ),
              )
            else
              _BottomAnimation(
                child: DualAnimation(
                  back: elementalDamage.chargeBackBuilder,
                  front: elementalDamage.chargeFrontBuilder,
                  onComplete: _onStepCompleted,
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
                child: elementalDamage.damageSendBuilder(_onStepCompleted),
              )
            else
              _BottomAnimation(
                child: elementalDamage.damageSendBuilder(_onStepCompleted),
              )
          ],
        );
      case _AnimationState.receiving:
        return Stack(
          children: [
            if (widget.direction == DamageDirection.topToBottom)
              _BottomAnimation(
                child: elementalDamage.damageReceiveBuilder(_onStepCompleted),
              )
            else
              _TopAnimation(
                child: elementalDamage.damageReceiveBuilder(_onStepCompleted),
              )
          ],
        );
      case _AnimationState.victory:
        return Stack(
          children: [
            if (widget.direction == DamageDirection.topToBottom)
              _TopAnimation(
                child: DualAnimation(
                  back: elementalDamage.victoryChargeBackBuilder,
                  front: elementalDamage.victoryChargeFrontBuilder,
                  onComplete: _onStepCompleted,
                ),
              )
            else
              _BottomAnimation(
                child: DualAnimation(
                  back: elementalDamage.victoryChargeBackBuilder,
                  front: elementalDamage.victoryChargeFrontBuilder,
                  onComplete: _onStepCompleted,
                ),
              )
          ],
        );
      case _AnimationState.ended:
        widget.onComplete?.call();
        if (widget.loop) {
          setState(() {
            _animationState = _AnimationState.charging;
          });
        }
        return Container();
    }
  }

  void _onStepCompleted() {
    switch (_animationState) {
      case _AnimationState.charging:
        setState(() {
          _animationState = _AnimationState.sending;
        });
        break;
      case _AnimationState.sending:
        setState(() {
          _animationState = _AnimationState.receiving;
        });
        break;
      case _AnimationState.receiving:
        setState(() {
          _animationState = _AnimationState.victory;
        });
        break;
      case _AnimationState.victory:
        setState(() {
          _animationState = _AnimationState.ended;
        });
        break;
      case _AnimationState.ended:
    }
  }
}

class _TopAnimation extends StatelessWidget {
  const _TopAnimation({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      child: child,
    );
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
