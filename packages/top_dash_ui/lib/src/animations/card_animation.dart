import 'package:flutter/animation.dart';
import 'package:flutter/rendering.dart';

/// {@template card_animation}
/// Used to set the animation properties of an animated card.
/// {@endtemplate}
class CardAnimation {
  /// {@macro card_animation}
  const CardAnimation({
    required this.animatable,
    required this.duration,
    this.curve = Curves.linear,
    this.flipsCard = false,
  });

  /// The animation to be used.
  final Animatable<Matrix4> animatable;

  /// The duration of the animation.
  final Duration duration;

  /// The curve of the animation. Defaults to [Curves.linear].
  final Curve curve;

  /// Whether this animation causes the card to flip.
  final bool flipsCard;
}
