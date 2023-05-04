import 'package:flutter/animation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_flip_ui/top_dash_ui.dart';

void main() {
  group('ThereAndBackAgain', () {
    final tween = ThereAndBackAgain(Tween<double>(begin: 0, end: 1));

    test("begin returns parent's beginning", () {
      expect(tween.begin, equals(0));
    });

    test("end returns parent's beginning", () {
      expect(tween.end, equals(0));
    });

    group('lerp', () {
      test('at 0', () {
        expect(tween.lerp(0), equals(0));
      });

      test('at 0.25', () {
        expect(tween.lerp(0.25), equals(0.5));
      });

      test('at 0.5', () {
        expect(tween.lerp(0.5), equals(1));
      });

      test('at 0.75', () {
        expect(tween.lerp(0.75), equals(0.5));
      });

      test('at 1', () {
        expect(tween.lerp(1), equals(0));
      });
    });
  });
}
