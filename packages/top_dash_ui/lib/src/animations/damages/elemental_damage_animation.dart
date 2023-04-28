import 'package:flutter/material.dart';
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
    required this.onComplete,
    required this.size,
    super.key,
  });

  /// Optional callback to be called when all the animations of the damage
  /// are complete.
  final VoidCallback onComplete;

  /// Element defining which [ElementalDamage] to use
  final Element element;

  /// Direction of the damages
  final DamageDirection direction;

  /// Size of the card
  final GameCardSize size;

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
                  onComplete: () => setState(() {
                    _animationState = _AnimationState.sending;
                  }),
                ),
              )
            else
              _BottomAnimation(
                child: DualAnimation(
                  back: elementalDamage.chargeBackBuilder,
                  front: elementalDamage.chargeFrontBuilder,
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
              Align(
                alignment: const Alignment(-0.7, 0.3),
                child: ColoredBox(
                  color: Colors.transparent,
                  child: elementalDamage.damageSendBuilder(
                    () => setState(() {
                      _animationState = _AnimationState.receiving;
                    }),
                  ),
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
                    _animationState = _AnimationState.charging;
                  }),
                ),
              )
            else
              _TopAnimation(
                child: elementalDamage.damageReceiveBuilder(
                  () => setState(() {
                    _animationState = _AnimationState.victory;
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
                  back: elementalDamage.victoryChargeBackBuilder,
                  front: elementalDamage.victoryChargeFrontBuilder,
                  onComplete: () => setState(() {
                    _animationState = _AnimationState.ended;
                  }),
                ),
              )
            else
              _BottomAnimation(
                child: DualAnimation(
                  back: elementalDamage.victoryChargeBackBuilder,
                  front: elementalDamage.victoryChargeFrontBuilder,
                  onComplete: () => setState(() {
                    _animationState = _AnimationState.ended;
                  }),
                ),
              )
          ],
        );
      case _AnimationState.ended:
        widget.onComplete();
        setState(() {
          _animationState = _AnimationState.charging;
        });
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
