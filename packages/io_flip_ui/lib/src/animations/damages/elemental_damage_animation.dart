import 'dart:async';
import 'dart:math';

import 'package:flame/sprite.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:io_flip_ui/io_flip_ui.dart';
import 'package:io_flip_ui/src/widgets/damages/dual_animation.dart';

T _platformAwareAsset<T>({
  required T desktop,
  required T mobile,
  bool isWeb = kIsWeb,
  TargetPlatform? overrideDefaultTargetPlatform,
}) {
  final platform = overrideDefaultTargetPlatform ?? defaultTargetPlatform;
  final isWebMobile = isWeb &&
      (platform == TargetPlatform.iOS || platform == TargetPlatform.android);

  return isWebMobile ? mobile : desktop;
}

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
    Future<void>.delayed(Duration(seconds: 2)).then((_) => widget.onComplete!());
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
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
