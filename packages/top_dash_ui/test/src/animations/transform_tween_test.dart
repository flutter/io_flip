import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_flip_ui/top_dash_ui.dart';

void main() {
  group('TransformTween', () {
    group('translateX', () {
      test('interpolates correctly', () {
        final tween = TransformTween(beginTranslateX: 20, endTranslateX: 100);

        expect(tween.translateX.transform(0.5), equals(60));
      });
    });

    group('translateY', () {
      test('interpolates correctly', () {
        final tween = TransformTween(beginTranslateY: 20, endTranslateY: 100);

        expect(tween.translateY.transform(0.5), equals(60));
      });
    });

    group('translateZ', () {
      test('interpolates correctly', () {
        final tween = TransformTween(beginTranslateZ: 20, endTranslateZ: 100);

        expect(tween.translateZ.transform(0.5), equals(60));
      });
    });

    group('rotateX', () {
      test('interpolates correctly', () {
        final tween = TransformTween(beginRotateX: 0.5, endRotateX: 1.5);

        expect(tween.rotateX.transform(0.5), equals(1));
      });
    });

    group('rotateY', () {
      test('interpolates correctly', () {
        final tween = TransformTween(beginRotateY: 0.5, endRotateY: 1.5);

        expect(tween.rotateY.transform(0.5), equals(1));
      });
    });

    group('rotateZ', () {
      test('interpolates correctly', () {
        final tween = TransformTween(beginRotateZ: 0.5, endRotateZ: 1.5);

        expect(tween.rotateZ.transform(0.5), equals(1));
      });
    });

    group('scale', () {
      test('interpolates correctly', () {
        final tween = TransformTween(beginScale: 0.5, endScale: 1.5);

        expect(tween.scale.transform(0.5), equals(1));
      });
    });

    group('composed matrix', () {
      final tween = TransformTween(
        beginRotateX: 0.1,
        endRotateX: 0.3,
        beginRotateY: 0.5,
        endRotateY: 0.75,
        beginRotateZ: 0.2,
        endRotateZ: 0.5,
        beginScale: 0.5,
        endScale: 2,
        beginTranslateX: 20,
        endTranslateX: 100,
        beginTranslateY: 30,
        endTranslateY: 110,
        beginTranslateZ: 40,
        endTranslateZ: 120,
      );

      test('at beginning', () {
        expect(
          tween.begin,
          equals(
            Matrix4.zero()
              ..setIdentity()
              ..setEntry(3, 2, 0.001)
              ..scale(0.5)
              ..translate(20.0, 30, 40)
              ..rotateX(0.1)
              ..rotateY(0.5)
              ..rotateZ(0.2),
          ),
        );
      });

      test('at end', () {
        expect(
          tween.end,
          equals(
            Matrix4.zero()
              ..setIdentity()
              ..setEntry(3, 2, 0.001)
              ..scale(2.0)
              ..translate(100.0, 110, 120)
              ..rotateX(0.3)
              ..rotateY(0.75)
              ..rotateZ(0.5),
          ),
        );
      });

      test('lerp interpolates correctly', () {
        expect(
          tween.transform(0.5),
          equals(
            Matrix4.zero()
              ..setIdentity()
              ..setEntry(3, 2, 0.001)
              ..scale(1.25)
              ..translate(60.0, 70, 80)
              ..rotateX(0.2)
              ..rotateY(0.625)
              ..rotateZ(0.35),
          ),
        );
      });
    });
  });
}
