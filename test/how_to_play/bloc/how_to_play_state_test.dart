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
        isNot(equals(HowToPlayState(wheelElements: const [Elements.air]))),
      );
    });

    test('copyWith returns a new instance with the copied values', () {
      expect(
        HowToPlayState().copyWith(position: 3),
        equals(HowToPlayState(position: 3)),
      );

      expect(
        HowToPlayState().copyWith(wheelElements: const [Elements.air]),
        equals(HowToPlayState(wheelElements: const [Elements.air])),
      );
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

    test('return elements affected correctly', () {
      expect(
        Elements.fire.elementsAffected,
        equals([Elements.air, Elements.metal]),
      );
      expect(
        Elements.air.elementsAffected,
        equals([Elements.water, Elements.earth]),
      );
      expect(
        Elements.metal.elementsAffected,
        equals([Elements.air, Elements.water]),
      );
      expect(
        Elements.earth.elementsAffected,
        equals([Elements.fire, Elements.metal]),
      );
      expect(
        Elements.water.elementsAffected,
        equals([Elements.fire, Elements.earth]),
      );
    });
  });
}
