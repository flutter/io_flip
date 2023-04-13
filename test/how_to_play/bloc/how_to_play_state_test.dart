// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:top_dash/how_to_play/how_to_play.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

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

    test('copyWith returns a new instance with the copied values', () {
      expect(
        HowToPlayState().copyWith(position: 3),
        equals(HowToPlayState(position: 3)),
      );

      expect(
        HowToPlayState().copyWith(elementsWheelState: ElementsWheelAir()),
        equals(HowToPlayState(elementsWheelState: ElementsWheelAir())),
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

    test('returns affected indicator indexes correctly', () {
      expect(ElementsWheelFire().affectedIndicatorIndexes, equals([0, 1]));
    });
  });

  group('Elements', () {
    test('return icon correctly', () {
      expect(Elements.fire.icon.asset, equals(ElementIcon.fire().asset));
      expect(Elements.air.icon.asset, equals(ElementIcon.air().asset));
      expect(Elements.metal.icon.asset, equals(ElementIcon.metal().asset));
      expect(Elements.earth.icon.asset, equals(ElementIcon.earth().asset));
      expect(Elements.water.icon.asset, equals(ElementIcon.water().asset));
    });

    test('return initial alignment correctly', () {
      expect(
        Elements.fire.initialAlignment,
        equals(ElementAlignment.topCenter),
      );
      expect(
        Elements.air.initialAlignment,
        equals(ElementAlignment.centerRight),
      );
      expect(
        Elements.metal.initialAlignment,
        equals(ElementAlignment.bottomRight),
      );
      expect(
        Elements.earth.initialAlignment,
        equals(ElementAlignment.bottomLeft),
      );
      expect(
        Elements.water.initialAlignment,
        equals(ElementAlignment.centerLeft),
      );
    });
  });
}
