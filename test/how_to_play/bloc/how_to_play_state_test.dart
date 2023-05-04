// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_flip/how_to_play/how_to_play.dart';
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
        isNot(equals(HowToPlayState(wheelSuits: const [Suit.air]))),
      );
    });

    test('copyWith returns a new instance with the copied values', () {
      expect(
        HowToPlayState().copyWith(position: 3),
        equals(HowToPlayState(position: 3)),
      );

      expect(
        HowToPlayState().copyWith(wheelSuits: const [Suit.air]),
        equals(HowToPlayState(wheelSuits: const [Suit.air])),
      );
    });
  });

  group('Suit', () {
    test('return icon correctly', () {
      expect(Suit.fire.icon.asset, equals(SuitIcon.fire().asset));
      expect(Suit.air.icon.asset, equals(SuitIcon.air().asset));
      expect(Suit.metal.icon.asset, equals(SuitIcon.metal().asset));
      expect(Suit.earth.icon.asset, equals(SuitIcon.earth().asset));
      expect(Suit.water.icon.asset, equals(SuitIcon.water().asset));
    });

    test('return initial alignment correctly', () {
      expect(
        Suit.fire.initialAlignment,
        equals(SuitAlignment.topCenter),
      );
      expect(
        Suit.air.initialAlignment,
        equals(SuitAlignment.centerRight),
      );
      expect(
        Suit.metal.initialAlignment,
        equals(SuitAlignment.bottomRight),
      );
      expect(
        Suit.earth.initialAlignment,
        equals(SuitAlignment.bottomLeft),
      );
      expect(
        Suit.water.initialAlignment,
        equals(SuitAlignment.centerLeft),
      );
    });

    test('return Suit affected correctly', () {
      expect(
        Suit.fire.suitsAffected,
        equals([Suit.air, Suit.metal]),
      );
      expect(
        Suit.air.suitsAffected,
        equals([Suit.water, Suit.earth]),
      );
      expect(
        Suit.metal.suitsAffected,
        equals([Suit.air, Suit.water]),
      );
      expect(
        Suit.earth.suitsAffected,
        equals([Suit.fire, Suit.metal]),
      );
      expect(
        Suit.water.suitsAffected,
        equals([Suit.fire, Suit.earth]),
      );
    });
  });
}
