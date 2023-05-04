// ignore_for_file: prefer_const_constructors
import 'dart:math';

import 'package:game_domain/game_domain.dart';
import 'package:game_script_machine/game_script_machine.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockRandom extends Mock implements Random {}

Card _makeCard(Suit suit, [int power = 0]) => Card(
      id: 'id',
      name: 'name',
      description: 'description',
      image: 'image',
      power: power,
      rarity: false,
      suit: suit,
    );
// All the possible pairs of suits, where the first item wins.
const pairs = [
  [Suit.fire, Suit.air],
  [Suit.fire, Suit.metal],
  [Suit.air, Suit.water],
  [Suit.air, Suit.earth],
  [Suit.metal, Suit.water],
  [Suit.metal, Suit.air],
  [Suit.earth, Suit.fire],
  [Suit.earth, Suit.metal],
  [Suit.water, Suit.fire],
  [Suit.water, Suit.earth],
];

void main() {
  group('GameScriptMachine', () {
    test('can be instantiated', () {
      expect(GameScriptMachine.initialize(defaultGameLogic), isNotNull);
    });

    test('returns the currentScript', () {
      expect(
        GameScriptMachine.initialize(defaultGameLogic).currentScript,
        equals(defaultGameLogic),
      );
    });

    group('compare', () {
      test('correctly evaluates the result for different suits', () {
        final m = GameScriptMachine.initialize(defaultGameLogic);

        for (final pair in pairs) {
          final a = pair[0];
          final b = pair[1];
          expect(m.compareSuits(a, b), equals(1));
          expect(m.compareSuits(b, a), equals(-1));
        }
      });

      test('correctly evaluates the result for the same suit and value', () {
        final m = GameScriptMachine.initialize(defaultGameLogic);

        for (final suit in Suit.values) {
          final a = _makeCard(suit);
          final b = _makeCard(suit);
          expect(m.compare(a, b), equals(0));
          expect(m.compare(b, a), equals(0));
        }
      });

      test(
        'correctly evaluates the result for the same suit and different values '
        'when winning suit has higher value',
        () {
          final m = GameScriptMachine.initialize(defaultGameLogic);

          for (final suit in Suit.values) {
            final a = _makeCard(suit, 10);
            final b = _makeCard(suit, 3);
            expect(m.compare(a, b), equals(1));
            expect(m.compare(b, a), equals(-1));
          }
        },
      );

      test(
        'correctly evaluates the result for different suits and different '
        'values when winning suit has the lower value but modifier is not '
        'enough',
        () {
          final m = GameScriptMachine.initialize(defaultGameLogic);

          for (final pair in pairs) {
            final aSuit = pair[0];
            final bSuit = pair[1];
            final a = _makeCard(aSuit, 10);
            final b = _makeCard(bSuit, 22);
            expect(m.compare(a, b), equals(-1));
            expect(m.compare(b, a), equals(1));
          }
        },
      );

      test(
        'correctly evaluates the result for different suits and different '
        'values when winning suit has the lower value and the notfier is '
        'enough',
        () {
          final m = GameScriptMachine.initialize(defaultGameLogic);

          for (final pair in pairs) {
            final aSuit = pair[0];
            final bSuit = pair[1];
            final a = _makeCard(aSuit, 19);
            final b = _makeCard(bSuit, 20);
            expect(m.compare(a, b), equals(1));
            expect(m.compare(b, a), equals(-1));
          }
        },
      );
    });

    group('rollCardRarity', () {
      late GameScriptMachine machine;
      late Random rng;

      setUp(() {
        rng = _MockRandom();
        machine = GameScriptMachine.initialize(defaultGameLogic, rng: rng);
      });

      test('returns true if the double value is bigger than .99', () {
        when(() => rng.nextDouble()).thenReturn(.992);
        expect(machine.rollCardRarity(), isTrue);
      });

      test('returns false if the double value is less than .99', () {
        when(() => rng.nextDouble()).thenReturn(.4);
        expect(machine.rollCardRarity(), isFalse);
      });
    });

    group('rollCardPower', () {
      late GameScriptMachine machine;
      late Random rng;

      setUp(() {
        rng = _MockRandom();
        machine = GameScriptMachine.initialize(defaultGameLogic, rng: rng);
      });

      test(
        'returns a valid number if card is not rare and random is the lowest',
        () {
          when(() => rng.nextDouble()).thenReturn(0);
          expect(machine.rollCardPower(isRare: false), equals(10));
        },
      );

      test(
        'returns a valid number if card is not rare and random is the highest',
        () {
          when(() => rng.nextDouble()).thenReturn(1);
          expect(machine.rollCardPower(isRare: false), equals(99));
        },
      );

      test('returns a valid number if card is not rare', () {
        when(() => rng.nextDouble()).thenReturn(.8);
        expect(machine.rollCardPower(isRare: false), equals(81));
      });

      test('returns a valid number if card is not rare and too weak', () {
        when(() => rng.nextDouble()).thenReturn(.05);
        expect(machine.rollCardPower(isRare: false), equals(14));
      });

      test('returns a valid number if card is rare', () {
        when(() => rng.nextDouble()).thenReturn(.8);
        expect(machine.rollCardPower(isRare: true), equals(100));
      });
    });
  });
}
