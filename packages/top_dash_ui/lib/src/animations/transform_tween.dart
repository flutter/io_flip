import 'package:flutter/animation.dart';
import 'package:flutter/rendering.dart';

/// {@template transform_tween}
/// A [Tween] that interpolates between [Matrix4]s, but
/// constructed using arguments for translation, rotation and scale.
/// {@endtemplate}
class TransformTween extends Tween<Matrix4> {
  /// {@macro transform_tween}
  TransformTween({
    this.beginRotateX = 0,
    this.endRotateX = 0,
    this.beginRotateY = 0,
    this.endRotateY = 0,
    this.beginRotateZ = 0,
    this.endRotateZ = 0,
    this.beginScale = 1,
    this.endScale = 1,
    this.beginTranslateX = 0,
    this.endTranslateX = 0,
    this.beginTranslateY = 0,
    this.endTranslateY = 0,
    this.beginTranslateZ = 0,
    this.endTranslateZ = 0,
  });

  /// The rotation around the x-axis at the beginning of the animation.
  final double beginRotateX;

  /// The rotation around the x-axis at the end of the animation.
  final double endRotateX;

  /// The rotation around the y-axis at the beginning of the animation.
  final double beginRotateY;

  /// The rotation around the y-axis at the end of the animation.
  final double endRotateY;

  /// The rotation around the z-axis at the beginning of the animation.
  final double beginRotateZ;

  /// The rotation around the z-axis at the end of the animation.
  final double endRotateZ;

  /// The scale at the beginning of the animation.
  final double beginScale;

  /// The scale at the end of the animation.
  final double endScale;

  /// The translation along the x-axis at the beginning of the animation.
  final double beginTranslateX;

  /// The translation along the x-axis at the end of the animation.
  final double endTranslateX;

  /// The translation along the y-axis at the beginning of the animation.
  final double beginTranslateY;

  /// The translation along the y-axis at the end of the animation.
  final double endTranslateY;

  /// The translation along the z-axis at the beginning of the animation.
  final double beginTranslateZ;

  /// The translation along the z-axis at the end of the animation.
  final double endTranslateZ;

  /// A [Tween] that gives the translation along the x-axis.
  Tween<double> get translateX => Tween(
        begin: beginTranslateX,
        end: endTranslateX,
      );

  /// A [Tween] that gives the translation along the y-axis.
  Tween<double> get translateY => Tween(
        begin: beginTranslateY,
        end: endTranslateY,
      );

  /// A [Tween] that gives the translation along the z-axis.
  Tween<double> get translateZ => Tween(
        begin: beginTranslateZ,
        end: endTranslateZ,
      );

  /// A [Tween] that gives the rotation around the x-axis.
  Tween<double> get rotateX => Tween(
        begin: beginRotateX,
        end: endRotateX,
      );

  /// A [Tween] that gives the rotation around the y-axis.
  Tween<double> get rotateY => Tween(
        begin: beginRotateY,
        end: endRotateY,
      );

  /// A [Tween] that gives the rotation around the z-axis.
  Tween<double> get rotateZ => Tween(
        begin: beginRotateZ,
        end: endRotateZ,
      );

  /// A [Tween] that gives the scale.
  Tween<double> get scale => Tween(
        begin: beginScale,
        end: endScale,
      );

  @override
  Matrix4? get begin => lerp(0);

  @override
  Matrix4? get end => lerp(1);

  @override
  Matrix4 lerp(double t) {
    return CardTransform(
      scale: scale.lerp(t),
      translateX: translateX.lerp(t),
      translateY: translateY.lerp(t),
      translateZ: translateZ.lerp(t),
      rotateX: rotateX.lerp(t),
      rotateY: rotateY.lerp(t),
      rotateZ: rotateZ.lerp(t),
    );
  }
}

/// {@template card_transform}
/// Wrapper around [Matrix4] that allows for easy construction of card
/// transformations.
/// {@endtemplate}
class CardTransform extends Matrix4 {
  /// {@macro card_transform}
  factory CardTransform({
    double rotateX = 0,
    double rotateY = 0,
    double rotateZ = 0,
    double scale = 1,
    double translateX = 0,
    double translateY = 0,
    double translateZ = 0,
  }) =>
      CardTransform._zero()
        ..setIdentity()
        ..setEntry(3, 2, 0.001)
        ..scale(scale)
        ..translate(translateX, translateY, translateZ)
        ..rotateX(rotateX)
        ..rotateY(rotateY)
        ..rotateZ(rotateZ);

  CardTransform._zero() : super.zero();
}
