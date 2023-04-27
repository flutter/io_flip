import 'dart:math' as math;

import 'package:flutter/animation.dart';
import 'package:flutter/rendering.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

/// A simple flip animation.
final smallFlipAnimation = CardAnimation(
  curve: Curves.easeOutExpo,
  duration: const Duration(milliseconds: 800),
  flipsCard: true,
  animatable: TransformTween(
    endRotateY: math.pi,
  ),
);

/// A flip that moves the card toward the viewer while it flips.
final bigFlipAnimation = CardAnimation(
  curve: Curves.ease,
  duration: const Duration(milliseconds: 800),
  flipsCard: true,
  animatable: TweenSequence<Matrix4>([
    TweenSequenceItem(
      tween: TransformTween(
        endTranslateZ: -100,
      ),
      weight: .2,
    ),
    TweenSequenceItem(
      tween: TransformTween(
        endRotateY: 3 * math.pi / 4,
        beginTranslateZ: -100,
        endTranslateZ: -300,
      ),
      weight: .6,
    ),
    TweenSequenceItem(
      tween: TransformTween(
        beginRotateY: 3 * math.pi / 4,
        endRotateY: math.pi,
        beginTranslateZ: -300,
        endTranslateZ: -200,
      ),
      weight: .2,
    ),
    TweenSequenceItem(
      tween: TransformTween(
        beginRotateY: math.pi,
        endRotateY: math.pi,
        beginTranslateZ: -200,
      ),
      weight: .1,
    ),
  ]),
);

/// A jump and rotate animation.
final jumpAnimation = CardAnimation(
  curve: Curves.slowMiddle,
  duration: const Duration(milliseconds: 400),
  animatable: ThereAndBackAgain(
    TransformTween(
      endTranslateZ: -300,
      endRotateX: -math.pi / 20,
      endRotateY: math.pi / 20,
      endRotateZ: -math.pi / 20,
    ),
  ),
);

/// An animation that moves the card to the bottom right,
/// as if it had been knocked out.
final knockOutAnimation = CardAnimation(
  curve: Curves.easeOut,
  duration: const Duration(milliseconds: 400),
  animatable: TransformTween(
    endTranslateX: 100,
    endTranslateY: 100,
    endTranslateZ: 100,
    endRotateZ: math.pi / 12,
  ),
);

/// An animation that causes the card to strike to the bottom right.
final attackAnimation = CardAnimation(
  duration: const Duration(seconds: 2),
  animatable: TweenSequence([
    TweenSequenceItem(
      tween: TransformTween(
        endTranslateZ: -50,
      ),
      weight: 0.1,
    ),
    TweenSequenceItem(
      tween: TransformTween(
        beginTranslateZ: -50,
        endTranslateZ: -100,
        endRotateZ: -math.pi / 30,
      ).chain(CurveTween(curve: Curves.easeIn)),
      weight: 0.4,
    ),
    TweenSequenceItem(
      tween: TransformTween(
        beginTranslateZ: -100,
        endTranslateZ: -100,
        endTranslateX: 50,
        endTranslateY: 50,
        beginRotateZ: -math.pi / 30,
      ).chain(CurveTween(curve: Curves.easeInExpo)),
      weight: 0.5,
    ),
    TweenSequenceItem(
      tween: TransformTween(
        beginTranslateZ: -300,
        endTranslateZ: -300,
        beginTranslateX: 50,
        beginTranslateY: 50,
        beginRotateZ: math.pi / 30,
      ),
      weight: 1,
    ),
  ]),
);
