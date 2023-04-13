// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:top_dash/how_to_play/how_to_play.dart';

void main() {
  group('HowToPlayState', () {
    test('can be instantiated', () {
      expect(HowToPlayState(), isNotNull);
    });

    test('supports equality', () {
      expect(
        HowToPlayState(),
        equals(HowToPlayState()),
      );

      expect(
        HowToPlayState(),
        isNot(equals(HowToPlayState(position: 1))),
      );

      expect(
        HowToPlayState(),
        isNot(equals(HowToPlayState(elementsWheelState: ElementsWheelAir()))),
      );
    });
  });

  group('ElementsWheelState', () {
    group('ElementsWheelFire', () {
      test('can be instantiated', () {
        expect(ElementsWheelFire(), isNotNull);
      });
    });

    group('ElementsWheelAir', () {
      test('can be instantiated', () {
        expect(ElementsWheelAir(), isNotNull);
      });
    });

    group('ElementsWheelMetal', () {
      test('can be instantiated', () {
        expect(ElementsWheelMetal(), isNotNull);
      });
    });

    group('ElementsWheelEarth', () {
      test('can be instantiated', () {
        expect(ElementsWheelEarth(), isNotNull);
      });
    });

    group('ElementsWheelWater', () {
      test('can be instantiated', () {
        expect(ElementsWheelWater(), isNotNull);
      });
    });

    test('supports equality', () {
      expect(
        ElementsWheelFire(),
        equals(ElementsWheelFire()),
      );

      expect(
        ElementsWheelFire(),
        isNot(equals(ElementsWheelAir())),
      );
    });
  });
}
