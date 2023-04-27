import 'package:flutter/material.dart';
import 'package:top_dash_ui/src/animations/animations.dart';
import 'package:top_dash_ui/src/widgets/damages/dual_animation.dart';

/// {@template elemental_damage_animation}
/// A widget that renders a list of [SpriteAnimation] for a given element
/// {@endtemplate}
class ElementalDamageAnimation extends StatefulWidget {
  /// {@macro elemental_damage_animation}
  const ElementalDamageAnimation(
    this.element, {
    required this.direction,
    required this.onComplete,
    super.key,
  });

  /// Optional callback to be called when all the animations of the damage
  /// are complete.
  final VoidCallback? onComplete;

  /// Element defining which [ElementalDamage] to use
  final Element element;

  /// Direction of the damages
  final DamageDirection direction;

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
        elementalDamage = MetalDamage();
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
                  animationA: elementalDamage.chargeBackBuilder,
                  animationB: elementalDamage.chargeFrontBuilder,
                  onComplete: () => setState(() {
                    _animationState = _AnimationState.sending;
                  }),
                ),
              )
            else
              _BottomAnimation(
                child: DualAnimation(
                  animationA: elementalDamage.chargeBackBuilder,
                  animationB: elementalDamage.chargeFrontBuilder,
                  onComplete: () => setState(() {
                    _animationState = _AnimationState.sending;
                  }),
                ),
              )
          ],
        );
      case _AnimationState.sending:
        return Stack(
          children: [
            if (widget.direction == DamageDirection.topToBottom)
              _TopAnimation(
                child: elementalDamage.damageSendBuilder(
                  () => setState(() {
                    _animationState = _AnimationState.receiving;
                  }),
                ),
              )
            else
              _BottomAnimation(
                child: elementalDamage.damageSendBuilder(
                  () => setState(() {
                    _animationState = _AnimationState.receiving;
                  }),
                ),
              )
          ],
        );
      case _AnimationState.receiving:
        return Stack(
          children: [
            if (widget.direction == DamageDirection.topToBottom)
              _BottomAnimation(
                child: elementalDamage.damageReceiveBuilder(
                  () => setState(() {
                    _animationState = _AnimationState.receiving;
                  }),
                ),
              )
            else
              _TopAnimation(
                child: elementalDamage.damageReceiveBuilder(
                  () => setState(() {
                    _animationState = _AnimationState.receiving;
                  }),
                ),
              )
          ],
        );
      case _AnimationState.victory:
        return Stack(
          children: [
            if (widget.direction == DamageDirection.topToBottom)
              _TopAnimation(
                child: DualAnimation(
                  animationA: elementalDamage.victoryChargeBackBuilder,
                  animationB: elementalDamage.victoryChargeFrontBuilder,
                  onComplete: () {},
                ),
              )
            else
              _BottomAnimation(
                child: DualAnimation(
                  animationA: elementalDamage.victoryChargeBackBuilder,
                  animationB: elementalDamage.victoryChargeFrontBuilder,
                  onComplete: () {},
                ),
              )
          ],
        );
      case _AnimationState.ended:
        return const Placeholder();
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
}
