import 'package:flutter/animation.dart';

/// {@template there_and_back_again}
/// A [Tween] that runs the given tween forward and then backward.
///
/// Also, A Hobbit's Tale.
/// {@endtemplate}
class ThereAndBackAgain<T> extends Tween<T> {
  /// {@macro there_and_back_again}
  ThereAndBackAgain(this._tween);

  final Tween<T> _tween;

  @override
  T? get begin => _tween.begin;

  @override
  T? get end => _tween.begin;

  @override
  T lerp(double t) {
    if (t < 0.5) {
      return _tween.lerp(t * 2);
    } else {
      return _tween.lerp(2 - t * 2);
    }
  }
}
